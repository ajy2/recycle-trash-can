<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder"%>
<%
	String userid = (String) session.getAttribute("userid");
	String point = "";
	String material = (String) request.getAttribute("barcode");
	int can=0;
	int plastic=0;
	int paper=0;
	int bottle=0;
	int styrofoam=0;
	int vinyl=0;
%>

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">
	<link rel="icon" href="../../../../favicon.ico">
	
	<title>Main</title>
	
	<!-- Bootstrap core CSS -->
	<link href="./css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Custom styles for this template -->
	<link href="./css/dashboard.css" rel="stylesheet">
</head>

<body>

	<%if(userid!=null){%>
	<div id="bcTarget" style="position:fixed; top:0px; right:0px; z-index:1021;"></div>
	<nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0">
		<a class="navbar-brand col-sm-3 col-md-2 mr-0" href="/capstone/index.jsp">3렙 쓰레기통</a>

		<!-- <input class="form-control form-control-dark w-100" type="text" placeholder="Search" aria-label="Search"> -->
		<!-- <ul class="navbar-nav px-3">
			<li class="nav-item text-nowrap"><div id="bcTarget" class="nav-link"></div></li>
		</ul> -->
		<ul class="navbar-nav px-3">
			<li class="nav-item text-nowrap"><a class="nav-link" onclick="window.open('userInfoMgmt.jsp', 'userInfoMgmt', 'width=500, height=350')">회원정보수정</a></li>
		</ul>
		<ul class="navbar-nav px-3">
			<li class="nav-item text-nowrap"><a class="nav-link" href="sessionLogout.jsp">Sign out</a></li>
		</ul>
	</nav>

	<!-- 
	<div class="container-fluid">
		<div class="row">
			<nav class="col-md-2 d-none d-md-block bg-light sidebar">
				<div class="sidebar-sticky">
					<ul class="nav flex-column">
						<li class="nav-item"><a class="nav-link active" href="#"> <span data-feather="home"></span> Dashboard <span class="sr-only">(current)</span></a></li>
						<!-- <li class="nav-item"><a class="nav-link" href="#"> <span data-feather="file"></span> Orders</a></li>
						<li class="nav-item"><a class="nav-link" href="#"> <span data-feather="shopping-cart"></span> Products</a></li>
						<li class="nav-item"><a class="nav-link" href="#"> <span data-feather="users"></span> Customers</a></li>
						<li class="nav-item"><a class="nav-link" href="#"> <span data-feather="bar-chart-2"></span> Reports</a></li>
						<li class="nav-item"><a class="nav-link" href="#"> <span data-feather="layers"></span> Integrations</a></li> 
					</ul>
					
					<%if("admin".equals(userid)){%>
						<h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
							<span>Administrator menu</span>
							<a class="d-flex align-items-center text-muted" href="#"><span data-feather="plus-circle"></span></a>
			            </h6>
			            <ul class="nav flex-column mb-2">
							<li class="nav-item">
								<a class="nav-link" onclick="window.open('insertProduct.jsp', 'insertProduct', 'width=400, height=300')"><span data-feather="file-text"></span>새 제품 등록</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" onclick="window.open('systemlog.jsp', 'systemlog', 'width=400, height=300')"><span data-feather="file-text"></span>시스템 기록 확인</a>
							</li>
							<li class="nav-item">
			                	<a class="nav-link" onclick="window.open('productList.jsp', 'productList', 'width=1000, height=800')"><span data-feather="file-text"></span>제품 정보 확인</a>
							</li>
							<li class="nav-item">
			                	<a class="nav-link" onclick="window.open('listUsers.jsp', 'listUsers', 'width=1000, height=400')"><span data-feather="file-text"></span>회원리스트 관리</a>
							</li>
			            </ul>
		            <%}%>
				</div>
			</nav>
		 -->
			<main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
			<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
				<h1 class="h2">쓰레기 분리수거 현황</h1>
				<div class="btn-toolbar mb-2 mb-md-0">
					<!-- <div class="btn-group mr-2">
						<button class="btn btn-sm btn-outline-secondary">Share</button>
						<button class="btn btn-sm btn-outline-secondary">Export</button>
					</div>
					<button class="btn btn-sm btn-outline-secondary dropdown-toggle">
						<span data-feather="calendar"></span> This week
					</button> -->
				</div>
			</div>

			<canvas class="my-4" id="myChart" width="900" height="380"></canvas>

			<h2>History</h2>
			<div class="table-responsive">
				<%
					String query = "";
					Connection con = null;
					Statement stmt1 = null;
					Statement stmt2 = null;
					Statement stmt3 = null;
					String[] preference=new String[3];
					
					try {
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
						stmt1 = con.createStatement();
						stmt2 = con.createStatement();
						stmt3 = con.createStatement();
						
						query = "SELECT product.name, log.date, product.point, product.type FROM log JOIN product WHERE log.barcode=product.barcode AND log.userid=" + "'" + userid + "'";
						ResultSet rs1 = stmt1.executeQuery(query);

						query = "select point, can, plastic, paper, bottle, styrofoam, vinyl from user where userid='" + userid + "'";
						ResultSet rs2 = stmt2.executeQuery(query);
						if (rs2.next()) {
							point = rs2.getString(1);
							can = Integer.parseInt(rs2.getString(2));
							plastic = Integer.parseInt(rs2.getString(3));
							paper = Integer.parseInt(rs2.getString(4));
							bottle = Integer.parseInt(rs2.getString(5));
							styrofoam = Integer.parseInt(rs2.getString(6));
							vinyl = Integer.parseInt(rs2.getString(7));
						}
						
						query="SELECT product.type, count FROM log JOIN product WHERE log.barcode=product.barcode AND log.userid=" + "'" +userid+ "'" + " GROUP BY product.type ORDER BY count desc limit 3";
						ResultSet rs3 = stmt3.executeQuery(query);
						for(int i=0;rs3.next();i++){
							preference[i]=rs3.getString(1);
						}
					%>
						
				<br>현재 포인트 : <%=point%>
				<br><br>
				<table class="table table-striped table-sm">
					<thead>
						<tr>
							<th>품명</th>
							<th>버린 일자</th>
							<th>포인트</th>
						</tr>
					</thead>
					<tbody>
						<%while (rs1.next()) {
								String time=rs1.getString(2).substring(0, 16);%>
						<tr>
							<td><%=rs1.getString(1)%></td>
							<td><%=time%></td>
							<td><%=rs1.getString(3)%></td>
						</tr>
						<%}%>
					</tbody>
				</table>
				<%	} catch (Exception e) {
						e.printStackTrace();
					}%>
			</div>
			</main>
		</div>
	</div>

	<!-- Bootstrap core JavaScript ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
	<script>
		window.jQuery || document.write('_$tag__________________________________________________________$tag_____')
	</script>
	<!-- <script src="../../../../assets/js/vendor/popper.min.js"></script> -->
	<script src="./js/bootstrap.min.js"></script>
	<script type="text/javascript" src="./js/jquery-barcode.js"></script> 

	<!-- Icons -->
	<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
	<script>
		feather.replace()
	</script>

	<!-- Graphs -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>
	
	<script>
	var ctx = document.getElementById("myChart").getContext('2d');
	var myChart = new Chart(ctx, {
	    type: 'bar',
	    data: {
	        labels: ["can", "plastic", "paper",  "bottle", "styrofoam", "vinyl"],
	        datasets: [{
	            label: 'Number of trashes',
	            data: [<%=can%>, <%=plastic%>, <%=paper%>, <%=bottle%>, <%=styrofoam%>, <%=vinyl%>],
	            backgroundColor: [
	                'rgba(255, 99, 132, 0.2)',
	                'rgba(54, 162, 235, 0.2)',
	                'rgba(255, 206, 86, 0.2)',
	                'rgba(75, 192, 192, 0.2)',
	                'rgba(153, 102, 255, 0.2)',
	                'rgba(255, 0, 172, 0.2)',
	            ],
	            borderColor: [
	                'rgba(255,99,132,1)',
	                'rgba(54, 162, 235, 1)',
	                'rgba(255, 206, 86, 1)',
	                'rgba(75, 192, 192, 1)',
	                'rgba(153, 102, 255, 1)',
	                'rgba(255, 0, 172, 1)',
	            ],
	            borderWidth: 1
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero:true
	                }
	            }]
	        }
	    }
	});
	
	$("#bcTarget").barcode("<%=userid%>", "code128",{barWidth:2, barHeight:30});  
	</script>

	<%}else{%>
		<script>
			alert("잘못된 접근 경로입니다.");
			window.location.href = "login.html";
		</script>
	<%}%>
</body>
</html>