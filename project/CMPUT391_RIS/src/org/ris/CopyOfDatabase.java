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

public class CopyOfDatabase {
	private static final String PROPERTIES_LOCATION = "config.properties";
	/**
	 * Requests a connection instance to the database
	 * 
	 * @return Connection - A new connection to the database
	 */
	public static Connection requestConnection()
	{
		
		System.out.println(CopyOfDatabase.class.getClassLoader().getResourceAsStream(PROPERTIES_LOCATION));
		Properties prop = new Properties();
		Connection databaseConnection = null;
		try {
			prop.load(CopyOfDatabase.class.getClassLoader().getResourceAsStream(PROPERTIES_LOCATION));
			
			String dbstring = prop.getProperty("DATABASE_DRIVER") + "//" + 
					prop.getProperty("DATABASE_URL") + "/" + 
					prop.getProperty("DATABASE_NAME");	

			//Establish connection
			Class.forName(prop.getProperty("DATABASE_CLASS"));
			databaseConnection = DriverManager.getConnection(dbstring, prop.getProperty("DATABASE_USERNAME"), prop.getProperty("DATABASE_PASSWORD"));
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		}

		return databaseConnection;
	}
}
