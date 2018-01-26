package trashcan;

import java.sql.*;
import java.security.NoSuchAlgorithmException;
import java.util.*;

public class userDB {
	private static String dbURL = "jdbc:mysql://localhost:3306/capstone";
	//private static String dbUser = "ajy0714";
	private static String dbUser = "root";
	private static String dbPass = "940714a";
	
	//insert a user
	public static boolean insertUser(User user){
		boolean result = false;
		Connection conn = null;
		PreparedStatement stmt = null;
		String hashedPasswd = "";
		String salt = "";
		int point=0;
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			String query = "insert into user(userid, passwd, email, salt, point)"+ "values(?, ?, ?, ?, ?)";
			
			try{
				salt = passwdUtil.getSalt();
				String temp_passwd= user.getPasswd()+salt;
				hashedPasswd = passwdUtil.hashPassd(temp_passwd);
			}
			catch(NoSuchAlgorithmException e){
				System.out.println(e);
			}
			
			stmt = conn.prepareStatement(query);
			stmt.setString(1, user.getUserid());
			stmt.setString(2, hashedPasswd);
			stmt.setString(3, user.getEmail());
			stmt.setString(4, salt);
			stmt.setInt(5, point);
			
			int i = stmt.executeUpdate();
			if(i > 0){
				result = true;
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			closeAll(stmt, conn);
		}
		return result;
	}
	
	// show all users
	public static ArrayList<User> showUsers(){
		//int flag = 0;
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		ArrayList<User> users = new ArrayList<User>();
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			String query = "select userid, email from user where userid <> 'admin' order by userid";
			stmt = conn.prepareStatement(query);
			rs = stmt.executeQuery();
			
			while(rs.next()){
				User u = new User();
				u.setUserid(rs.getString(1));
				u.setEmail(rs.getString(2));
				users.add(u);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			closeAll(stmt, conn, rs);
		}	
		return users;
	}
	
	// show a single user
	public static User showAUser(String userid){
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		User u = new User();
		u.setUserid(userid);
		try{
			
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			String query = "select email from user where userid = ?";
			stmt = conn.prepareStatement(query);
	
			stmt.setString(1, userid);
			rs = stmt.executeQuery();
			
			while(rs.next()){
				u.setEmail(rs.getString("email"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			closeAll(stmt,conn,rs);
		}
		return u;
	}
	// modify a user's information
	
	public static int modifyUser(User u){
		int flag = 0;
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String salt = "";
		String hashedPasswd = "";
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			
			try {
				salt = passwdUtil.getSalt();
				String temp = u.getPasswd()+salt;
				hashedPasswd = passwdUtil.hashPassd(temp);
			}catch(NoSuchAlgorithmException e) {
				System.out.println(e);
			}
			String query = "update user set passwd = ?, email=?, salt = ? where userid = ?";
			stmt = conn.prepareStatement(query);
			stmt.setString(1, hashedPasswd);
			stmt.setString(2, u.getEmail());
			stmt.setString(3, salt);
			stmt.setString(4, u.getUserid());

			flag = stmt.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			closeAll(stmt, conn, rs);
		}
		return flag;
	}
	//modify a user's information
	
	public static int deleteUser(String userid){
		int flag = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			pstmt = conn.prepareStatement("delete from user where userid = ?");
			pstmt.setString(1, userid);
			flag = pstmt.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			closeAll(pstmt, conn, rs);
		}
		return flag;
	}
	// check whether a user has already signed up or not. 
	
	public static int checkUserAvail(String userid, String email){
		int flag = 0;
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try{
			
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			stmt = conn.prepareStatement("select * from user where userid = ? or email = ?");
			stmt.setString(1, userid);
			stmt.setString(2, email);
			rs = stmt.executeQuery();
			if(rs.next()){
				flag = 1;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			closeAll(stmt, conn, rs);
		}
		return flag;
	}
	
	public static int checkUseridAvail(String userid){
		int flag = 0;
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try{
			
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			stmt = conn.prepareStatement("select * from user where userid = ?");
			stmt.setString(1, userid);
			rs = stmt.executeQuery();
			if(rs.next()){
				flag = 1;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			closeAll(stmt, conn, rs);
		}
		return flag;
	}
	
	public static int checkUserPasswd(String username, String passwd){
		int flag = 0;
		Connection conn = null;
		PreparedStatement stmt = null;
		PreparedStatement stmt1 = null;
		ResultSet rs = null;
		String salt = "";
		String hashedPasswd = "";
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
			
			stmt1 = conn.prepareStatement("select salt from user where userid = ?");
			stmt1.setString(1, username);
			rs = stmt1.executeQuery();
			if(rs.next()){
				salt = rs.getString(1);
			}
			
			try {
				salt = passwd+salt;
				hashedPasswd = passwdUtil.hashPassd(salt);
			}catch(NoSuchAlgorithmException e) {
				System.out.println(e);
			}
			stmt = conn.prepareStatement("select * from user where userid = ? and passwd = ?");
			stmt.setString(1, username);
			stmt.setString(2, hashedPasswd);
			rs = stmt.executeQuery();
			if(rs.next()){
				flag = 1;
				//stmt = conn.prepareStatement("update user set lastlogin = current_timestamp where userid= ?");
				//stmt.setString(1, username);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			closeAll(stmt, conn, rs);
		}
		return flag;
	}

	private static void closeAll(Statement stmt, Connection conn, ResultSet rs){
		if(stmt != null){
			try{
				stmt.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
		if(conn != null){
			try{
				conn.close();
			}catch(SQLException sqle){
			}
		}
		if(rs != null){
			try{
				rs.close();
			}catch(SQLException sqle){
			}
		}
	}
	
	private static void closeAll(Statement stmt, Connection conn){
		if(stmt != null){
			try{
				stmt.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
		if(conn != null){
			try{
				conn.close();
			}catch(SQLException sqle){
			}
		}
	}
}
