<HTML>

<HEAD>
<TITLE>RIS - Upload</TITLE>
</HEAD>

<BODY>
    <%@ include file="navigation.html" %>    
    <jsp:include page="validation.jsp" >
            <jsp:param name="userClass" value="r"/>
    </jsp:include>  
       <%
        //Check validation
        String validated = (String) request.getAttribute("validated");
        if(validated.equalsIgnoreCase("FALSE"))
            response.sendRedirect("access_denied.jsp");
            %>
  <form NAME="form" action="UploadImage" ENCTYPE="multipart/form-data" method="post" >
     <TABLE>       
                  <tr>
                  <td>File to upload: </td>
                  </tr>
                  <tr>
                  <td>
                   <input name="fileUploadAttr" id="filePath"  type="file" value="">
                   </td>
                 </tr>
                 <tr>
                 <td>
                 Record ID: <input type=number name=RECORDID>
                 Image ID: <input type=number name=IMAGEID>
                 </td>
                 </tr>
                  <tr > 
                  <td>
                 <Input type="submit" value ="UploadFile"/>
                 </td>
                  </tr>
    </TABLE>
 </form>
</BODY>
</HTML>