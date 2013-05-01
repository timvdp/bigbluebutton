<!--

BigBlueButton - http://www.bigbluebutton.org

Copyright (c) 2008-2009 by respective authors (see below). All rights reserved.

BigBlueButton is free software; you can redistribute it and/or modify it under the 
terms of the GNU Lesser General Public License as published by the Free Software 
Foundation; either version 3 of the License, or (at your option) any later 
version. 

BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along 
with BigBlueButton; if not, If not, see <http://www.gnu.org/licenses/>.

Author: Jesus Federico <jesus@123it.ca>

-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<% 
	request.setCharacterEncoding("UTF-8"); 
	response.setCharacterEncoding("UTF-8"); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Demo meeting</title>
	<style type="text/css">
	 #formcreate{ 
	 	width:500px; 
	 	height:500px;
	 }
	 #formcreate ul{
	 	list-style:none;
	 }
	 #formcreate li{
	 	display:block;
	 	width:400px;
	 	margin-bottom:5px;
	 }
	 #formcreate label{
	 	display:block;
	 	float:left;
	 	width:150px;
	 	text-align:right;
	 }
	 #labdescription{
	 	vertical-align:top;
	 }
	</style>
</head>
<body>


<%@ include file="bbb_api.jsp"%>

<%
	if (request.getParameterMap().isEmpty()) {
	//
        // Assume we want to create a meeting
        //
%>
    <h2>Enter name and join as Student or Teacher</h2>

    <form id="formcreate" name="formcreate" method="get" action=""> 
        <fieldset>
            <legend>Demo Meeting</legend>
            <ul>
                <li>
                    <label for="username1">Your Name:</label>
                    <input id="username1" required name="username1" type="text" />	
                </li>
            </ul>
        </fieldset>
        <fieldset>
            <legend>Parameters</legend>

		<label for="Recording">Record meeting ?</label>
			<select id="recording" name="Recording">
			  <option value="false">No</option>
			  <option value="true">Yes</option>
			</select><br><br>			

        </fieldset>

		
		<input type="submit" name="joinStudent" value="Join as Student" >
		<input type="submit" name="joinTeacher" value="Join as Teacher" >
		<input type="hidden" name="action" value="create" />
    </form>
	
<%
	} else if (request.getParameter("action").equals("create")) {
		
		String confname = "Demo Meeting";
		String username = request.getParameter("username1");
		String password = "";

	Document doc = null;
	try {
        	if(request.getParameter("joinStudent") != null) 
        	{
        	
			doc = parseXml( getURL( "http://"+ getBigBlueButtonIP() + "/client/conf/config_viewer.xml" ));
			password = "ap";
		}
        	else if(request.getParameter("joinTeacher") != null) 
		{
        		doc = parseXml( getURL( "http://"+ getBigBlueButtonIP() + "/client/conf/config_teacher.xml" ));
			password = "mp";
		}
	     } catch (Exception e) {
        	e.printStackTrace();
        }

	//Create new config.xml
	TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
        StringWriter writer = new StringWriter();
        transformer.transform(new DOMSource(doc), new StreamResult(writer));
        String configXML = writer.getBuffer().toString().replaceAll("\n|\r", "");

		//
		// This is the URL for to join the meeting as moderator
		//
		String url = BigBlueButtonURL.replace("bigbluebutton/","demo/");
		String joinURL = getJoinURLConfigXMLPassword(username, confname, password, request.getParameter("Recording"), configXML);

		if (joinURL.startsWith("http://")) { 
%>
            <script language="javascript" type="text/javascript">
                window.location.href="<%=joinURL%>";
            </script>

<%
        } else {
%>
            <p>Error: <br>
                &nbsp;&nbsp;getJoinURL() failed
            </p>
            <p>
            <%=joinURL %>
            </p>
            
<% 
        }
    } 
%>

</body>
</html>
