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

import java.awt.image.BufferedImage;
import java.io.*;

import javax.imageio.ImageIO;
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
	
	try {
	    //Parse the HTTP request to get the image stream
	    DiskFileUpload fu = new DiskFileUpload();
	    List<FileItem> FileItems = fu.parseRequest(request);
	    long size = 0;
	    FileItem imagePath = null;
	    String recordId="", imageId="";
	    String radioid = request.getParameter("RadioID");
	    // Process form items
	    for(FileItem item:FileItems) {
            String fieldName = item.getFieldName();
	        if(item.isFormField()) { 

	            if(fieldName.equalsIgnoreCase("RECORDID"))
	            	recordId = item.getString();
	            else if(fieldName.equalsIgnoreCase("IMAGEID"))
	            	imageId = item.getString();
	        } else { // file fields
	            if(fieldName.equalsIgnoreCase("fileUploadAttr"))
	            {
	            	imagePath = item;
	            	size = item.getSize();
	            }
	        }
	    }
	    
	    //Get the image stream
	    InputStream instream = imagePath.getInputStream();
	    BufferedImage image = ImageIO.read(instream);
	    BufferedImage fullsize = shrink(image, 1);
	    BufferedImage mediumsize=shrink(image, 2);
	    BufferedImage thumbnail=shrink(image, 5);
	    ByteArrayOutputStream fullpic = new ByteArrayOutputStream();
	    ByteArrayOutputStream medpic = new ByteArrayOutputStream();
	    ByteArrayOutputStream smallpic = new ByteArrayOutputStream();
	    ImageIO.write(thumbnail, "gif", fullpic);
	    InputStream thumb = new ByteArrayInputStream(fullpic.toByteArray());
	    ImageIO.write(mediumsize, "gif", medpic);
	    InputStream medium = new ByteArrayInputStream(medpic.toByteArray());
	    ImageIO.write(fullsize, "gif", smallpic);
	    InputStream full = new ByteArrayInputStream(smallpic.toByteArray());
            // Connect to the database
	    Connection databaseConnection = Database.requestConnection();

	    //Insert an empty blob into the table first. Note that you have to 
	    PreparedStatement stmt = databaseConnection.prepareStatement("INSERT into pacs_images values(" + recordId + ", " + imageId + ", ?, ?, ?)");
	    stmt.setBinaryStream(1,thumb,(int)size);
	    stmt.setBinaryStream(2,medium,(int)size);
	    stmt.setBinaryStream(3,full,(int)size);

           // execute the insert statement
        stmt.executeUpdate();
        stmt.executeUpdate("commit");
        databaseConnection.close();
	    response_message = "the file has been uploaded "+radioid;
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
    //shrink image by a factor of n, and return the shrinked image
    public static BufferedImage shrink(BufferedImage image, int n) {

        int w = image.getWidth() / n;
        int h = image.getHeight() / n;

        BufferedImage shrunkImage =
            new BufferedImage(w, h, image.getType());

        for (int y=0; y < h; ++y)
            for (int x=0; x < w; ++x)
                shrunkImage.setRGB(x, y, image.getRGB(x*n, y*n));

        return shrunkImage;
    }
}