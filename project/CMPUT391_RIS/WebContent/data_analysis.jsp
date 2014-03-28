
<HTML>

<HEAD>
<TITLE>RIS - Data Analysis</TITLE>
</HEAD>

<BODY>
    <%@ include file="navigation.html" %>
    <%@ page
        import="java.sql.*,
                java.io.InputStream, 
                java.io.IOException,
                java.util.Properties,
                org.ris.Database"%>
    <%
        displayAnalysisForm(out);
    
        if (request.getParameter("bSubmit") != null) {

            //Get user permissions and validate
            Cookie[] cookies = request.getCookies();
            int cookieIndex = 0;
            //Re-direct early if no cookie exists
            if(cookies == null)
            	response.sendRedirect("login.jsp");
            //Get the user class cookie, check permissions
            while((cookies[cookieIndex++].getName() != "class") && cookieIndex < cookies.length);
            if((cookieIndex >= cookies.length) || !cookies[cookieIndex].getValue().equalsIgnoreCase("a"))
            	response.sendRedirect("login.jsp"); //Insufficient privilge, re-direct
            
            //Get the user input from the report form
            String firstName = (request.getParameter("FIRSTNAME")).trim();
            String lastName = (request.getParameter("LASTNAME")).trim();
            String testType = (request.getParameter("TESTTYPE")).trim();
            String numberImages = (request.getParameter("NUMBERIMAGES")).trim();
            String startDate = (request.getParameter("STARTDATE")).trim();
            String endDate = (request.getParameter("ENDDATE")).trim();

            //Set dates to default values if they were left empty
            if(startDate.isEmpty())
                startDate = "0001-01-01";
            if(endDate.isEmpty())
                endDate = "9999-12-31";
            if(numberImages.isEmpty())
            	numberImages = "3";
            
            //Establish the connection to db
            Connection databaseConnection = Database.requestConnection();

            if (databaseConnection != null) {
                //Query for images
                Statement stmt = null;
                ResultSet rset = null;
                String sql = "SELECT first_name, last_name, test_date, test_type, regular_size  " + 
                		"FROM persons, users, radiology_record, pacs_images " +
                		"WHERE users.class = 'p' AND " +
                		"persons.person_id = users.person_id AND " +
                		"radiology_record.patient_id = persons.person_id AND " +
                		"radiology_record.record_id = pacs_images.record_id AND " +
                		"radiology_record.test_date > \"" + startDate + "\" AND " +
                		"radiology_record.test_date < \"" + endDate + "\" AND " +
                		"persons.first_name LIKE \"%" + firstName + "%\" AND " +
                		"persons.last_name LIKE \"%" + lastName + "%\" AND " +
                		"radiology_record.test_type LIKE \"%" + testType + "%\" " + 
                		"LIMIT " + numberImages + ";";
                try {
                    stmt = databaseConnection.createStatement();
                    rset = stmt.executeQuery(sql);
                } catch (Exception ex) {
                    out.println("<p>" + ex.getMessage() + "<p>");
                }
                
                //Display results
               out.println("<table border=\"1\" style=\"width:600px\">");
               out.println("<tr>");
               out.println("<th>First Name</th>");
               out.println("<th>Last Name</th>");
               out.println("<th>Test Type</th>");
               out.println("<th>Test Date</th>");
               out.println("<th>Image</th>");
               out.println("</tr>");
               InputStream input;
               int imageByte;
                while (rset != null && rset.next()) {
                       out.println("<tr>");
                       out.println("<td>" + rset.getString("first_name") + "</td>");
                       out.println("<td>" + rset.getString("last_name") + "</td>");
                       out.println("<td>" + rset.getString("test_type") + "</td>");
                       out.println("<td>" + rset.getString("test_date") + "</td>");
                       out.print("<td>");
                       input = rset.getBinaryStream("regular_size");
                       response.setContentType("image/gif");
                       while((imageByte = input.read()) != -1)
                    	   out.write(imageByte);
                       response.setContentType("text/html");
                       out.print("</td>");
                       out.println("</tr>");
                }
                out.println("</table>");
                
                try {
                    databaseConnection.close();
                } catch (Exception ex) {
                    out.println("<hr>" + ex.getMessage() + "<hr>");
                }
            }
        }
    %>

    <%!public void displayAnalysisForm(JspWriter out) {
        try {
            out.println("<form method=post action=data_analysis.jsp>");
            out.println("Patient First Name: <input type=text name=FIRSTNAME maxlength=128><br>");
            out.println("Patient Last Name: <input type=text name=LASTNAME maxlength=128><br>");
            out.println("Test Type: <input type=text name=TESTTYPE maxlength=128><br>");
            out.println("Number of Images: <input type=text name=NUMBERIMAGES maxlength=128><br>");
            out.println("Start Date (yyyy-mm-dd): <input type=date name=STARTDATE><br>");
            out.println("End Date (yyyy-mm-dd): <input type=date name=ENDDATE><br>");
            out.println("<input type=submit name=bSubmit value=Submit>");
            out.println("</form>");
            ;
        } catch (IOException ex) {
            //TODO Log error
        }
    }%>


</BODY>
</HTML>

