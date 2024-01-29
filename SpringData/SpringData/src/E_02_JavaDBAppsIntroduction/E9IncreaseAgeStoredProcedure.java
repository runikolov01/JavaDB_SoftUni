package E_02_JavaDBAppsIntroduction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class E9IncreaseAgeStoredProcedure {
    private static final String SELECT_NAME_AGE_WHERE_ID = "SELECT name, age FROM minions WHERE id = ?";
    private static final String CALL_USP_GET_OLDER = "{call usp_get_older(?)}";

    public static void main(String[] args) {
        try (Connection connection = Connector.getMySQLConnection();
             Scanner scanner = new Scanner(System.in);
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_NAME_AGE_WHERE_ID);
             PreparedStatement callableStatement = connection.prepareCall(CALL_USP_GET_OLDER)) {

            System.out.print("Enter minion ID: ");
            int minionId = scanner.nextInt();

            callableStatement.setInt(1, minionId);
            callableStatement.execute();

            preparedStatement.setInt(1, minionId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String name = resultSet.getString("name");
                int age = resultSet.getInt("age");
                System.out.println("Minion Name: " + name);
                System.out.println("Minion Age: " + age);
            } else {
                System.out.println("Minion with ID " + minionId + " not found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}