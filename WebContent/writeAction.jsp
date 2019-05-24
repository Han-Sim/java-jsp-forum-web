<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="forum.ForumDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<jsp:useBean id="forum" class="forum.Forum" scope="page" />
<jsp:setProperty name="forum" property="forumTitle" />
<jsp:setProperty name="forum" property="forumContent" />

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
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
			System.out.println("Session: " + userID);
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('Please sign in.')");
			script.println("location.href = 'signIn.jsp'");
			script.println("</script>");
		} else {
			if (forum.getForumTitle() == null || forum.getForumContent() == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('Your post is not finished')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				ForumDAO forumDAO = new ForumDAO();
				int result = forumDAO.write(forum.getForumTitle(), userID, forum.getForumContent());
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('Failed to post')");
					script.println("history.back()");
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='forum.jsp'"); 
					script.println("</script>");	 
				}
			}
		}
		
	%>


</body>
</html>