import lombok.extern.slf4j.Slf4j;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;



@Slf4j
public class Main {

    public static void main(String[] args) {
        EntityManagerFactory entityManagerFactory = null;
        try {
            entityManagerFactory = Persistence.createEntityManagerFactory("uSystem");
        } catch (Exception e) {
            log.error("Error creating EntityManagerFactory: {}", e.getMessage(), e);
        } finally {
            if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
                entityManagerFactory.close();
            }
        }
    }
}