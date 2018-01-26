<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*, trashcan.*"%>
<%String userid=(String)session.getAttribute("userid");%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>List of Users</title>
	<script>
		function userModify(username){
			document.getElementById("username1").value= username;
			document.userModify.submit();
		}
	
		function userDelete(username){
			document.getElementById("username2").value= username;
			document.userDelete.submit();
		}
	</script>
</head>
<body>
<%if(userid.equals("admin")){%>
<form name="modify" method="post">
<table id="list">
	<tr>
		<th>Username</th><th>Email</th><th>lastLogin</th>
	</tr>
	<%ArrayList<User> users = userDB.showUsers();
	for(User u: users){%>
	<tr>
		<td width="20%"><%=u.getUserid()%></td>
		<td width="20%"><%=u.getEmail()%></td>
	
		<td width="20%">
			<a href="javascript:userModify('<%=u.getUserid()%>');">[modify]</a>
			<a href="javascript:userDelete('<%=u.getUserid()%>');">[delete]</a>
		</td>
	</tr>
<%}
%>
</table>
</form>
<form name="userModify" method="post" action="userInfoMgmt_admin.jsp">
	<input type="hidden" name="userid" id="username1">
</form>
<form name="userDelete" method="post" action="UserController">
	<input type="hidden" name="userid" id="username2">
	<input type="hidden" name="actionType" value="delete">
</form>
<%}%>
</body>
</html>