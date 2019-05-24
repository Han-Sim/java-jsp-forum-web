# Java: Basic Forum Web Application 

This is a basic forum web application built with JSP, JDBC and Apache Tomcat

## Techniques and features of the web application 

- Authentication: Sign up / Sign in
- Handling of user `session`

`signIn` function in `UserDAO` object

```JavaScript
public int signIn(String userID, String userPassword) {
    String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
    try {
        pstmt = conn.prepareStatement(SQL);
        pstmt.setString(1, userID);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            if (rs.getString(1).equals(userPassword)) {
                System.out.println("User signed in: " + userID);
                return 1; //success
            } else {
                return 0; //unmatched password
            }
        }
        return -1; //no result
    } catch (Exception e) {
        e.printStackTrace();
    }

    return -2; //DB error
}
```

`signInAction.jsp`

```JavaScript
<%	
    //Check if user has already signed in
    String userID = null;
    if(session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
        System.out.println("Session: " + userID);
    }
    if (userID != null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('You've already signed in')");
        script.println("location.href = 'main.jsp'");
        script.println("</script>");
    } 
    
    //if user has not signed in
    UserDAO userDAO = new UserDAO();
    int result = userDAO.signIn(user.getUserID(), user.getUserPassword());

    if (result == 1) {
        session.setAttribute("userID", user.getUserID());
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("location.href = 'main.jsp'");
        script.println("</script>");
    } else if (result == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('Wrong Password')");
        script.println("history.back()");
        script.println("</script>");
    } else if (result == -1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('Wrong ID')");
        script.println("history.back()");
        script.println("</script>"); 
    } else if (result == -2) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('Database Error')");
        script.println("history.back()");
        script.println("</script>");
    }
%>
```

- Repsonsive design with `Bootstrap`
- `MySQL` Database to hold user data and postings
  - Java Beans and Database Access Object using JDBC
- HTML `<form>` tags to write a post / sign up / sign in

## Basic level of Security

### SQL Injections

Used `PreparedStatement` to prevent SQL Injections

```JavaScript
public String getDate() {
    String SQL = "SELECT NOW()";

    try {
        PreparedStatement pstmt = conn.prepareStatement(SQL);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getString(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return ""; // Database Error
}
```

### Cross Scripting Attack

replaceAll of special characters to a corresponding HTML code

```JavaScript
<a href="view.jsp?forumID=<%=list.get(i).getForumID()%>">
<%=list.get(i).getForumTitle()
.replaceAll(" ", "&nbsp;")
.replaceAll("<","&lt;")
.replaceAll("\n", "<br>")%></a></td>
```

![Screen Shot 2019-05-23 at 9.30.20 PM.png](https://i.loli.net/2019/05/24/5ce74989ef1ed67804.png)