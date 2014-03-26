
<HTML>
<HEAD>


<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>
<!--A simple example to demonstrate how to use JSP to 
    connect and query a database. 
    @author  Hong-Yu Zhang, University of Alberta
 -->
<%@ page import="java.sql.*" %>
<% 

        if(request.getParameter("bSubmit") != null)
        {

	        //get the user input from the login page
        	String userName = (request.getParameter("USERID")).trim();
	        String passwd = (request.getParameter("PASSWD")).trim();
        	out.println("<p>Your input User Name is "+userName+"</p>");
        	out.println("<p>Your input password is "+passwd+"</p>");


	        //establish the connection to the underlying database
        	Connection databaseConnection = null;
        	String dbstring = "jdbc:mariadb://" + 
        	"localhost:3307" + "/" + 
        			"ris";
        	String username = "root";
        	String pwd = "12345";
        	try {
    			databaseConnection = DriverManager.getConnection(dbstring, username, pwd);
    		} catch (SQLException e) {
    			 out.println("<hr>" + e.getMessage() + "<hr>");
    		}
	

	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
        	String sql = "select PWD from login where id = '"+userName+"'";
	        out.println(sql);
        	try{
	        	stmt = databaseConnection.createStatement();
		        rset = stmt.executeQuery(sql);
        	}
	
	        catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
        	}

	        String truepwd = "";
	
        	while(rset != null && rset.next())
	        	truepwd = (rset.getString(1)).trim();
	
        	//display the result
	        if(passwd.equals(truepwd)) {
		        out.println("<p><b>Your Login is Successful!</b></p>");
		        //Store cookie on user's machine
		        Cookie cookie = new Cookie("username", userName);
		        response.addCookie(cookie);
		        
	        }
        	else
	        	out.println("<p><b>Either your userName or Your password is inValid!</b></p>");

                try{
                	databaseConnection.close();
                }
                catch(Exception ex){
                        out.println("<hr>" + ex.getMessage() + "<hr>");
                }
        }
        else
        {
                out.println("<form method=post action=login.jsp>");
                out.println("UserName: <input type=text name=USERID maxlength=20><br>");
                out.println("Password: <input type=password name=PASSWD maxlength=20><br>");
                out.println("<input type=submit name=bSubmit value=Submit>");
                out.println("</form>");
        }      
%>



</BODY>
</HTML>

