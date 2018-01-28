<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder"%>
<%  String userid=(String)session.getAttribute("userid");
	String barcode=(String)request.getAttribute("barcode");
	String name=(String)request.getAttribute("name");
	String brand=(String)request.getAttribute("brand");
	String material=(String)request.getAttribute("material");
	String type=(String)request.getAttribute("type");
	if(barcode==null){barcode="";}
	if(name==null){name="";}
	if(brand==null){brand="";}
	if(material==null){material="";}
	if(type==null){type="";}%>

<%if("admin".equals(userid)){%>
	<!doctype html>
	<html>
		<head>
			<meta http-equipv="Content-Type" content="text/html; charset=UTF-8">
			<title>품목 등록</title>
		</head>
		<body>
			<form action="manageProduct" method="post" enctype="multipart/form-data">
				<table border="2">
					<tr><td>barcode : </td><td><input type='text' name="barcode" value="<%=barcode%>" autofocus/></td></tr>
					<tr><td>name : </td><td><input type='text' name="name" value="<%=name%>"/></td></tr>
					<tr><td>brand : </td><td><input type='text' name="brand" value="<%=brand%>"/></td></tr>
					<tr><td>material : </td><td><select name="material" value="<%=material%>"/>
													<option value="can">can</option>
													<option value="plastic">plastic</option>
													<option value="paper">paper</option>
													<option value="bottle">bottle</option>
													<option value="styrofoam">styrofoam</option>
													<option value="vinyl">vinyl</option></td></tr>
					<tr><td>type : </td><td><input type='text' name="type" value="<%=type%>"/></td></tr>
					<tr><td>image : </td><td><input type='file' name="OrignImage"/>
											 <br/>제품 사진은 5MB미만만 첨부가능합니다.</td></tr>
					<input type='hidden' name="count" value=0/>
				</table>
				<Button type="submit" name="ProdManageButton" value="insertProduct">저장</Button>
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