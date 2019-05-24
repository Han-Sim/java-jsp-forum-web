package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//User Database Access Object
public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt; // to prevent SQL injections
	private ResultSet rs; // the result will be stored here

	public UserDAO() {
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
	
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES(?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return -1; //DB error -- duplicate entry for key 'PRIMARY'
	}
}
