
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
    //Delete the cookies
    Cookie cookie = new Cookie("class", null);
	cookie.setMaxAge(0);
	cookie.setPath("/");
    response.addCookie(cookie);
    cookie = new Cookie("personId", null);
    cookie.setMaxAge(0);
    cookie.setPath("/");
    response.addCookie(cookie);
    
    //Re-direct to log-in
    response.sendRedirect("login.jsp");
    %>


</BODY>
</HTML>

