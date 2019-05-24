<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="forum.Forum"%>
<%@ page import="forum.ForumDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">

<title>JSP development - Forum Web Site | Han Sim</title>
</head>
<body>
	<%
		//Check if user has already signed in
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
			System.out.println("Session: " + userID);
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('Please sign in.')");
			script.println("location.href = 'signIn.jsp'");
			script.println("</script>");
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
		if (!userID.equals(forum.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('Error. forumID is not matched with userID session')");
			script.println("location.href = 'forum.jsp'");
			script.println("</script>");
		} else {
			if (request.getParameter("forumTitle") == null || request.getParameter("forumContent") == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('Your post is not finished')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				ForumDAO forumDAO = new ForumDAO();
				int result = forumDAO.update(forumID, request.getParameter("forumTitle"), request.getParameter("forumContent"));
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>"); 
					script.println("alert('Failed to update the post')");
					script.println("history.back()");
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='view.jsp?forumID="+forumID+"'");
					script.println("</script>");
				}
			}
		}
	%>


</body>
</html>