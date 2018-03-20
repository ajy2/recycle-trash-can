<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%  String userid=(String)session.getAttribute("userid");

	MultipartRequest multi=new MultipartRequest(request, "\\img", 5*1024*1024, "UTF-8", new DefaultFileRenamePolicy());//단순히 productList에서 값을 받기 위함 뿐임. 아무 의미 없음
	String prodCMD=(String)multi.getParameter("barcode");
	String[] array=prodCMD.split("=");
	String barcode=array[0];
	String name="", brand="", material="", type="", OriginImage="";
	int count=0, point=0;
	String[] OriginImageName=null;
	
	Connection con = null;
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/capstone", "root", "940714a");
		String query = "select * from product where barcode=?;";
		PreparedStatement pstmt=con.prepareStatement(query);
		pstmt.setString(1, barcode);
		ResultSet rs= pstmt.executeQuery();
		while(rs.next()){
			name=rs.getString(2);
			brand=rs.getString(3);
			material=rs.getString(4);
			type=rs.getString(5);
			count=Integer.parseInt(rs.getString(6));
			point=Integer.parseInt(rs.getString(7));
			OriginImage=rs.getString(8);
		}
		OriginImageName=OriginImage.split("\\\\");
		String filename1=OriginImageName[2];
	}
	catch(Exception e){
			e.printStackTrace();
	}%>
	
<%if("admin".equals(userid)){%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equipv="Content-Type" content="text/html; charset=UTF-8">
			<title>품목 수정</title>
			<style>
					input.upload {
		 			  width: 100px;
					  height: 30px;
					  border-color: transparent;
					  cursor: pointer;
					  opacity: 0;       /*input type="file" tag 투명하게 처리*/
					  position: relative;
					}
					button.replace {    /*button tag 에 원하는 스타일 적용*/
					  position: absolute;
					  width: 100px;
					  height: 30px;
					  border-radius: 3px;
					  font-weight: 600;
					  border-color: transparent;
					  font-size: 10px;
					  cursor: pointer;
					}
			</style>
		</head>
		<body>
			<form action="manageProduct" method="post" enctype="multipart/form-data">
				<table border="2">
					<tr><td>barcode : </td><td><input type='text' name="barcode" value="<%=barcode%>" autofocus/></td></tr>
					<tr><td>name : </td><td><input type='text' name="name" value="<%=name%>"/></td></tr>
					<tr><td>brand : </td><td><input type='text' name="brand" value="<%=brand%>"/></td></tr>
					<tr><td>material : </td><td><select name="material"><!-- https://okky.kr/article/69936 -->
													<option value="can">can</option>
													<option value="plastic">plastic</option>
													<option value="paper">paper</option>
													<option value="bottle">bottle</option>
													<option value="styrofoam">styrofoam</option>
													<option value="vinyl">vinyl</option>
												</select></td></tr>
					<tr><td>type : </td><td><input type='text' name="type" value="<%=type%>"></td></tr>
					<tr><td>count : </td><td><input type='text' name="count" value="<%=count%>"></td></tr>
					<tr><td>point : </td><td><input type='text' name="point" value="<%=point%>"></td></tr>
					<tr><td>image : <br/>
						<button type="button" class="replace">사진 수정</button>
						<input type="file" class="upload" name="RenewImage"></td><td><img src='<%=OriginImage%>' width='200px' height='200px'>
						<input type="hidden" name="OriginImage" value=<%=OriginImage%>></td></tr> <!-- http://html5around.com/wordpress/tutorials/css-input-type-file/ -->
				</table><!-- RenewImage해서 얻은 값이 null이면 바꾸지 않고 그냥 무시, null이 아니고 previewImage의 이름을 가진 img태그의 value값과 다르면 최신본 업로드-->
				<Button type="submit" name="ProdManageButton" value="modifyProduct">수정</Button>
			</form>
		</body>
	</html>
<%}
else{%>
	<script>
		alert("잘못된 접근 경로입니다.");
		window.location.href="login.html";
	</script>
<%}%>