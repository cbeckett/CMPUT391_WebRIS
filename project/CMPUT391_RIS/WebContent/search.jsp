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
                  <td > 
                 Search by Patient ID
                 <input type=text name=sName maxlength=128><br>
                 Search by Diagnosis
                 <input type=text name=sDiagnosis maxlength=128><br>
                 Search by Description
                 <input type=text name=sDescription maxlength=128> <br>
                 Search by start date and end date<br>
                 Start Date
                 <input type=date name=SSTARTDATE><br>
                 End Date
                 <input type=date name=SENDDATE><br>
                 Sort by<br>
                 Date Ascending
                 <input type=radio name="SORT" value=ASC>
                 Date Descending
           		 <input type=radio name="SORT" value=DESC>
           		 Rank
           		 <input type=radio name="SORT" value=RANK><br>
                 <Input type="submit" value ="Search"/>
                  </td>
          </tr>
    </TABLE>
 </form>
</BODY>
</HTML>