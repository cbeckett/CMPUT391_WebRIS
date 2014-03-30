package org.ris;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Responsible for contacting and managing the database
 *
 */

public class Database {
	private static final String DATABASE_NAME = "ris";
	private static final String DATABASE_USERNAME = "root";
	private static final String DATABASE_PASSWORD = "password";
	private static final String DATABASE_URL = "localhost:3306";
	private static final String DATABASE_DRIVER = "jdbc:mariadb:";
	/**
	 * Requests a connection instance to the database
	 * 
	 * @return Connection - A new connection to the database
	 */
	public static Connection requestConnection()
	{
		Connection databaseConnection = null;

		try {
			String dbstring = DATABASE_DRIVER + "//" + 
					DATABASE_URL + "/" + 
					DATABASE_NAME;	

			//Establish connection
			Class.forName("org.mariadb.jdbc.Driver");
			databaseConnection = DriverManager.getConnection(dbstring, DATABASE_USERNAME, DATABASE_PASSWORD);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return databaseConnection;
	}
}
