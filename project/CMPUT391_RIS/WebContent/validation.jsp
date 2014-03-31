<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
    <%@ page
        import="java.sql.*,
                java.io.InputStream, 
                java.io.IOException,
                java.util.Properties"%>

	<%
	try {
		String userClass = request.getParameter("userClass");
		request.setAttribute("validated", "FALSE");
	    //Get user permissions and validate
	    Cookie[] cookies = request.getCookies();
	    Cookie classCookie = null;
	    //Re-direct early if no cookie exists
	    if(cookies == null)
	        response.sendRedirect("access_denied.jsp");
	    //Get the user class cookie, check permissions  
	    for(Cookie c : cookies)
	    {
	        if(c.getName().equalsIgnoreCase("class"))
	            classCookie = c;
	    }

	    if((classCookie != null) && classCookie.getValue().equalsIgnoreCase(userClass))
	        {
	    	request.setAttribute("validated", "TRUE");
	        }
	    } catch (IOException ex) {
            //TODO Log error
    }
    %>
</body>
</html>