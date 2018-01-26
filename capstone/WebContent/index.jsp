<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder"%>
<%String userid=(String)session.getAttribute("userid");
  String point="";
  String material=(String)request.getAttribute("barcode");%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>포인트관리 시스템</title>
</head>
<body>
	<%if(userid!=null){%>
	<h3><%=userid%>님 환영합니다!></h3>
		<input type="button" value="로그아웃" onclick="location.href='sessionLogout.jsp'" />
		<input type="button" value="회원정보수정" onclick="window.open('userInfoMgmt.jsp', 'userInfoMgmt', 'width=500, height=350')" />
		<%if("admin".equals(userid)){%>
			<input type="button" value="새 제품 등록" onclick="window.open('insertProduct.jsp', 'insertProduct', 'width=400, height=300')" />
			<input type="button" value="시스템 기록 확인" onclick="window.open('systemlog.jsp', 'systemlog', 'width=400, height=300')" />
			<input type="button" value="제품 정보 확인" onclick="window.open('productList.jsp', 'productList', 'width=1000, height=800')" />
			<input type="button" value="회원 정보 관리" onclick="window.open('listUsers.jsp', 'listUsers', 'width=1000, height=400')" />
		<%}%>
	<%}else{%>
		<script>
			alert("잘못된 접근 경로입니다.");
			window.location.href = "login.html";
		</script>
	<%}%>

	<%  String query = "";
		Connection con = null;
		Statement stmt = null;
		try{
			String dbURL = "jdbc:mysql://localhost:3306/capstone";
			//String dbURL = "jdbc:mysql://ajy.iptime.org:3306/capstone";
			String dbUser = "root";
			String dbPass = "940714a";

			request.setAttribute("barcode", "");
			request.setAttribute("name", "");
			request.setAttribute("brand", "");
			request.setAttribute("material", "");
			
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(dbURL, dbUser, dbPass);
							
			stmt = con.createStatement();
			query = "select name, date, point from log where userid='"+userid+"'";
			ResultSet rs= stmt.executeQuery(query);

			query = "select point from user where userid='"+userid+"'";
			stmt = con.createStatement();
			ResultSet rs2=stmt.executeQuery(query);
			if(rs2.next()){
				point=rs2.getString(1);
			}%>
			<br><br>회원님의 현재 포인트는 <%=point%>입니다.<br><br>
				<form action="index.jsp" method="post">
					<table style="margin: auto; text-align: center" border="1px">
						<tr><th width="100px">품명</th><th width="150px">버린 일자</th><th width="80px">포인트</th></tr>
			<%while(rs.next()){%>
					<tr><td><%=rs.getString(1)%></td><td><%=rs.getString(2)%></td><td><%=rs.getString(3)%></td></tr>
			<%}
		}catch(Exception e){
			e.printStackTrace();
		}%>
		</table>
	</form>
</body>
</html>