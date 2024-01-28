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

        Connection connection = Connector.getMySQLConnection();

        System.out.print("Enter villain`s ID: ");
        final int inputNumber = Integer.parseInt(sc.next());

        ResultSet minionsCountSet = countMinions(inputNumber, connection);

        while (minionsCountSet.next()) {
            int currentNum = minionsCountSet.getInt("count");
            if (currentNum > 0) {

                final ResultSet villainNameSet = selectVillainName(connection, inputNumber);

                while (villainNameSet.next()) {
                    villainName = villainNameSet.getString("name");
                }
                final ResultSet minionsNameAndAgeSet = selectMinionsNameAndAge(connection, inputNumber);
                printResult(minionsNameAndAgeSet, villainName);

            } else {
                System.out.printf("No villain with ID %d exists in the database.", inputNumber);
            }
        }
        connection.close();
    }

    private static ResultSet countMinions(int inputNumber, Connection connection) throws SQLException {
        final PreparedStatement firstPreparedStatement = connection.prepareStatement(SELECT_COUNT_MINIONS);
        firstPreparedStatement.setInt(1, inputNumber);
        return firstPreparedStatement.executeQuery();
    }

    private static ResultSet selectVillainName(Connection connection, int inputNumber) throws SQLException {
        final PreparedStatement secondPreparedStatement = connection.prepareStatement(SELECT_VILLAIN_NAME);
        secondPreparedStatement.setInt(1, inputNumber);
        return secondPreparedStatement.executeQuery();
    }

    private static ResultSet selectMinionsNameAndAge(Connection connection, int inputNumber) throws SQLException {
        final PreparedStatement thirdPrepareStatement = connection.prepareStatement(SELECT_MINIONS_NAME_AND_AGE);
        thirdPrepareStatement.setInt(1, inputNumber);
        return thirdPrepareStatement.executeQuery();
    }

    private static void printResult(ResultSet minionsNameAndAgeSet, String villainName) throws SQLException {
        System.out.printf("Villain: %s%n", villainName);
        for (int number = 1; minionsNameAndAgeSet.next(); number++) {
            String name = minionsNameAndAgeSet.getString("name");
            int age = Integer.parseInt(minionsNameAndAgeSet.getString("age"));
            System.out.printf(PRINT_FORMAT, number, name, age);
        }
    }
}