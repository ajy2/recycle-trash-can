package trashcan;

import java.io.Serializable;

public class User implements Serializable{
	private String userid; 
	private String passwd;
	private String email;
	private String lastlogin;
	private int point;
	
	public User(){		
	}
	
	public void setUserid(String userid){
		this.userid = userid;
	}
	
	public String getUserid(){
		return userid;
	}
	
	public void setPasswd(String passwd){
		this.passwd = passwd;
	}
	
	public String getPasswd(){
		return passwd;
	}
	
	public void setEmail(String email){
		this.email = email;
	}
	
	public String getEmail(){
		return email;
	}
	
	public void setPoint(int point){
		this.point = point;
	}
	
	public int getPoint(){
		return point;
	}
	
	public void setlastlogin(String lastlogin) {
		this.lastlogin=lastlogin;
	}
	
	public String getlastlogin() {
		return lastlogin;
	}

}