package store.admin.hibernate;


import org.hibernate.event.spi.*;
import org.hibernate.persister.entity.EntityPersister;

public class CacheEventListener implements PostUpdateEventListener ,  PostInsertEventListener,PostDeleteEventListener{

    private static final long serialVersionUID = 1L;

    @Override
    public void onPostDelete(PostDeleteEvent event) {

        System.out.println("delete:"+event.getEntity().getClass()+":"+event.getEntity());
    }

    @Override
    public void onPostInsert(PostInsertEvent event) {
        System.out.println("insert...................");
    }

    @Override
    public void onPostUpdate(PostUpdateEvent arg0) {
        System.out.println("update...................");
    }

    @Override
    public boolean requiresPostCommitHanding(EntityPersister arg0) {
        System.out.println("here...................");
        return false;
    }




}