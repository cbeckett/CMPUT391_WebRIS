
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
     
    <jsp:include page="validation.jsp" >
            <jsp:param name="userClass" value="a"/>
    </jsp:include>
                
    <%
        
        displayAnalysisForm(out);
    
        if (request.getParameter("bSubmit") != null) {
            //Get the user input from the report form
            String firstName = (request.getParameter("FIRSTNAME")).trim();
            String lastName = (request.getParameter("LASTNAME")).trim();
            String testType = (request.getParameter("TESTTYPE")).trim();
            String time = (request.getParameter("TIME")).trim();
            String testYear = (request.getParameter("TESTYEAR")).trim();
            String testMonth = (request.getParameter("TESTMONTH")).trim();
            
            //Wildcard time values if necesary
            if(testYear.isEmpty())
            	testYear = "%";
            else    //Left pad with 0
            	testYear = String.format("%04d", Integer.valueOf(testYear));
            if(testMonth.isEmpty())
            	testMonth = "%";
            else
            	testMonth = String.format("%02d", Integer.valueOf(testMonth));
            
            //Establish the connection to db
            Connection databaseConnection = Database.requestConnection();

            if (databaseConnection != null) {
                //Query for images
                Statement stmt = null;
                ResultSet rset = null;
                String sql = "SELECT COUNT(*) AS count, " +
                		"YEAR(radiology_record.test_date) AS year, " + 
                		"MONTH(radiology_record.test_date) AS month, " +
                		"WEEKOFYEAR(radiology_record.test_date) AS week " +
                		"FROM persons, users, radiology_record, pacs_images " +
                		"WHERE users.class = 'p' AND " +
                		"persons.person_id = users.person_id AND " +
                		"radiology_record.patient_id = persons.person_id AND " +
                		"radiology_record.record_id = pacs_images.record_id AND " +
                		"persons.first_name LIKE \"%" + firstName + "%\" AND " +
                		"persons.last_name LIKE \"%" + lastName + "%\" AND " +
                		"radiology_record.test_type LIKE \"%" + testType + "%\" AND " +
                		"radiology_record.test_date LIKE \"" + testYear + "-" + testMonth + "-%\" "; 
                if(!time.isEmpty() && !time.equalsIgnoreCase("ALL"))
                {
                	sql = sql + "GROUP BY YEAR(radiology_record.test_date)";
                	if(time.equalsIgnoreCase("MONTH"))
                		sql += ", MONTH(radiology_record.test_date) ";
                	if(time.equalsIgnoreCase("MONTH"))
                        sql += ", MONTH(radiology_record.test_date),  WEEKOFYEAR(radiology_record.test_date)";
                	
                }
                sql += " ORDER BY radiology_record.test_date;"; 

                try {
                    stmt = databaseConnection.createStatement();
                    rset = stmt.executeQuery(sql);
                } catch (Exception ex) {
                    out.println("<p>" + ex.getMessage() + "<p>");
                }
                
                //Display results
               out.println("<table border=\"1\" style=\"width:600px\">");
               out.println("<tr>");
               out.println("<th>Image Count</th>");
               if(!time.equalsIgnoreCase("ALL"))
            	    out.println("<th>Year</th>");
               if(time.equalsIgnoreCase("MONTH"))
            	    out.println("<th>Month</th>");
               if(time.equalsIgnoreCase("WEEK"))
               {
            	   out.println("<th>Month</th>");
            	   out.println("<th>Week</th>");
               }
               out.println("</tr>");
                while (rset != null && rset.next()) {
                       out.println("<tr>");
                       out.println("<td>" + rset.getString("count") + "</td>");
                       if(!time.equalsIgnoreCase("ALL"))
                           out.println("<td>" + rset.getString("year") + "</td>");
	                   if(time.equalsIgnoreCase("MONTH"))
	                	   out.println("<td>" + rset.getString("month") + "</td>");
	                   if(time.equalsIgnoreCase("WEEK"))
	                   {
	                	   out.println("<td>" + rset.getString("month") + "</td>");
	                       out.println("<td>" + rset.getString("week") + "</td>");
	                   }
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
            out.println("Test Year: <input type=number name=TESTYEAR maxlength=128><br>");
            out.println("Test Month: <input type=number name=TESTMONTH maxlength=128><br>");
            out.println("Test Type: <input type=number name= maxlength=128><br>");
            out.println("Time:");
            out.println("All <input type=radio name=\"TIME\"checked value=ALL>");
            out.println("Year <input type=radio name=\"TIME\" value=YEAR>");
            out.println("Month <input type=radio name=\"TIME\" value=MONTH>");
            out.println("Week <input type=radio name=\"TIME\" value=WEEK><br>");
            out.println("<input type=submit name=bSubmit value=Submit>");
            out.println("</form>");
        } catch (IOException ex) {
            //TODO Log error
        }
    }%>

</BODY>
</HTML>

