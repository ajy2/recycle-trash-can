package trashcan;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class UserController
 */
@WebServlet("/UserController")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserController() {
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String actionType = request.getParameter("UserActionType");
		String url = "";
		if(actionType.equals("modify")){
			url = modifyUser(request);
			response.sendRedirect(url);
		}else if(actionType.equals("modifyUser")){
			url = modifyUser1(request);
			response.sendRedirect(url);
		}else if(actionType.equals("delete")){
			url = deleteUser(request);
			response.sendRedirect(url);
		}
	}

	private String modifyUser(HttpServletRequest request){
		String url = "";
		String userid = request.getParameter("userid");
		if(userid == null) {
			HttpSession ses = request.getSession();
			userid = (String)ses.getAttribute("userid");
		}
		User user = new User();
		user.setUserid(userid);
		user.setPasswd(request.getParameter("passwd"));
		user.setEmail(request.getParameter("email"));
		int flag = 0;
		flag = userDB.modifyUser(user);
		if(flag > 0){
			url = "/capstone/listUsers.jsp";
		}
		return url;
	}

	private String modifyUser1(HttpServletRequest request){
		String url = "";
		String userid = "";
		String oldPasswd = "";

		userid = request.getParameter("userid");
		if(userid == null) {
			HttpSession ses = request.getSession();
			userid = (String)ses.getAttribute("userid");
		}

		oldPasswd = request.getParameter("oldPasswd");
		if(userDB.checkUserPasswd(userid, oldPasswd) == 1) {
			User user = new User();
			user.setUserid(userid);
			user.setPasswd(request.getParameter("passwd"));
			user.setEmail(request.getParameter("email"));
			int flag = userDB.modifyUser(user);
			url="/capstone/userInfoMgmt.jsp";
			/*if(flag > 0){
				url = "productList.jsp";
			}*/
		}else {
			url = "/capstone/userInfoMgmt.jsp";
		}
		return url;
	}

	private String deleteUser(HttpServletRequest request){
		String url = "";
		String userid = request.getParameter("userid");
		int flag = 0;
		flag = userDB.deleteUser(userid);
		if(flag > 0){
			url = "/capstone/listUsers.jsp";
		}
		return url;
	}
}
