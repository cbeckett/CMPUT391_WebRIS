<HTML>

<HEAD>
<TITLE>RIS - Upload</TITLE>
</HEAD>

<BODY>
    <%@ include file="navigation.html" %>    
    <jsp:include page="validation.jsp" >
            <jsp:param name="userClass" value="a"/>
    </jsp:include>
                
  <form NAME="form" action="PictureBrowse" method="get" >
     <TABLE>
         <tr>
              <th>Search File</th><br>
                  <td > 
                  Search by Name
                 <input type=sName name=EMAIL maxlength=128>
                 <input type=text name=EMAIL maxlength=128>
                 <input type=text name=EMAIL maxlength=128> <br>
                 <input type=date name=SSTARTDATE>
                 <input type=date name=SENDDATE>
                 <Input type="submit" value ="Search"/>
                  </td>
          </tr>
    </TABLE>
 </form>
</BODY>
</HTML>