<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, trashcan.userDB" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userid = request.getParameter("userid");
	String passwd = request.getParameter("passwd");
	String device = request.getParameter("device");

	int no1 = userDB.checkUseridAvail(userid);
	
	if(no1 > 0){
		int no2 = userDB.checkUserPasswd(userid, passwd);
		if(no2 > 0){
			if("mobile".equals(device)){
				out.print("true");
			}else{
				session.setAttribute("userid", userid);
				response.sendRedirect("index_mobile.jsp");
			}
		}else{
			if("mobile".equals(device)){
				out.print("false");
			}
			else{%>
				<script>
					alert("비밀번호가 맞지 않습니다.");
					window.location.href="login.html";
				</script>
			<%}
		}
	}else{
		if("mobile".equals(device)){
			out.print("noId");
		}%>
		<script>
			alert("아이디가 존재하지 않습니다.");
			window.location.href="login.html";
		</script>	
<%	}%>