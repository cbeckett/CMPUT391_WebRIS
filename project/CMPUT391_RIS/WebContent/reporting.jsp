
<HTML>

<HEAD>
<TITLE>RIS - Reporting</TITLE>
</HEAD>

<BODY>

	<%@ page
		import="java.sql.*,
                java.io.InputStream, 
                java.io.IOException,
                java.util.Properties,
                org.ris.Database"%>
	<%
		displayReportForm(out);
	
		if (request.getParameter("bSubmit") != null) {

			//Get user permissions and validate
			Cookie[] cookies = request.getCookies();
			if(cookies != null)
			{
				
			}
			
			
			//Get the user input from the report form
			String diagnosis = (request.getParameter("DIAGNOSIS")).trim();
			String startDate = (request.getParameter("STARTDATE")).trim();
			String endDate = (request.getParameter("ENDDATE")).trim();

			//Establish the connection to db
			Connection databaseConnection = Database.requestConnection();

			if (databaseConnection != null) {
				//Query for user info
				Statement stmt = null;
				ResultSet rset = null;
				String sql = "SELECT first_name, last_name, address, phone, test_date " +  
						"FROM persons, users, radiology_record " +  
						"WHERE users.class = 'p' AND " +  
						"persons.person_id = users.person_id AND " +  
						"radiology_record.patient_id = persons.person_id AND " + 
						"radiology_record.diagnosis LIKE \"%" + diagnosis + "%\" AND " + 
						"radiology_record.test_date > \"" + startDate + "\" AND " + 
						"radiology_record.test_date < \"" + endDate + "\";";
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
               out.println("<th>Address</th>");
               out.println("<th>Phone</th>");
               out.println("<th>Test Date</th>");
               out.println("</tr>");
				while (rset != null && rset.next()) {
		               out.println("<tr>");
		               out.println("<td>" + rset.getString("first_name") + "</td>");
		               out.println("<td>" + rset.getString("last_name") + "</td>");
		               out.println("<td>" + rset.getString("address") + "</td>");
		               out.println("<td>" + rset.getString("phone") + "</td>");
		               out.println("<td>" + rset.getString("test_date") + "</td>");
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

	<%!public void displayReportForm(JspWriter out) {
		try {
			out.println("<form method=post action=reporting.jsp>");
			out.println("Diagnosis: <input type=text name=DIAGNOSIS maxlength=128><br>");
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

