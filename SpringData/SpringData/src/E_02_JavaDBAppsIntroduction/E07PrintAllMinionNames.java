package E_02_JavaDBAppsIntroduction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;

public class E07PrintAllMinionNames {
    private static final String SELECT_NAMES_FROM_MINIONS = "SELECT name FROM minions";

    public static void main(String[] args) throws SQLException {
        Connection connection = Connector.getMySQLConnection();
        LinkedList<String> minionNames = new LinkedList<>();

        final PreparedStatement preparedStatement = (connection.prepareStatement(SELECT_NAMES_FROM_MINIONS));
        ResultSet resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            minionNames.add(resultSet.getString("name"));
        }
        connection.close();

        int n = minionNames.size();
        for (int i = 0; i <= n / 2; i++) {
            System.out.println(minionNames.get(i));
            if (i != n - i - 1) {
                System.out.println(minionNames.get(n - i - 1));
            }
        }

    }
}