package store.admin.interceptor;

import lombok.SneakyThrows;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import utils.web.Webs;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class ServletInterceptor extends HandlerInterceptorAdapter {

    @Override
    @SneakyThrows
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        if (request.getSession().getAttribute("user") == null) {
            request.getSession().setAttribute("loginIp", Webs.getIp(request));
        }
        return super.preHandle(request, response, handler);
    }

}
