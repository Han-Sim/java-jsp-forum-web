package forum;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ForumDAO {

	private Connection conn;
	private ResultSet rs; // the result will be stored here

	public ForumDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/forum?characterEncoding=UTF-8&serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver"); // jdbc library to allow connection to MySql
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

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

	public int getNextNumber() {
		String SQL = "SELECT forumID FROM forum ORDER BY forumID DESC";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // this is the first posting
		} catch (Exception e) {
			e.printStackTrace();
		}

		return -1; // Database Error
	}

	public int write(String forumTitle, String userID, String forumContent) {
		String SQL = "INSERT INTO forum VALUES (?, ?, ?, ?, ?, ?)";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNextNumber());
			pstmt.setString(2, forumTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, forumContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return -1; // Database Error
	}

	public ArrayList<Forum> getList(int pageNumber) {
		String SQL = "SELECT * FROM FORUM WHERE forumID < ? AND isAvailable = 1 " + "ORDER BY forumID DESC LIMIT 10";
		ArrayList<Forum> list = new ArrayList<Forum>();

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNextNumber() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Forum forum = new Forum();
				forum.setForumID(rs.getInt(1));
				forum.setForumTitle(rs.getString(2));
				forum.setUserID(rs.getString(3));
				forum.setForumDate(rs.getString(4));
				forum.setForumContent(rs.getString(5));
				forum.setIsAvailable(rs.getInt(6));
				list.add(forum);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// To check if there is next page or not.
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM FORUM WHERE forumID < ? AND isAvailable = 1 ";
		 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNextNumber() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}
	
	public Forum getForum(int forumID) {
		String SQL = "SELECT * FROM FORUM WHERE forumID = ?";
		 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, forumID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Forum forum = new Forum();
				forum.setForumID(rs.getInt(1));
				forum.setForumTitle(rs.getString(2));
				forum.setUserID(rs.getString(3));
				forum.setForumDate(rs.getString(4));
				forum.setForumContent(rs.getString(5));
				forum.setIsAvailable(rs.getInt(6));
				return forum;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
	
	public int update(int forumID, String forumTitle, String forumContent) {
		String SQL = "UPDATE forum SET forumTitle = ?, forumContent = ? WHERE forumID = ?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, forumTitle);
			pstmt.setString(2, forumContent);
			pstmt.setInt(3, forumID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return -1; // Database Error
	}
	

	
	public int delete(int forumID) {
		String SQL = "UPDATE forum SET isAvailable = 0 WHERE forumID = ?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, forumID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return -1; // Database Error
	}
}
