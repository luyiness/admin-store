#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File              : deploy.py

import os
import io
import sys
import shlex
import pathlib
import yaml
import jinja2
import argparse
import subprocess
import datetime
#import pygit2
import kubernetes as kube

parser = argparse.ArgumentParser(description="OPS CICD script")
parser.add_argument("--cluster", type=str, default="", dest='cluster', help="the k8s cluster to oprate")
parser.add_argument("--env", type=str, default="test", dest='env', help="the k8s environment to oprate")
parser.add_argument("--rep", type=int, default=2, dest='rep', help="the replica of deployment")
parser.add_argument("--cpu", type=int, default=2, dest='cpu', help="the cpu limit of deployment")
parser.add_argument("--mem", type=int, default=4, dest='mem', help="the memory limit(GB) of deployment")
parser.add_argument("--app", type=str, default="", dest='app', help="the submodule to deploy")
parser.add_argument("--skipBuild", action="store_true", dest='skip_build', help="if skip mvn package")
parser.add_argument("--deployToMvn", action="store_true", dest='deploy_to_mvn', help="if deploy mvn package to repo")
parser.add_argument("--projectId", type=str, default="DEFAULT", dest='project_id', help="the project branch to deploy")
args = parser.parse_args()

#DOCKER_REGISTRY = "registry.cn-beijing.aliyuncs.com"
DOCKER_REGISTRY = "192.168.50.221:5000"

BUILD_VALUES_FILE = "deploy/deploy.config.yaml"
HOME_DIR = str(pathlib.Path.home())
KUBECONFIG_DIR = "{}/.kube".format(HOME_DIR)
K8S_SERVICE_TEMPLATE = '''
apiVersion: v1
kind: Service
metadata:
  name: VAR_APP_NAME
  namespace: VAR_NAMESPACE
  labels:
    app: VAR_APP_NAME
spec:
  ports:
  - port: 8080
  selector:
    app: VAR_APP_NAME
'''
K8S_DEPLOYMENT_TEMPLATE = '''
apiVersion: apps/v1
kind: Deployment
metadata:
  name: VAR_APP_NAME
  namespace: VAR_NAMESPACE
spec:
  replicas: 2
  selector:
    matchLabels:
      app: VAR_APP_NAME
  template:
    metadata:
      labels:
        app: VAR_APP_NAME
    spec:
      containers:
      - name: VAR_APP_NAME
        image: VAR_IMAGE_NAME
        env:
        - name: StartAt
          value: START_AT
        - name: apollo.cluster
          value: apollo.cluster
        resources:
            limits:
              cpu: "2"
              memory: "4Gi"
            requests:
              cpu: "0.1"
              memory: "1Gi"
        imagePullPolicy: Always
        ports:
        - containerPort: VAR_LISTEN_PORT
        volumeMounts:
        - name: app-log-storage
          mountPath: /export/Logs
        - name: host-time
          mountPath: /etc/localtime
      dnsConfig:
        options:
        - name: ndots
          value: "2"
        - name: single-reques
      volumes:
      - name: app-log-storage
        hostPath:
          path: /export/data/Logs
      - name: host-time
        hostPath:
          path: /etc/localtime
'''
JAVA_DOCKERFILE_TEMPLATE = '''
FROM 192.168.50.221:5000/jsptz/jdk8:centos7.4
ARG JAR_PATH
ARG JAR_FILE
ENV JAR_FILE=${JAR_FILE}
COPY ${JAR_PATH} /
ENTRYPOINT ["/tini", "--"]
CMD java {% for op in APP_ENTRYPOINT %}{{ op }} {% endfor %} -jar /${JAR_FILE}
'''

NGINX_DOCKERFILE_TEMPLATE = '''
FROM 192.168.50.221:5000/jsptz/nginx:centos7.4
{% if COPY_FILES is not none %}
{% for f in COPY_FILES %}
COPY {{ f.from }} {{ f.to }}
RUN chown -R nginx.nginx {{ f.to }}
{% endfor %}
{% endif %}
RUN rm -f /etc/nginx/conf.d/default.conf
RUN sed -i s/APP_NAME/{{ APP_NAME }}/g /etc/nginx/nginx.conf
{% for cf in CONFIG_FILES %}
COPY {{ cf }} /etc/nginx/conf.d/
{% endfor %}
RUN chmod -R 755 /usr/share/nginx/html
'''

