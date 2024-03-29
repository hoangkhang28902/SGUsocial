<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="com.priyam.User,com.priyam.UserDetails,java.util.Date,java.io.File,java.text.SimpleDateFormat,com.priyam.Post,java.util.ArrayList,com.priyam.DBUtil,javax.annotation.Resource,javax.sql.DataSource"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
<style>
nav{
opacity: 0.85;
}
nav:hover{
opacity: 1.0;
}
  .collup {
    margin-top:20px;
  }
  body { 
background-image: url("images/bg.jpg");
background-size: cover;
} 
div.card {
  opacity: 0.75;
}
div.card:hover{
opacity: 1.0;
}
  .scrolling {
  height:500px;
  overflow-y: auto;
}
/* width */
::-webkit-scrollbar {
  width: 10px;
}
::-webkit-scrollbar-track {
    -webkit-box-shadow: inset 0 0 6px grey; 
    border-radius: 10px;
}
::-webkit-scrollbar-thumb {
    border-radius: 10px;
    -webkit-box-shadow: inset 0 0 6px grey; 
}
</style>
<title>Finder</title>
</head>
<%!
@Resource(name="jdbc/sgusocial")
private DataSource dataSource;
%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
%>
<%
User user=(User)session.getAttribute("user");
String ver=(String)session.getAttribute("verification");
String name=null;
if(user==null||ver==null|| (ver!=null&&!ver.equals("y"))){
	response.sendRedirect("login.jsp");
}
else{
	name=user.getName();	
%>
<body>
<nav class="navbar navbar-dark navbar-expand-md fixed-top bg-primary">
  <a style="border-radius: 25px;" class="navbar-brand bg-primary text-white" href="home.jsp">SGUSocial</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="collapsibleNavbar">
    <ul class="navbar-nav">
            <li class="nav-item">
        <a style="border-radius: 25px;" class="nav-link fas fa-home btn btn-primary" href=<%= "home.jsp?" %>> Home</a>
      </li>
      <li class="nav-item">
		<a style="border-radius: 25px;" class="nav-link 	fas fa-user-circle btn btn-primary" href=<%= "profile.jsp?email="+user.getEmail() %>> Profile</a>
      </li>
      <li class="nav-item active">
        <a style="border-radius: 25px;" class="nav-link  fas fa-search btn btn-primary" href="finder.jsp"> Finder</a>
      </li>
      <li class="nav-item">
        <a style="border-radius: 25px;" class="nav-link fas fa-user-friends btn btn-primary" href="suggestions.jsp"> Suggestions</a>
      </li>    
      <li class="nav-item">
        <a style="border-radius: 25px;" class="nav-link fas fa-power-off btn btn-primary" data-toggle="modal" data-target="#myModal" href="#">Logout</a>
      </li>
    </ul>
  </div>  
</nav>
 <div class="modal fade" id="myModal" style="opacity: 1.0;" >
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title">PBook</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
          Do you want to logout?
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <a style="border-radius: 25px;" style="border-radius: 25px;" class="text-white btn btn-danger" href=<%= "ValidateServlet?validate=logout" %>  >Logout</a>
        </div>
        
      </div>
    </div>
  </div>
<div class="container-fluid" style="margin-top:80px">
<form class="form-inline" action="ServicesServlet" style="width:600px">
<div class="form-group">
<input class="form-control mb-2 mr-sm-2" type="text" name="searchitem" required />
</div>
<button type="submit" name="service" value="search" class="btn btn-primary mb-2">Search</button>
</form>
<h5>Results:</h5>

<div class="row">
<div class="col-sm-2"></div>
<div class="col-sm-8 scrolling">


<div class="card-columns">
<%
ArrayList<User> profiles=null;
profiles=(ArrayList<User>)request.getAttribute("users");
if(profiles!=null){
	for(int i=0;i<profiles.size();i++){
		User curuser=profiles.get(i);
		UserDetails details=DBUtil.getUserDetails2(dataSource, curuser.getEmail());
		if(details!=null){
			//System.out.println(details.getProf_pic_path());
			if(details.getProf_pic_path()==null){
				details.setProf_pic_path("images/image.png");
			}
			else{
				String path=details.getProf_pic_path();
				path=path.substring(path.lastIndexOf('/')+1);
				path=request.getRealPath("")+"images/"+path;
				File f=new File(path);
				if(!f.exists()){
					details.setProf_pic_path("images/image.png");	
				}
			}
		}
		%>
		<a class="card-text text-white"  href= <%= "profile.jsp?email="+curuser.getEmail() %> >
		  <div class="card bg-primary" style="width:250px;border-radius: 50px;">
  <img class="card-img-top" src=<%= (details!=null)?details.getProf_pic_path():"images/image.png" %> alt="Card image" style="width:100%;border-radius: 50px;" >
    <div class="card-body text-center">
		<%=curuser.getName()%>
		</div>
		</div>
		</a>
	<%
	}
}
%>
<%
}
%>
</div>

</div>
<div class="col-sm-2"></div>
</div>


</div>
</body>
</html>