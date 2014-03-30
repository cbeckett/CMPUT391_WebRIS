
<HTML>

<HEAD>
<TITLE>RIS - Upload</TITLE>
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
        
        displayUploadForm(out);
 
    %>

    <%!public void displayUploadForm(JspWriter out) {
        try {
            out.println("<form method=post action=user_management.jsp>");
            out.println("Uploading:<br>");
            out.println("<input type=submit name=fffSubmit value=Update>");
            out.println("</form>");
        } catch (IOException ex) {
            //TODO Log error
        }
    }%>
    
    

</BODY>
</HTML>