TOMCAT_DOCKERFILE_TEMPLATE = '''
FROM 192.168.50.221:5000/jsptz/tomcat8:centos7.4
ARG WAR_PATH
ENV JAVA_OPTS "{{ WAR_OPTIONS|join(' ') }}"
COPY ${WAR_PATH} /export/apps/tomcat/webapps/
'''

'''
JAVA_DEFAULT_RUN_OPTIONS = [
        ]
'''
JAVA_DEFAULT_RUN_OPTIONS = []

def load_multi_deploy_config(path):
    stream = open(path, 'r', encoding="utf-8")
    return yaml.load_all(stream, Loader=yaml.Loader)

def print_output(stream):
    buf = io.BytesIO(stream)
    while True:
        line = buf.readline()
        if not line:
            break
        print(line.rstrip())

def run_bash(cmd_str):
    print_notify(cmd_str)
    cmd = shlex.split(cmd_str)
    pipe = subprocess.Popen(cmd, shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    line = pipe.stdout.readline()
    while line:
        print(line.strip().decode())
        line = pipe.stdout.readline()
    pipe.communicate()
    return pipe.returncode

def mvn_build(env, project_id, deploy_to_mvn):
    print_notify("Mvn Build Start")
    if project_id != "DEFAULT":
        if deploy_to_mvn:
            result = run_bash("mvn -e -U clean deploy -Dmaven.test.skip=true -P{} -DDEPLOY_ENV={} -DDEPLOY_PROJECTID={}".format(
                env, env, project_id))
        else:
            result = run_bash("mvn -e -U clean package -Dmaven.test.skip=true -P{} -DDEPLOY_ENV={} -DDEPLOY_PROJECTID={}".format(
                env, env, project_id))
    else:
        if deploy_to_mvn:
            result = run_bash("mvn -e -U clean deploy -Dmaven.test.skip=true -P{}".format(env))
        else:
            result = run_bash("mvn -e -U clean package -Dmaven.test.skip=true -P{}".format(env))

    if result != 0:
        print("Mvn Package Failed: ")
        sys.exit(1)
    print("Mvn Build Successed")

# image: 192.168.50.221:5000/test/ins-phone-fraud:20191225-1005-946966ae
def image_build_java(env_name, app_name, jar_file_path, java_run_options):
#    git_branch, git_id = get_git_info(".")
    image_repository = DOCKER_REGISTRY + "/jsptz-" + env_name + "/" + app_name
    datetime_str = datetime.datetime.now().strftime("%Y%m%d-%H%M")
#    image_tag = "{}-{}".format(datetime_str, git_id)
#    image_tag = "latest"
    image_tag = datetime_str
    image_name = image_repository + ":" + image_tag
    jar_file_name = os.path.basename(jar_file_path)

    run_bash("docker pull " + DOCKER_REGISTRY + "/jsptz/jdk8:centos7.4")
    render_dockerfile_java(java_run_options)
    result = run_bash("docker build . -t {} --build-arg JAR_PATH={} --build-arg JAR_FILE={}".format(image_name, jar_file_path, jar_file_name))
    if result != 0:
        print("Image Build Failed: ")
        sys.exit(1)
    else:
        print("Image Build Successed: " + image_name + "\n")

    result = subprocess.run(["docker", "push", image_name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result = run_bash("docker push {}".format(image_name))
    if result != 0:
        print("Image Push Failed: ")
        sys.exit(1)
    else:
        print("Image Push Successed: " + image_name + "\n")
    return image_name

def image_build_tomcat(env_name, app_name, war_file_path, tomcat_run_options):
    image_repository = DOCKER_REGISTRY + "/jsptz-" + env_name + "/" + app_name
    image_tag = datetime.datetime.now().strftime("%Y%m%d-%H%M")
#    image_tag = "latest"
    image_name = image_repository + ":" + image_tag
    war_file_name = os.path.basename(war_file_path)

    run_bash("docker pull " + DOCKER_REGISTRY + "/jsptz/tomcat8:centos7.4")
    render_dockerfile_tomcat(tomcat_run_options)
    result = run_bash("docker build . -t {} --build-arg WAR_PATH={}".format(image_name, war_file_path))
    if result != 0:
        print("Image Build Failed: ")
        sys.exit(1)
    else:
        print("Image Build Successed: " + image_name + "\n")

    result = subprocess.run(["docker", "push", image_name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result = run_bash("docker push {}".format(image_name))
    if result != 0:
        print("Image Push Failed: ")
        sys.exit(1)
    else:
        print("Image Push Successed: " + image_name + "\n")
    return image_name


# image: 192.168.50.221:5000/test/ins-phone-fraud:20191225-1005-946966ae
def image_build_nginx(env_name, app_name, copy_files, config_files):
#    git_branch, git_id = get_git_info(".")
    image_repository = DOCKER_REGISTRY + "/jsptz-" + env_name + "/" + app_name
#    image_tag = git_id
    datetime_str = datetime.datetime.now().strftime("%Y%m%d-%H%M")
#    image_tag = "{}-{}".format(datetime_str, git_id)
#    image_tag = "latest"
    image_tag = datetime_str
    image_name = image_repository + ":" + image_tag

    run_bash("docker pull " + DOCKER_REGISTRY + "/jsptz/nginx:centos7.4")
    if env_name == "test":
        global NGINX_DOCKERFILE_TEMPLATE
       # run_bash("docker pull " + DOCKER_REGISTRY + "/jsptz/nginx:pre")
       # NGINX_DOCKERFILE_TEMPLATE = NGINX_DOCKERFILE_TEMPLATE.replace("nginx:centos7.4", "nginx:pre")
    # # #
    render_dockerfile_nginx(app_name, copy_files, config_files)
    result = run_bash("docker build . -t {}".format(image_name))
    if result != 0:
        print("Image Build Failed: {}".format(str(result)))
        sys.exit(1)
    else:
        print("Image Build Successed: " + image_name + "\n")

    result = run_bash("docker push {}".format(image_name))
    if result != 0:
        print("Image Push Failed: ")
        sys.exit(1)
    else:
        print("Image Push Successed: " + image_name + "\n")
    return image_name

def get_git_info(path):
    repository_path = pygit2.discover_repository(path)
    repo = pygit2.Repository(repository_path)
    head = repo.head
    branch_name = head.shorthand
    commit = repo.revparse_single('HEAD')
    commit_id = commit.hex[:8]
    return branch_name, commit_id

def render_dockerfile_java(java_options):
    template = jinja2.Template(JAVA_DOCKERFILE_TEMPLATE)
    outputText = template.render(APP_ENTRYPOINT = java_options)

    with open("Dockerfile", "w") as f:
        f.write(outputText)

    return

def render_dockerfile_nginx(app_name, copy_files, config_files):
    template = jinja2.Template(NGINX_DOCKERFILE_TEMPLATE)
    outputText = template.render(APP_NAME=app_name, COPY_FILES=copy_files, CONFIG_FILES=config_files)
    with open("Dockerfile", "w") as f:
        f.write(outputText)

    return

def render_dockerfile_tomcat(war_options):
    template = jinja2.Template(TOMCAT_DOCKERFILE_TEMPLATE)
    outputText = template.render(WAR_OPTIONS=war_options)
    with open("Dockerfile", "w") as f:
        f.write(outputText)

    return

def check_jacoco(dply):
    discoveried = False
    for v in dply.spec.template.spec.volumes:
        if v.name == "jacoco":
            discoveried = True
    return discoveried

def deploy_to_k8s(cluster, env, namespace_prefix, app_name, listen_ports, image_name, health, output_path="deploy", replica=2, cpu=2, mem=4):
    # 如果指定service不存在，按clusterIP默认模版创建service
    # 如果指定service已存在，更新ports，**只增不删**
    namespace = namespace_prefix + "-" + env
    target_ports = listen_ports[:]
    if listen_ports:
        svc = check_k8s_service(cluster, namespace, app_name)
        if not svc :
            service_data = yaml.load(K8S_SERVICE_TEMPLATE, Loader=yaml.Loader)
            service_data["spec"]["ports"] = []
            for p in listen_ports:
                service_data["spec"]["ports"].append({"name": "tcp-"+str(p),"port": p})
            service_data["metadata"]["name"] = app_name
            service_data["metadata"]["namespace"] = namespace
            service_data["metadata"]["labels"]["app"] = app_name
            service_data["spec"]["selector"]["app"] = app_name
            with open(output_path + "/" + "k8s-service-{}.yaml".format(app_name), "w") as f:
                yaml.dump(service_data, f)
            if apply_to_k8s(cluster, output_path + "/" + "k8s-service-{}.yaml".format(app_name)):
                print("Deploy Service to K8S Successed")
        else:
            #print("Dont Modify Current Service")
            current_ports = svc.spec.ports
            for p in current_ports:
                #print(type(p))
                if not p.name:
                    p.name = "tcp-"+str(p.port)
                if p.port in target_ports:
                    target_ports.remove(p.port)
                    continue # 已存在port同时存在于配置的listen_ports中，跳过
                #else:
                    #if not p.node_port:
                    #    current_ports.remove(p)
                    #else:
                    #    print("NodePort can not be deleted")
                    #    sys.exit(1)

            for pp in target_ports:
                current_ports.append({"name": "tcp-"+str(pp),"port": pp})

            svc.spec.ports = current_ports
            update_svc_result = update_k8s_svc(cluster=cluster, namespace=namespace, name=app_name, body=svc)
            if not update_svc_result:
                print("Update Service Failed")
                sys.exit(1)
            print("Update Service Successed")

    # 如果指定deployment不存在，按deployment默认模板创建deployment
    # 如果指定deployment已存在，只更新启动时间、imagename、resourcelimits、ports
    dply = check_k8s_deployment(cluster=cluster, namespace=namespace, name=app_name)
    if not dply:
        deployment_data = yaml.load(K8S_DEPLOYMENT_TEMPLATE, Loader=yaml.Loader)
        deployment_data["metadata"]["name"] = app_name
        deployment_data["metadata"]["namespace"] = namespace
        deployment_data["spec"]["replicas"] = replica
        deployment_data["spec"]["selector"]["matchLabels"]["app"] = app_name
        deployment_data["spec"]["template"]["metadata"]["labels"]["app"] = app_name
        deployment_data["spec"]["template"]["spec"]["containers"][0]["name"] = app_name
        deployment_data["spec"]["template"]["spec"]["containers"][0]["env"][0]["name"] = "StartAt"
        deployment_data["spec"]["template"]["spec"]["containers"][0]["env"][0]["value"] = datetime.datetime.now().isoformat()
        deployment_data["spec"]["template"]["spec"]["containers"][0]["env"][1]["name"] = "apollo.cluster"
        deployment_data["spec"]["template"]["spec"]["containers"][0]["env"][1]["value"] = env
        deployment_data["spec"]["template"]["spec"]["containers"][0]["image"] = image_name
        deployment_data["spec"]["template"]["spec"]["containers"][0]["resources"]["limits"]["cpu"] = cpu
        deployment_data["spec"]["template"]["spec"]["containers"][0]["resources"]["limits"]["memory"] = str(mem)+"Gi"
        deployment_data["spec"]["template"]["spec"]["containers"][0]["ports"] = []

        if health:
            deployment_data["spec"]["template"]["spec"]["containers"][0]["readinessProbe"] = {
                    "failureThreshold": 60,
                    "httpGet": {
                        "path": health["uri"],
                        "port": health["port"],
                        "scheme": "HTTP"
                        },
                    "initialDelaySeconds": 10,
                    "periodSeconds": 3,
                    "successThreshold": 1,
                    "timeoutSeconds": 2
                    }
        else:
            print("###############")
            print(listen_ports)
            print(target_ports)
            print("###############")
            deployment_data["spec"]["template"]["spec"]["containers"][0]["readinessProbe"] = {
                    "failureThreshold": 60,
                    "tcpSocket": {
                        "port": listen_ports[0],
                        },
                    "initialDelaySeconds": 10,
                    "periodSeconds": 3,
                    "successThreshold": 1,
                    "timeoutSeconds": 2
                    }

        if listen_ports:
            for p in listen_ports:
                deployment_data["spec"]["template"]["spec"]["containers"][0]["ports"].append({"containerPort": p})

        # add jacoco test agent
        if env == "test":
            deployment_data["spec"]["template"]["spec"]["volumes"].append({"name": "jacoco","hostPath":{"path": "/opt/JaCoCo"}})
            deployment_data["spec"]["template"]["spec"]["containers"][0]["volumeMounts"].append({"mountPath":"/opt/JaCoCo", "name":"jacoco"})

        with open(output_path + "/" + "k8s-deployment-{}.yaml".format(app_name), "w") as f:
            yaml.dump(deployment_data, f)
        if apply_to_k8s(cluster, output_path + "/" + "k8s-deployment-{}.yaml".format(app_name)):
            print("Deploy Deployment to K8S Successed")

    else:
        dply.spec.replicas = replica
        dply.spec.template.spec.containers[0].env[0].value = datetime.datetime.now().isoformat()
        dply.spec.template.spec.containers[0].image = image_name
#        dply.spec.template.spec.containers[0].image_pull_policy = "IfNotPresent"
        dply.spec.template.spec.containers[0].image_pull_policy = "Always"
        dply.spec.template.spec.containers[0].resources.limits["cpu"] = str(cpu)
        dply.spec.template.spec.containers[0].resources.limits["memory"] = str(mem)+"Gi"
        dply.spec.template.spec.containers[0].ports = []
        if health:
            dply.spec.template.spec.containers[0].readiness_probe = {
                    "failureThreshold": 60,
                    "httpGet": {
                        "path": health["uri"],
                        "port": health["port"],
                        "scheme": "HTTP"
                        },
                    "initialDelaySeconds": 10,
                    "periodSeconds": 3,
                    "successThreshold": 1,
                    "timeoutSeconds": 2
                    }
        else:
             dply.spec.template.spec.containers[0].readiness_probe = {
                    "failureThreshold": 60,
                    "tcpSocket": {
                        "port": listen_ports[0],
                        },
                    "initialDelaySeconds": 10,
                    "periodSeconds": 3,
                    "successThreshold": 1,
                    "timeoutSeconds": 2
                    }

        for p in listen_ports:
            dply.spec.template.spec.containers[0].ports.append({"containerPort": p})

        found_single_request = False
        for o in dply.spec.template.spec.dns_config.options:
            if o.name == "single-request":
                found_single_request = True
        if not found_single_request:
            dply.spec.template.spec.dns_config.options.append({"name":"single-request"})
        # add jacoco test agent
        if env == "test" and not check_jacoco(dply):
            dply.spec.template.spec.volumes.append({"name": "jacoco","hostPath":{"path": "/opt/JaCoCo"}})
            dply.spec.template.spec.containers[0].volume_mounts.append({"mountPath":"/opt/JaCoCo", "name":"jacoco"})

        update_dply_response = update_k8s_deployment(cluster=cluster, namespace=namespace, name=app_name, body=dply)
        if not update_dply_response:
            print("Update Deployment Failed")
            sys.exit(1)
        print("Update Deployment Successed")

    # 清理旧版deployment
    old_dply = check_k8s_deployment(cluster=cluster, namespace=namespace, name=app_name+"-v1")
    if old_dply:
        delete_k8s_deployment(cluster=cluster, namespace=namespace, name=app_name+"-v1")

    return

def apply_to_k8s(cluster, f):
    result = run_bash(" kubectl --kubeconfig={} --context={} apply -f {}".format(KUBECONFIG_DIR+"/config", cluster, f))

    if result != 0:
        print("Deploy To K8S Failed: ")
        sys.exit(1)
    else:
        print("Deploy To K8S Successed: ")
        return True

def check_k8s_service(cluster, namespace, name):
    kube.config.load_kube_config(context=cluster)
    v1 = kube.client.CoreV1Api()
    try:
        svc = v1.read_namespaced_service(name=name,namespace=namespace)
    except kube.client.rest.ApiException as e:
        #print(e)
        return None
    return svc

def update_k8s_svc(cluster, namespace, name, body):
    kube.config.load_kube_config(context=cluster)
    core_v1 = kube.client.CoreV1Api()
    try:
        new_svc = core_v1.patch_namespaced_service(name=name,namespace=namespace,body=body)
    except kube.client.rest.ApiException as e:
        print(e)
        return False
    return new_svc

def check_k8s_deployment(cluster, namespace, name):
    kube.config.load_kube_config(context=cluster)
    apps_v1 = kube.client.AppsV1Api()
    try:
        deployment = apps_v1.read_namespaced_deployment(name=name,namespace=namespace)
    except kube.client.rest.ApiException as e:
        #print(e)
        return None
    return deployment

def update_k8s_deployment(cluster, namespace, name, body):
    kube.config.load_kube_config(context=cluster)
    apps_v1 = kube.client.AppsV1Api()
    try:
        new_deployment = apps_v1.patch_namespaced_deployment(name=name,namespace=namespace,body=body)
    except kube.client.rest.ApiException as e:
        print(e)
        return False
    return new_deployment

def delete_k8s_deployment(cluster, namespace, name):
    kube.config.load_kube_config(context=cluster)
    apps_v1 = kube.client.AppsV1Api()
    try:
        response = apps_v1.delete_namespaced_deployment(name=name,namespace=namespace)
    except kube.client.rest.ApiException as e:
        print(e)
        return False
    if response.status != "Success":
        print("Delete Old Deployment Failed: {}".format(response.message))
        return False
    return True

def print_notify(content):
    print("#"*(len(content)+6))
    print("   "+content)
    print("#"*(len(content)+6))


if __name__ == "__main__":
    all_values = load_multi_deploy_config(BUILD_VALUES_FILE)

    mvn_built = False
    for values in all_values:
        # project id for test
        if args.project_id != "DEFAULT":
            values["appName"] += "-{}".format(args.project_id)
            if values["appType"] == "nginx":
                conf_name = values["nginxConfigs"][0]
                conf_name = conf_name.replace('.conf', '') + "-{}".format(args.project_id) + ".conf"
                values["nginxConfigs"][0] = conf_name
        #####################
        if "appType" not in values or values["appType"] == "java":
            if not mvn_built and not args.skip_build:
                print_notify("Start Mvn Build")
                mvn_build(args.env, args.project_id, args.deploy_to_mvn)
                mvn_built = True
            if not args.app or values["appName"] == args.app :
                # add skywalking to default javaRunOptions
                hadSkywalking = False
                for jro in values["javaRunOptions"]:
                    if "skywalking" in jro:
                        hadSkywalking = True
                if not hadSkywalking:
                    values["javaRunOptions"].append("-javaagent:/skywalking-agent/skywalking-agent.jar")
                    values["javaRunOptions"].append("-Dskywalking.collector.backend_service={}".format(values["skywalkingCollector"]))
                    values["javaRunOptions"].append("-Dskywalking.agent.service_name={}-{}".format(values["appName"],args.env))

                # add java default run options
                values["javaRunOptions"] = values["javaRunOptions"] + JAVA_DEFAULT_RUN_OPTIONS
                # add jacoco test agent
                if args.env == "test":
                    values["javaRunOptions"].append("-javaagent:/opt/JaCoCo/lib/jacocoagent.jar=includes=*,output=tcpserver,port=8087,address=0.0.0.0")
                    values["listenPorts"].append(8087)
                if args.env == "uat":
                    values["javaRunOptions"].append("-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005")
                    values["listenPorts"].append(5005)
                print_notify("Start Image Build")
                image_name = image_build_java(args.env, values["appName"], values["jarFile"], values["javaRunOptions"])
                print_notify("Start Deploy To K8S")
                if not args.cluster:
                    args.cluster = args.env
                health_def = values["healthCheck"] if "healthCheck" in values else None
                deploy_to_k8s(args.cluster, args.env, values["nameSpacePrefix"], values["appName"], values["listenPorts"], image_name, health_def, replica=args.rep, cpu=args.cpu, mem=args.mem)
        elif values["appType"] == "nginx":
            print_notify("Start Image Build")
            image_name = image_build_nginx(args.env, values["appName"], values["copyFiles"], values["nginxConfigs"])
            print_notify("Start Deploy To K8S")
            if not args.cluster:
                args.cluster = args.env
            health_def = values["healthCheck"] if "healthCheck" in values else None
            deploy_to_k8s(args.cluster, args.env, values["nameSpacePrefix"], values["appName"], values["listenPorts"], image_name, health_def, replica=args.rep, cpu=args.cpu, mem=args.mem)
        elif values["appType"] == "tomcat":
            if not mvn_built and not args.skip_build:
                print_notify("Start Mvn Build")
                mvn_build(args.env, args.project_id, args.deploy_to_mvn)
                mvn_built = True
            if not args.app or values["appName"] == args.app :
                # add java default run options
                #values["javaRunOptions"] = values["javaRunOptions"] + JAVA_DEFAULT_RUN_OPTIONS
                # add jacoco test agent
                print_notify("Start Image Build")
                image_name = image_build_tomcat(args.env, values["appName"], values["warFile"], values["tomcatRunOptions"])
                print_notify("Start Deploy To K8S")
                if not args.cluster:
                    args.cluster = args.env
                health_def = values["healthCheck"] if "healthCheck" in values else None
                deploy_to_k8s(args.cluster, args.env, values["nameSpacePrefix"], values["appName"], values["listenPorts"], image_name, health_def, replica=args.rep, cpu=args.cpu, mem=args.mem)
