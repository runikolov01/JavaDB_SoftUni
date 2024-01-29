package E_02_JavaDBAppsIntroduction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class E8IncreaseMinionsAge {
    private static final String SET_MINIONS_WHERE_ID = "UPDATE minions SET age = age + 1, name = LOWER(name) WHERE id = ?";
    private static final String SELECT_NAME_AND_AGE_FROM_MINIONS = "SELECT name, age FROM minions";
    private static final String OUTPUT_PATTERN = "%s %s%n";

    public static void main(String[] args) throws SQLException {
        Connection connection = Connector.getMySQLConnection();

        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter minion`s ID, separated by space:");
        String input = scanner.nextLine();
        String[] minionIds = input.split(" ");

        for (String minionId : minionIds) {
            incrementAgeAndMakeNameLowercase(connection, Integer.parseInt(minionId));
        }

        printMinions(connection);

        scanner.close();
        connection.close();
    }

    private static void incrementAgeAndMakeNameLowercase(Connection connection, int minionId) throws SQLException {
        PreparedStatement preparedStatement = connection.prepareStatement(SET_MINIONS_WHERE_ID);
        preparedStatement.setInt(1, minionId);
        preparedStatement.executeUpdate();
        preparedStatement.close();
    }

    private static void printMinions(Connection connection) throws SQLException {
        PreparedStatement preparedStatement = connection.prepareStatement(SELECT_NAME_AND_AGE_FROM_MINIONS);
        ResultSet resultSet = preparedStatement.executeQuery();

        System.out.println("Names and Ages of Minions:");
        while (resultSet.next()) {
            String name = resultSet.getString("name");
            int age = resultSet.getInt("age");
            System.out.printf(OUTPUT_PATTERN, name, age);
        }

        resultSet.close();
        preparedStatement.close();
    }
}