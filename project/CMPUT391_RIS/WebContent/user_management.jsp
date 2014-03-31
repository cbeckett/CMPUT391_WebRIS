
<HTML>

<HEAD>
<TITLE>RIS - User Management</TITLE>
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
    
        displayManagementForm(out);
    
        if (request.getParameter("fffSubmit") != null) {
            Statement stmt = null;
            ResultSet rset = null;
            ResultSet rsetdoc = null;
            //Get the user input from the report form
            String personID = (request.getParameter("PERSONID")).trim();
            String firstName = (request.getParameter("FIRSTNAME")).trim();
            String lastName = (request.getParameter("LASTNAME")).trim();
            String address = (request.getParameter("ADDRESS")).trim();
            String email = (request.getParameter("EMAIL")).trim();
            String pNumber = (request.getParameter("PNUMBER")).trim();
            String userName = (request.getParameter("USERNAME")).trim();
            String userPassword = (request.getParameter("PASSWORD")).trim();
            String userClass = (request.getParameter("CLASS")).trim();
            String registerDate = (request.getParameter("RDATE")).trim();
            String olddoctorID = (request.getParameter("ODOCTORID")).trim();
            String newdoctorID = (request.getParameter("NDOCTORID")).trim();
            String updater = (request.getParameter("UPDATER")).trim();
            String sql="";
            String sql1="";
            String sql2="";
            String sql3="";
            String sqldoc = "";
            if (updater.equals("UPDATE"))
                sql = "UPDATE persons, users, family_doctor SET ";
            if (updater.equals("ADD"))
                sql1 = "INSERT INTO persons VALUES ('";
                sql2 = "INSERT INTO users VALUES ('";
                sql3 = "INSERT INTO family_doctor VALUES ('";
            //Establish the connection to db
            Connection databaseConnection = Database.requestConnection();
            
            if (databaseConnection != null) {
            	int normcheck=0;
            	int doccheck=0;
            	//stmt = databaseConnection.createStatement();
                //rset = stmt.executeQuery("UPDATE persons SET first_name='asdthe3nd' WHERE person_id=11111");
                if (updater.equals("UPDATE")){
	            	if (firstName!=""){
	            		sql = (sql + "persons.first_name='"+firstName+"',");
	            		normcheck=1;
	                }
	            	if (lastName!=""){
	            		sql = (sql + "persons.last_name='"+lastName+"',");
	            		normcheck=1;
	                }
	            	if (address!=""){
	            		sql = (sql + "persons.address='"+address+"',");
	            		normcheck=1;
	                }
	            	if (email!=""){
	            		sql = (sql + "persons.email='"+email+"',");
	            		normcheck=1;
	                }
	            	if (pNumber!=""){
	            		sql = (sql + "persons.phone='"+pNumber+"',");
	            		normcheck=1;
	                }
	            	if (userName!=""){
	            		sql = (sql + "users.user_name='"+userName+"',");
	            		normcheck=1;
	                }
	            	if (userPassword!=""){
	            		sql = (sql + "users.password='"+userPassword+"',");
	            		normcheck=1;
	                }
	            	if (userClass!=""){
	            		sql = (sql + "users.person_id='"+userClass+"',");
	            		normcheck=1;
	                }
	                if (olddoctorID!="" && newdoctorID!=""){
	                	sqldoc = ("UPDATE family_doctor SET doctor_id='"+newdoctorID+"' WHERE patient_id='"+personID+"' AND doctor_id='"+olddoctorID+"'");
	                	doccheck=1;
	                	   }
	            	sql = sql.substring(0, sql.length()-1);
	            	sql = (sql + "WHERE persons.person_id='"+personID+"' AND persons.person_id=users.person_id");
                }
                else{
                	if (!firstName.isEmpty() && !lastName.isEmpty() && !address.isEmpty() && !email.isEmpty() && !pNumber.isEmpty() && !userName.isEmpty() && !userPassword.isEmpty() && !userClass.isEmpty() && !newdoctorID.isEmpty()){
                		sql1=sql1+personID+"' ,'"+firstName+"', '"+lastName+"', '"+address+"', '"+email+"', '"+pNumber+"')";
                		sql2=sql2+userName+"', '"+userPassword+"', '"+userClass+"', '"+personID+"', '"+registerDate+"')";
                		sql3=sql3+newdoctorID+"', '"+personID+"')";
                	    }
            }
            	try {
                    stmt = databaseConnection.createStatement();
                    if (updater.equals("UPDATE")){
                    	if (normcheck==1)
                    		   rset = stmt.executeQuery(sql);
                    	if (doccheck==1)
                    		   rsetdoc = stmt.executeQuery(sqldoc);
                    }
                    else if(updater.equals("ADD")){
                    	rset = stmt.executeQuery(sql1);
                    	rset = stmt.executeQuery(sql2);
                    	rset = stmt.executeQuery(sql3);
                    }
                } catch (Exception ex) {
                    out.println("<p>" + ex.getMessage() + "<p>");
                if (olddoctorID!="" || newdoctorID!=""){
                	sql = ("UPDATE family_doctor SET doctor_id='"+newdoctorID+"' WHERE patient_id='"+personID+"' AND doctor_id='"+olddoctorID+"'");
                	}
   				}          	
       		}
      	 }
    %>

    <%!public void displayManagementForm(JspWriter out) {
        try {
            out.println("<form method=post action=user_management.jsp>");
            out.println("Update <input type=radio name=\"UPDATER\"checked value=UPDATE>");
            out.println("Add <input type=radio name=\"UPDATER\" value=ADD><br>");
            out.println("Person ID to update:<br>");
            out.println("ID:           <input type=text name=PERSONID maxlength=128><br>");
            out.println("Information to update:<br>");
            out.println("First Name:   <input type=text name=FIRSTNAME maxlength=128><br>");
            out.println("Last Name:    <input type=text name=LASTNAME maxlength=128><br>");
            out.println("Address:      <input type=text name=ADDRESS maxlength=128><br>");
            out.println("E-mail:       <input type=number name=EMAIL maxlength=128><br>");
            out.println("Phone Number: <input type=number name=PNUMBER maxlength=128><br>");
            out.println("User Acount Info:<br>");
            out.println("User name:    <input type=number name=USERNAME maxlength=128><br>");
            out.println("Password:     <input type=number name=PASSWORD maxlength=128><br>");
            out.println("Class:        <input type=number name=CLASS maxlength=128><br>");
            out.println("Register Date:        <input type=date name=RDATE maxlength=128><br>");
            out.println("Doctor Information:<br>");
            out.println("Old Doctor ID: <input type=number name=ODOCTORID maxlength=128><br>");      
            out.println("New Doctor ID: <input type=number name=NDOCTORID maxlength=128><br>");   
            out.println("<input type=submit name=fffSubmit value=Update>");
            out.println("</form>");
        } catch (IOException ex) {
            //TODO Log error
        }
    }%>
    
</BODY>
</HTML>

