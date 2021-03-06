
<HTML>

<HEAD>
<TITLE>RIS - Reporting</TITLE>
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
	    //Check validation
		String validated = (String) request.getAttribute("validated");
		if(validated.equalsIgnoreCase("FALSE"))
			response.sendRedirect("access_denied.jsp");
	
		displayReportForm(out, request);
		if (request.getParameter("bSubmit") != null) {
			//Get the user input from the report form
			String diagnosis = (request.getParameter("DIAGNOSIS")).trim();
			String startDate = (request.getParameter("STARTDATE")).trim();
			String endDate = (request.getParameter("ENDDATE")).trim();

			//Set dates to default values if they were left empty
			if(startDate.isEmpty())
				startDate = "0001-01-01";
			if(endDate.isEmpty())
				endDate = "9999-12-31";
			
			//Establish the connection to db
			Connection databaseConnection = Database.requestConnection();

			if (databaseConnection != null) {
				//Query for report data
				Statement stmt = null;
				ResultSet rset = null;
				String sql = "SELECT first_name, last_name, address, phone, test_date, diagnosis " +  
						"FROM persons, users, radiology_record " +  
						"WHERE users.class = 'p' AND " +  
						"persons.person_id = users.person_id AND " +  
						"radiology_record.patient_id = persons.person_id AND " + 
						"radiology_record.diagnosis LIKE \"%" + diagnosis + "%\" AND " + 
						"radiology_record.test_date BETWEEN \"" + startDate + "\" AND \"" + endDate + "\";";
				try {
					stmt = databaseConnection.createStatement();
					rset = stmt.executeQuery(sql);
				} catch (Exception ex) {
					out.println("<p>" + ex.getMessage() + "<p>");
				}

				//Display results
               out.println("<table border=\"1\" style=\"width:1000px\">");
               out.println("<tr>");
               out.println("<th>First Name</th>");
               out.println("<th>Last Name</th>");
               out.println("<th>Address</th>");
               out.println("<th>Phone</th>");
               out.println("<th>Test Date</th>");
               out.println("<th>Diagnosis</th>");
               out.println("</tr>");
				while (rset != null && rset.next()) {
		               out.println("<tr>");
		               out.println("<td>" + rset.getString("first_name") + "</td>");
		               out.println("<td>" + rset.getString("last_name") + "</td>");
		               out.println("<td>" + rset.getString("address") + "</td>");
		               out.println("<td>" + rset.getString("phone") + "</td>");
		               out.println("<td>" + rset.getString("test_date") + "</td>");
		               out.println("<td>" + rset.getString("diagnosis") + "</td>");
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

	<%!public void displayReportForm(JspWriter out, HttpServletRequest request) {
		try {
			//Get past form data (if exists)
			String diagnosis = (request.getParameter("DIAGNOSIS"));
            String startDate = (request.getParameter("STARTDATE"));
            String endDate = (request.getParameter("ENDDATE"));
            if(diagnosis == null)
            	diagnosis = "";
            if(startDate == null)
            	startDate = "";
            if(endDate == null)
            	endDate = "";
			
			out.println("<form method=post action=reporting.jsp>");
			out.print("Diagnosis: <input type=text name=DIAGNOSIS maxlength=128 value="+ diagnosis + "><br>");
			out.println("Start Date: <input type=date name=STARTDATE value="+ startDate + "><br>");
			out.println("End Date: <input type=date name=ENDDATE value="+ endDate + "><br>");
			out.println("<input type=submit name=bSubmit value=Submit>");
			out.println("</form>");
			;
		} catch (IOException ex) {
			//TODO Log error
		}
	}%>
	


</BODY>
</HTML>

