<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String userid = request.getParameter("userid");
	String passwd = request.getParameter("passwd");
	String email = request.getParameter("email");
	
	session.setAttribute("userid", userid);
	session.setAttribute("passwd", passwd);
	session.setAttribute("email", email);
	session.setAttribute("point",0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원가입</title>
</head>
<body>
	<h3>약관</h3>
	=============================================================================<Br/>
	1. 회원 정보는 웹 사이트의 운영을 위해서만 사용됩니다.<br/>
	2. 웹 사이트의 정상 운영을 방해하는 회원은 탈되 처리됩니다.<br/>
	=============================================================================<Br/>
	
	<form action="signUp.jsp" method="post">
		위의 약관에 동의하십니까?<br/>
		<input type="radio" name="agree" value="yes">동의함<br/>
		<input type="radio" name="agree" value="no">동의하지 않음<br/>
		<input type="submit" value="확인">
	</form>
</body>
</html>