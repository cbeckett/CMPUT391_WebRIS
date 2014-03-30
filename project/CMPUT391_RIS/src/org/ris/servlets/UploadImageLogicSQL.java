package org.ris.servlets;
/***
 *  A sample program to demonstrate how to upload an image file 
 *  from the client's disk via a web browser and then
 *  insert the image into a database table, using the Java servlet.
 *  
 *  This program is based on the sample program for CMPUT391,
 *  authored by Fan Dend, at University of Alberta.
 *  The main difference between the two is that this one
 *  uses a PrepredStatement to insert a tuple with Blob which is
 *  a natural way of populating Blob/Clob, but for some unknown
 *  reason, Oracle's JDBC does not support this approach since
 *  Oracle 9i.
 *                                                                       
 *  Licensed under the Apache License, Version 2.0 (the "License");         
 *  you may not use this file except in compliance with the License.        
 *  You may obtain a copy of the License at                                 
 *      http://www.apache.org/licenses/LICENSE-2.0                          
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *
 *  the table shall be created using the following
      CREATE TABLE photos (
            pic_id int,
	    pic  BLOB,
	    primary key(pic_id)
      )
 ***/

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.sql.*;
import java.util.*;

/**
 *  The package commons-fileupload-1.0.jar are downloaded from 
 *     http://jakarta.apache.org/commons/fileupload/ 
 *  and it has to be put under WEB-INF/lib/ directory. 
 *  Remember to add the jar file to your CLASSPATH.
*/
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.ris.Database;

public class UploadImageLogicSQL extends HttpServlet {
    public String response_message;

    public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

	String username = "yuan";
	String password = "*****";

	String drivername = "com.shifang.logicsql.jdbc.driver.LogicSqlDriver";
	String dbstring ="jdbc.logicsql@luscar:2000:database";
	
	try {
	    //Parse the HTTP request to get the image stream
	    DiskFileUpload fu = new DiskFileUpload();
	    List FileItems = fu.parseRequest(request);
	    
	    // Process the uploaded items, assuming only 1 image file uploaded
	    Iterator i = FileItems.iterator();
	    FileItem item = (FileItem) i.next();
	    while (i.hasNext() && item.isFormField()) {
		    item = (FileItem) i.next();
	    }
	    long size = item.getSize();

	    //Get the image stream
	    InputStream instream = item.getInputStream();
	    
            // Connect to the database
	    Connection databaseConnection = Database.requestConnection();

	    //Insert an empty blob into the table first. Note that you have to 
	    PreparedStatement stmt = databaseConnection.prepareStatement("insert into photos values(1, 2, ?, ?, ?)");
	    stmt.setBinaryStream(1,instream,(int)size);
	    stmt.setBinaryStream(2,instream,(int)size);
	    stmt.setBinaryStream(3,instream,(int)size);

           // execute the insert statement
            stmt.executeUpdate();
            stmt.executeUpdate("commit");
            databaseConnection.close();
	    response_message = "the file has been uploaded";
	} catch( Exception ex ) {
	    response_message = ex.getMessage();
	}

	//Output response to the client
	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 " +
		"Transitional//EN\">\n" +
		"<HTML>\n" +
		"<HEAD><TITLE>Upload Message</TITLE></HEAD>\n" +
		"<BODY>\n" +
		"<H1>" +
	        response_message +
		"</H1>\n" +
		"</BODY></HTML>");
	}

    /*
    /*   To connect to the specified database
     */
}