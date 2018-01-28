package trashcan;

import java.io.IOException;
import java.sql.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

/**
 * Servlet implementation class insertProduct
 */
@WebServlet("/manageProduct")
public class manageProduct extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public manageProduct() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	String saveFolder="\\img";
	int maxSize=1024*1024*5;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//request.setCharacterEncoding("UTF-8");
		MultipartRequest multi=new MultipartRequest(request, saveFolder, maxSize, "UTF-8", new DefaultFileRenamePolicy());
		response.setContentType("text/html; charset=UTF-8");
		String prodCMD=(String)multi.getParameter("ProdManageButton");
		String[] array=prodCMD.split("=");
		String code="";
		if(array[0].equals("deleteProduct")) {
			prodCMD=array[0];
			code=array[1];
		}else {
			code=(String)multi.getParameter("barcode");
		}

		String dbURL="jdbc:mysql://localhost:3306/capstone";
		//String dbURL = "jdbc:mysql://ajy.iptime.org:3306/capstone";
		String dbUser="root";
		String dbPass="940714a";

		if("insertProduct".equals(prodCMD)){
			insertProduct(multi, request, response, code, dbURL, dbUser, dbPass);
		}else if("deleteProduct".equals(prodCMD)){
			deleteProduct(multi, request, response, code, dbURL, dbUser, dbPass);
		}else if("modifyProduct".equals(prodCMD)){
			modifyProduct(multi, request, response, code, dbURL, dbUser, dbPass);
		}
	}

	private void insertProduct(MultipartRequest multi, HttpServletRequest request, HttpServletResponse response, String code, String dbURL, String dbUser, String dbPass) {
		int point = 0;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

			String barcode=code;
			String name=(String)multi.getParameter("name");
			String brand=(String)multi.getParameter("brand");
			String material=(String)multi.getParameter("material");
			String type=(String)multi.getParameter("type");
			String image=(String)multi.getOriginalFileName("OrignImage");

			if("".equals(barcode) || "".equals(name) || "".equals(brand) || "".equals(material) || "".equals(type)) {
				request.setAttribute("barcode", barcode);
				request.setAttribute("name", name);
				request.setAttribute("brand", brand);
				request.setAttribute("material", material);
				request.setAttribute("type", type);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/insertProduct.jsp");//https://blog.naver.com/blackpencil/100190225768
				dispatcher.forward(request, response);
			}
			else {
				if("can".equals(material)) {
					point=10;
				}
				else if("paper".equals(material)){
					point=5;
				}
				else if("plastic".equals(material)) {
					point=7;
				}
				else if("bottle".equals(material)) {
					point=100;
				}	
				else if("styrofoam".equals(material)) {
					point=5;
				}
				else if("vinyl".equals(material)) {
					point=2;
				}
				else {
					point=1;
				}

				String query="insert into product (barcode, name, brand, material, type, point, count, image) values (?, ?, ?, ?, ?, ?, 0, ?)";
				PreparedStatement pstmt=con.prepareStatement(query);
				pstmt.setString(1, barcode);
				pstmt.setString(2, name);
				pstmt.setString(3, brand);
				pstmt.setString(4, material);
				pstmt.setString(5, type);
				pstmt.setInt(6, point);
				pstmt.setString(7, saveFolder+"\\"+image);  //   http://blog.itthis.me/28

				int resultCnt = pstmt.executeUpdate();
				if(resultCnt > 0) {
					RequestDispatcher dispatcher = request.getRequestDispatcher("insertProduct.jsp");
					dispatcher.forward(request, response);
				}
				con.close();
				pstmt.close();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

	private void deleteProduct(MultipartRequest multi, HttpServletRequest request, HttpServletResponse response, String code, String dbURL, String dbUser, String dbPass) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
			String query="delete from product where barcode=?;";
			PreparedStatement pstmt=con.prepareStatement(query);
			pstmt.setString(1, code);
			
			int resultCnt=pstmt.executeUpdate();
			if(resultCnt > 0) {
				RequestDispatcher dispatcher = request.getRequestDispatcher("productList.jsp");
				dispatcher.forward(request, response);
			}
			con.close();
			pstmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	private void modifyProduct(MultipartRequest multi, HttpServletRequest request, HttpServletResponse response, String code, String dbURL, String dbUser, String dbPass) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
			String query="update product set name=?, brand=?, material=?, type=?, count=?, point=?, image=? where barcode=?";
			PreparedStatement pstmt=con.prepareStatement(query);

			String barcode=code;
			String name=(String)multi.getParameter("name");
			String brand=(String)multi.getParameter("brand");
			String material=(String)multi.getParameter("material");
			String type=(String)multi.getParameter("type");
			int count=Integer.parseInt(multi.getParameter("count"));
			int point=Integer.parseInt(multi.getParameter("point"));
			String image="";
			String RenewImage=(String)multi.getOriginalFileName("RenewImage");
			String OriginImage=(String)multi.getParameter("OriginImage");

			if(RenewImage==null) {
				image=OriginImage;
			}else{
				image=saveFolder+"\\"+RenewImage;
			}
			
			pstmt.setString(1, name);
			pstmt.setString(2, brand);
			pstmt.setString(3, material);
			pstmt.setString(4, type);
			pstmt.setInt(5, count);
			pstmt.setInt(6, point);
			pstmt.setString(7, image);
			pstmt.setString(8, barcode);

			int resultCnt=pstmt.executeUpdate();
			if(resultCnt > 0) {
				RequestDispatcher dispatcher = request.getRequestDispatcher("productList.jsp");
				dispatcher.forward(request, response);
			}
			con.close();
			pstmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
