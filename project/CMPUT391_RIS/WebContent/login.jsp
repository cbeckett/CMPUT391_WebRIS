
<HTML>

<HEAD>
<TITLE>RIS - Login</TITLE>
</HEAD>

<BODY>

	<%@ page
		import="java.sql.*,
                java.io.InputStream, 
                java.io.IOException,
                java.util.Properties,
                org.ris.Database"%>
	<%
		if (request.getParameter("bSubmit") != null) {

			//Get the user input from the login page
			String userName = (request.getParameter("USERID")).trim();
			String passwd = (request.getParameter("PASSWD")).trim();

			//Establish the connection to db
			Connection databaseConnection = Database.requestConnection();

			if (databaseConnection != null) {
				//Query for user info
				Statement stmt = null;
				ResultSet rset = null;
				String sql = "SELECT password, class FROM users WHERE user_name = '"
						+ userName + "'";
				try {
					stmt = databaseConnection.createStatement();
					rset = stmt.executeQuery(sql);
				} catch (Exception ex) {
					out.println("<p>" + ex.getMessage() + "<p>");
				}

				//Process results
				String truepwd = "";
				String userClass = "";
				while (rset != null && rset.next())
				{
					truepwd = (rset.getString("password")).trim();
					userClass = (rset.getString("class")).trim();
				}
				
				//Display the result
				if (!passwd.isEmpty() && passwd.equals(truepwd)) {
					//Store cookie on user's machine
					Cookie cookie = new Cookie("class", userClass);
					response.addCookie(cookie);
					cookie = new Cookie("userId", userName);
					//Redirect to welcome
					out.println("<p><b>Success!</b></p>");
					response.sendRedirect("search.jsp");

				} else {
					displayLoginForm(out);
	                out.println("<p><b>Username or password is invalid!</b></p>");
				}
				try {
					databaseConnection.close();
				} catch (Exception ex) {
					out.println("<hr>" + ex.getMessage() + "<hr>");
				}
			}
		} else {
			displayLoginForm(out);
		}
	%>

<%!
public void displayLoginForm(JspWriter out)
{
	try {
		out.println("<h2>Please Log-In</h2>");
	    out.println("<form method=post action=login.jsp>");
	    out.println("Username: <input type=text name=USERID maxlength=24><br>");
	    out.println("Password: <input type=password name=PASSWD maxlength=24><br>");
	    out.println("<input type=submit name=bSubmit value=Submit>");
	    out.println("</form>");
    } catch (IOException ex) {
        //TODO Log error
    }
}
%>


</BODY>
</HTML>

