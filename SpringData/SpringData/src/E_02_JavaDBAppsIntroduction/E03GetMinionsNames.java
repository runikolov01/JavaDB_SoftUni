package E_02_JavaDBAppsIntroduction;

import java.sql.*;
import java.util.Properties;
import java.util.Scanner;

public class E03GetMinionsNames {
    private static final String SELECT_COUNT_MINIONS = "SELECT COUNT(minions.name) AS count " +
            "FROM minions " +
            "JOIN minions_db.minions_villains mv on minions.id = mv.minion_id " +
            "JOIN minions_db.villains v on mv.villain_id = v.id " +
            "WHERE v.id = ?";

    private static final String SELECT_VILLAIN_NAME = "SELECT villains.name " +
            "FROM villains " +
            "WHERE id = ?";

    private static final String SELECT_MINIONS_NAME_AND_AGE = "SELECT minions.name, age " +
            "FROM minions " +
            "JOIN minions_db.minions_villains mv on minions.id = mv.minion_id " +
            "JOIN minions_db.villains v on mv.villain_id = v.id " +
            "WHERE v.id = ?";

    private static final String PRINT_FORMAT = "%d. %s %d%n";


    public static void main(String[] args) throws SQLException {
        Scanner sc = new Scanner(System.in);
        String villainName = "";

        Connection connection = getMySQLConnection();

        System.out.print("Enter villain`s ID: ");
        int inputNumber = Integer.parseInt(sc.next());

        ResultSet firstResultSet = countMinions(inputNumber, connection);

        while (firstResultSet.next()) {
            int currentNum = firstResultSet.getInt("count");
            if (currentNum > 0) {

                ResultSet secondResultSet = selectVillainName(connection, inputNumber);
                while (secondResultSet.next()) {
                    villainName = secondResultSet.getString("name");
                }
                System.out.printf("Villain: %s%n", villainName);

                ResultSet thirdResult = selectMinionsNameAndAge(connection, inputNumber);

                int number = 1;

                while (thirdResult.next()) {
                    String name = thirdResult.getString("name");
                    int age = Integer.parseInt(thirdResult.getString("age"));
                    System.out.printf(PRINT_FORMAT, number, name, age);
                    number++;
                }
            } else {
                System.out.printf("No villain with ID %d exists in the database.", inputNumber);
            }
        }
        connection.close();
    }

    private static Connection getMySQLConnection() throws SQLException {
        Properties userPass = new Properties();
        userPass.setProperty("user", "root");
        userPass.setProperty("password", "12345");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/minions_db", userPass);
        System.out.println("--------------------------------------------------");
        System.out.println("You are connected to the database successfully! :) ");
        System.out.println("--------------------------------------------------");

        return connection;
    }

    private static ResultSet countMinions(int inputNumber, Connection connection) throws SQLException {
        PreparedStatement firstPreparedStatement = connection.prepareStatement(SELECT_COUNT_MINIONS);
        firstPreparedStatement.setInt(1, inputNumber);
        return firstPreparedStatement.executeQuery();
    }

    private static ResultSet selectVillainName(Connection connection, int inputNumber) throws SQLException {
        PreparedStatement secondPreparedStatment = connection.prepareStatement(SELECT_VILLAIN_NAME);
        secondPreparedStatment.setInt(1, inputNumber);
        return secondPreparedStatment.executeQuery();
    }

    private static ResultSet selectMinionsNameAndAge(Connection connection, int inputNumber) throws SQLException {
        PreparedStatement thirdPrepareStatement = connection.prepareStatement(SELECT_MINIONS_NAME_AND_AGE);
        thirdPrepareStatement.setInt(1, inputNumber);
        return thirdPrepareStatement.executeQuery();
    }
}
