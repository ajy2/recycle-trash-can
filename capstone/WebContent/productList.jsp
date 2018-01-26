<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder"%>
<%	String userid = (String)session.getAttribute("userid");
	String passwd = (String)session.getAttribute("passwd");
	String email = (String)session.getAttribute("email");
	
	session.setAttribute("userid", userid);
	session.setAttribute("passwd", passwd);
	session.setAttribute("email", email);%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>제품 정보 리스트</title>
</head>
<body>
	<form action = "manageProduct" method="post" enctype="multipart/form-data">
	<ul>
		<table style="margin:auto; text-align:center" border="1px">
			<tr>
				<th>barcode</th><th>name</th><th>brand</th><th>material</th><th>type</th><th>count</th><th>point</th><th>image</th>
			</tr>
			<%		request.setCharacterEncoding("UTF-8");
					
					Connection con = null;
					try{
						String dbURL = "jdbc:mysql://localhost:3306/capstone";
						String dbUser = "root";
						String dbPass = "940714a";
						
						Class.forName("com.mysql.jdbc.Driver");
						con = DriverManager.getConnection(dbURL, dbUser, dbPass);
						Statement stmt = con.createStatement();
						String query = "select * from product";
						ResultSet rs= stmt.executeQuery(query);
						
						while(rs.next()){%>
							<tr>
								<td><%=rs.getString(1)%></td>
								<td><%=rs.getString(2)%></td>
								<td><%=rs.getString(3)%></td>
								<td><%=rs.getString(4)%></td>
								<td><%=rs.getString(5)%></td>
								<td><%=rs.getInt(6)%></td>
								<td><%=rs.getInt(7)%></td>
								<td><img src="<%= rs.getString(8) %>" width='100px' height='100px'></td><!-- http://thinkerodeng.tistory.com/198 -->
								<td width="60px">
									<input type='hidden' name="barcode" value="<%=rs.getString(1)%>">
									<button name="ProdManageButton" type="submit" value="modifyProduct">수정</button>/<button name="ProdManageButton" type="submit" value="deleteProduct=<%=rs.getString(1)%>">삭제</button>
		                        </td>
							</tr>
			<%			}
					}catch(Exception e){
						e.printStackTrace();
					}%>
		</table>
	</ul>
	</form>
</body>
</html>