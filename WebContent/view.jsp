<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="forum.Forum"%>
<%@ page import="forum.ForumDAO"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
	integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
	crossorigin="anonymous">
<link rel="stylesheet" href="css/style.css">
<title>JSP development - Forum Web Site | Han Sim</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}

		int forumID = 0;
		if (request.getParameter("forumID") != null) {
			forumID = Integer.parseInt(request.getParameter("forumID"));
		}

		if (forumID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('Error. Invalid forumID')");
			script.println("location.href = 'forum.jsp'");
			script.println("</script>");
		}

		Forum forum = new ForumDAO().getForum(forumID);
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a href="main.jsp" class="navbar-brand"> Simple Forum Web </a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">Main</a></li>
				<li class="active"><a href="forum.jsp">Forum</a></li>
			</ul>
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right ">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true">Connect<span
						class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="signIn.jsp">Sign in</a></li>
						<li><a href="join.jsp"><em>Create an account</em></a></li>
					</ul></li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right ">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true">Info<span
						class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="signOutAction.jsp"><em>Sign Out</em></a></li>
					</ul></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>

	<div class="container">
		<div class="row">
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd;">
				<thead>
					<tr>
						<th colspan="3"
							style="background-color: #eeeeee; text-align: center;">Post</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%">Title</td>
						<td colspan="2"><%=forum.getForumTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll("\n", "<br>")%></td>
					</tr>
					<tr>
						<td>User ID</td>
						<td colspan="2"><%=forum.getUserID()%></td>
					</tr>
					<tr>
						<td>User ID</td>
						<td colspan="2"><%=forum.getForumDate()%></td>
					</tr>
					<tr>
						<td>Content
						<td colspan="2" style="min-height: 200px; text-align: left;">
						<%=forum.getForumContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll("\n", "<br>")%></td>
					</tr>
				</tbody>
			</table>
			<div class="btn-toolbar">
				<a href="forum.jsp" class="btn btn-primary">Go back to the list</a>
				<%
					if (userID != null && userID.equals(forum.getUserID())) {
				%>
				<a href="update.jsp?forumID=<%=forumID%>"
					class="btn btn-warning pull-right">Edit</a>
				<a href="deleteAction.jsp?forumID=<%=forumID%>"
					class="btn btn-danger pull-right"
					onclick="return confirm('Are you sure to delete this post?')">Delete</a>
				<%
					}
				%>
			</div>

		</div>
	</div>
	<script
		src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>