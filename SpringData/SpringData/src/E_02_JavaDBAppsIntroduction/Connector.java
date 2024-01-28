package E_02_JavaDBAppsIntroduction;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;

enum Connector {
    ;
    static Connection getMySQLConnection() throws SQLException {
        final Properties userPass = new Properties();
        System.out.println("Enter your database`s username: ");
        Scanner scanner = new Scanner(System.in);
        String userName = scanner.nextLine();
        userPass.setProperty("user", userName);
        System.out.println("Enter your database`s password: ");
        String pass = scanner.nextLine();
        userPass.setProperty("password", pass);

        final Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/minions_db", userPass);
        System.out.println("--------------------------------------------------");
        System.out.println("You are connected to the database successfully! :) ");
        System.out.println("--------------------------------------------------");
        System.out.println("The answer from the exercise is: ");
        System.out.println("--------------------------------------------------");

        return connection;
    }
}
