package E_02_JavaDBAppsIntroduction;

import java.sql.*;
import java.util.Properties;

public class Exercise01 {

    private static final String SELECT_VILLAINS_MINIONS_NUMBER = "SELECT v.name, COUNT(distinct m.name) AS count " +
            "FROM villains AS v " +
            "JOIN minions_db.minions_villains mv on v.id = mv.villain_id " +
            "JOIN minions_db.minions m on mv.minion_id = m.id " +
            "GROUP BY v.name " +
            "HAVING count > 15";

    public static void main(String[] args) throws SQLException {
        Properties userPass = new Properties();
        userPass.setProperty("user", "root");
        userPass.setProperty("password", "12345");

        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/minions_db", userPass);

        PreparedStatement preparedStatement = connection.prepareStatement(SELECT_VILLAINS_MINIONS_NUMBER);

        ResultSet resultSet = preparedStatement.executeQuery();
        while (resultSet.next()) {
            System.out.printf("%s %d%n", resultSet.getString("name"), resultSet.getInt("count"));
        }
    }
}
