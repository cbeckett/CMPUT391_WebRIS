<HTML>

<HEAD>
<TITLE>RIS - Upload</TITLE>
</HEAD>

<BODY>
    <%@ include file="navigation.html" %>    
    <jsp:include page="validation.jsp" >
            <jsp:param name="userClass" value="a"/>
    </jsp:include>
                
  <form NAME="form" action="UploadImage" ENCTYPE="multipart/form-data"   method="post" >
     <TABLE>
         <tr>
              <th>Upload File</th>
                  <td>
                   <input name="fileUploadAttr" id="filePath"  type="file" value="">
                 </td>
                  <td > 
                 <Input type="submit" value ="UploadFile"/>
                  </td>
          </tr>
    </TABLE>
 </form>
</BODY>
</HTML>