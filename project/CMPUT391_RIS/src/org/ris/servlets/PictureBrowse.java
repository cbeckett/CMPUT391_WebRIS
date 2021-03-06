package org.ris.servlets;

import java.io.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import org.ris.Database;

import java.sql.*;
import java.text.*;
import java.net.*;

/**
 *  A simple example to demonstrate how to use servlet to 
 *  query and display a list of pictures
 *
 *  @author  Li-Yan Yuan
 *
 */
public class PictureBrowse extends HttpServlet implements SingleThreadModel {
    
    /**
     *  Generate and then send an HTML file that displays all the thermonail
     *  images of the photos.
     *
     *  Both the thermonail and images will be generated using another 
     *  servlet, called GetOnePic, with the photo_id as its query string
     *
     */
    public void doGet(HttpServletRequest request,
		      HttpServletResponse res)
	throws ServletException, IOException {

	//  send out the HTML file
	res.setContentType("text/html");
	PrintWriter out = res.getWriter ();

	String sname = request.getParameter("sName");
	String sdiagnosis = request.getParameter("sDiagnosis");
	String sdescription = request.getParameter("sDescription");
	String SSTARTDATE = request.getParameter("SSTARTDATE");
	String SENDDATE = request.getParameter("SENDDATE");
	String SORT = request.getParameter("SORT");
	if (SORT==null)
		SORT="RANK";
	if(SSTARTDATE.isEmpty())
		SSTARTDATE = "0001-01-01";
	if(SENDDATE.isEmpty())
		SENDDATE = "9999-12-31";
	
	String userclass="";
	String userId="";
	
	Cookie[] cookies = request.getCookies();
	Cookie classCookie = null;
	Cookie userCookie = null;
	//Get the user class cookie, check permissions         
	for(int i = 0; i < cookies.length; i++)
		{
		    if(cookies[i].getName().equalsIgnoreCase("class"))
		        classCookie = cookies[i];
		    else if (cookies[i].getName().equalsIgnoreCase("personId")){
		    	userCookie = cookies[i];
		    }
		}
		userclass=classCookie.getValue();
		userId=userCookie.getValue();
	//, patient_id, doctor_id, radiologist_id, test_type, prescribing_date, test_date, diagnosis, description 
	String querydata ="SELECT record_id, patient_id, doctor_id, radiologist_id, test_type, prescribing_date, test_date, diagnosis, description FROM radiology_record WHERE ";
	
	if (userclass.equals("p")){
		querydata = (querydata + "patient_id='"+userId+"' AND ");
	}
	else if (userclass.equals("d")){
		querydata = (querydata + "doctor_id='"+userId+"' AND ");
	}
	else if (userclass.equals("r")){
		querydata = (querydata + "radiologist_id='"+userId+"' AND ");
	}
	//if (sname!="" || userclass.equals("p")){
	//	querydata = (querydata + "patient_id LIKE '"+sname+"' AND ");
    //}
	if (sdiagnosis!=""){
		querydata = (querydata + "diagnosis LIKE '"+sdiagnosis+"' AND ");
    }
	if (sdescription!=""){
		querydata = (querydata + "description LIKE '"+sdescription+"' AND ");
    }
	querydata = (querydata + "test_date BETWEEN '"+SSTARTDATE+"' AND '"+SENDDATE+"'");
	if (SORT.equals("ASC")){
		querydata = (querydata + " ORDER BY test_date ASC");
	}
	else if (SORT.equals("DESC")){
		querydata = (querydata + " ORDER BY test_date DESC");
	}
	else{
		querydata = (querydata + " ORDER BY (select 6*count(t.patient_id) from radiology_record t where t.patient_id=radiology_record.patient_id) + (select 3*count(d.diagnosis) from radiology_record d where d.diagnosis=radiology_record.diagnosis) + (select count(de.description) from radiology_record de where de.description=radiology_record.description) DESC");
	}
	out.println("<html>");
	out.println("<head>");
	out.println("<title> Photo List </title>");
	out.println("</head>");
	out.println("<body bgcolor=\"#000000\" text=\"#cccccc\" >");
	out.println("<center>");
	out.println("<h3>The List of Images </h3>");

	/*
	 *   to execute the given query
	 */
	try {
	    Connection conn = Database.requestConnection();
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(querydata);
	    String p_id = "";

        out.println("<table border=\"1\" style=\"width:1000px\">");
        out.println("<tr>");
        out.println("<th>Record ID</th>");
        out.println("<th>Patient ID</th>");
        out.println("<th>Doctor ID</th>");
        out.println("<th>Radiologist ID</th>");
        out.println("<th>Test Type</th>");
        out.println("<th>Prescribing Date</th>");
        out.println("<th>Test Date</th>");
        out.println("<th>Diagnosis</th>");
        out.println("<th>Description</th>");
       // out.println("<th></th>");
        out.println("<th>Thumbnail</th>");
        out.println("<th>Picture Size</th>");
        out.println("</tr>");
	    while (rset.next() ) {
	    	p_id = (rset.getObject(1)).toString();
            out.println("<tr>");
            out.println("<td>" + rset.getString("record_id") + "</td>");
            out.println("<td>" + rset.getString("patient_id") + "</td>");
            out.println("<td>" + rset.getString("doctor_id") + "</td>");
            out.println("<td>" + rset.getString("radiologist_id") + "</td>");
            out.println("<td>" + rset.getString("test_type") + "</td>");
            out.println("<td>" + rset.getString("prescribing_date") + "</td>");
            out.println("<td>" + rset.getString("test_date") + "</td>");
            out.println("<td>" + rset.getString("diagnosis") + "</td>");
            out.println("<td>" + rset.getString("description") + "</td>");
	       // specify the servlet for the image
           //out.println("<td><a href=\"/CMPUT391_RIS/GetOnePic?normal"+p_id+"\">");
	       // specify the servlet for the themernail
	       out.println("<td><img src=\"/CMPUT391_RIS/GetOnePic?"+p_id+"\"></td>");
	       out.println("<td><a href=\"/CMPUT391_RIS/GetOnePic?normal"+p_id+"\">");
	       out.println("Small Size</a><br>");
	       out.println("<a href=\"/CMPUT391_RIS/GetOnePic?big"+p_id+"\">");
	       out.println("Large Size</a></td>");
	       out.println("</tr>");
	    }
	    out.println("</table>");
	    stmt.close();
	    conn.close();
	} catch ( Exception ex ){ out.println( ex.toString() );}
    
	out.println("<P><a href=\"/CMPUT391_RIS/search.jsp\"> Return </a>");
	out.println("</body>");
	out.println("</html>");
    }
}
    
    /*
     *   Connect to the specified database
     */

