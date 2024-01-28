package E_02_JavaDBAppsIntroduction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class E05ChangeTownNamesCasing {
    private static final String SELECT_COUNT_TOWNS_BY_COUNTRY = "SELECT COUNT(name) AS count FROM towns WHERE country = ?";
    private static final String SELECT_TOWN_NAMES_BY_COUNTRY = "SELECT name FROM towns WHERE country = ?";
    private static final String UPDATE_TOWNS_BY_COUNTRY = "UPDATE towns SET name = UPPER(name) WHERE country = ?";

    public static void main(String[] args) throws SQLException {
        Connection connection = Connector.getMySQLConnection();
        Scanner scanner = new Scanner(System.in);
        String countryName = getCountryName(scanner);
        int resultCount = getResultCount(connection, countryName);
        updateTowns(connection, countryName);
        ResultSet towns = getTownsByCountry(connection, countryName);
        printResult(resultCount, towns);

    }

    private static int getResultCount(Connection connection, String countryName) throws SQLException {
        ResultSet count = getResultSet(connection, countryName);
        return getTownsCount(count);

    }

    private static int getTownsCount(ResultSet count) throws SQLException {
        if (count.next()) {
            return count.getInt("count");
        }
        return 0;
    }

    private static void printResult(int resultCount, ResultSet towns) throws SQLException {
        StringBuilder result = new StringBuilder();
        result.append(resultCount).append(" town names were affected.\n[");
        while (towns.next()) {
            result.append(towns.getString("name")).append(", ");
        }
        if (result.length() > 1) {
            result.delete(result.length() - 2, result.length());
        }
        result.append("]");
        System.out.println(result);
    }

    private static ResultSet getTownsByCountry(Connection connection, String countryName) throws SQLException {
        PreparedStatement selectNamesStatement = connection.prepareStatement(SELECT_TOWN_NAMES_BY_COUNTRY);
        selectNamesStatement.setString(1, countryName);
        return selectNamesStatement.executeQuery();
    }

    private static void updateTowns(Connection connection, String countryName) throws SQLException {
        PreparedStatement updateStatement = connection.prepareStatement(UPDATE_TOWNS_BY_COUNTRY);
        updateStatement.setString(1, countryName);
        updateStatement.executeUpdate();
    }

    private static ResultSet getResultSet(Connection connection, String countryName) throws SQLException {
        PreparedStatement countTownsStatement = connection.prepareStatement(SELECT_COUNT_TOWNS_BY_COUNTRY);
        countTownsStatement.setString(1, countryName);
        return countTownsStatement.executeQuery();
    }

    private static String getCountryName(Scanner scanner) {
        System.out.print("Enter country's name: ");
        return scanner.nextLine().trim();
    }
}