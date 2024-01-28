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
        Connection connection = Connector.getMySQLConnection();

        final PreparedStatement preparedStatement = connection.prepareStatement(SELECT_VILLAINS_MINIONS_NUMBER);

        printResult(preparedStatement);

        connection.close();
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