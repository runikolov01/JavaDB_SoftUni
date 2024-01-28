package E_02_JavaDBAppsIntroduction;

import java.sql.*;
import java.util.Properties;
import java.util.Scanner;

public class E02GetVillainsNames {

    private static final String SELECT_VILLAINS_MINIONS_NUMBER = "SELECT v.name, COUNT(distinct m.name) AS count " +
            "FROM villains AS v " +
            "JOIN minions_db.minions_villains mv on v.id = mv.villain_id " +
            "JOIN minions_db.minions m on mv.minion_id = m.id " +
            "GROUP BY v.name " +
            "HAVING count > 15 " +
            "ORDER BY count DESC";

    private static final String PRINT_FORMAT = "%s %d%n";

    public static void main(String[] args) throws SQLException {
        Connection connection = getMySQLConnection();

        final PreparedStatement preparedStatement = connection.prepareStatement(SELECT_VILLAINS_MINIONS_NUMBER);

        printResult(preparedStatement);

        connection.close();
    }

    private static Connection getMySQLConnection() throws SQLException {
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

    private static void printResult(PreparedStatement preparedStatement) throws SQLException {
        final ResultSet resultSet = preparedStatement.executeQuery();
        while (resultSet.next()) {
            final String name = resultSet.getString("name");
            final int count = resultSet.getInt("count");
            System.out.printf(PRINT_FORMAT, name, count);
        }
    }
}