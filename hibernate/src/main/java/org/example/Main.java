package org.example;

import org.example.exercises.Exercise_4;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class Main {
    private static SessionFactory sessionFactory = null;

    public static void main(String[] args) {
        sessionFactory = getSessionFactory();
        Session session = sessionFactory.openSession();
//        Exercise_1.run(session);
//        Exercise_2.runA(session);
//        Exercise_2.runB(session);
//        Exercise_3.run(session);
        Exercise_4.run(session);
        session.close();
    }

    private static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            Configuration configuration = new Configuration();
            sessionFactory =

                    configuration.configure().buildSessionFactory();
        }
        return sessionFactory;
    }
}