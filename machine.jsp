<%@ page import="java.sql.*" %>
<%
    // Retrieve username from session
    String username = (String) session.getAttribute("username");

    // Retrieve points and weight from request
    String pointsStr = request.getParameter("totalPoints");
    String weightStr = request.getParameter("totalWeight");

    if (username == null || pointsStr == null || weightStr == null) {
%>
    <script>
        alert("Error: Missing data. Please log in and try again.");
        window.location.href = "login.html";
    </script>
<%
        return;
    }

    int totalPoints = Integer.parseInt(pointsStr);
    int totalWeight = Integer.parseInt(weightStr);

    Connection con = null;
    PreparedStatement selectStmt = null;
    PreparedStatement updateStmt = null;
    PreparedStatement insertStmt = null;
    ResultSet rs = null;

    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/recycle_db", "root", "pandu@vanitha");

        // Check if user exists in database
        String selectQuery = "SELECT total_points, total_weight FROM users WHERE username=?";
        selectStmt = con.prepareStatement(selectQuery);
        selectStmt.setString(1, username);
        rs = selectStmt.executeQuery();

        if (rs.next()) {
            // User exists, update their points and weight
            int updatedPoints = rs.getInt("total_points") + totalPoints;
            int updatedWeight = rs.getInt("total_weight") + totalWeight;

            String updateQuery = "UPDATE users SET total_points = ?, total_weight = ? WHERE username=?";
            updateStmt = con.prepareStatement(updateQuery);
            updateStmt.setInt(1, updatedPoints);
            updateStmt.setInt(2, updatedWeight);
            updateStmt.setString(3, username);
            updateStmt.executeUpdate();
%>
    <script>
        alert("Updated Successfully! Total Points: <%= updatedPoints %> | Total Weight: <%= updatedWeight %>g");
        setTimeout(() => {
            window.location.href = "/VRVM/leader.jsp";
        }, 500);
    </script>
<%
        } else {
            // New user, insert into database
            String insertQuery = "INSERT INTO users (username, total_points, total_weight) VALUES (?, ?, ?)";
            insertStmt = con.prepareStatement(insertQuery);
            insertStmt.setString(1, username);
            insertStmt.setInt(2, totalPoints);
            insertStmt.setInt(3, totalWeight);
            insertStmt.executeUpdate();
%>
    <script>
        alert("New user data stored! Total Points: <%= totalPoints %> | Total Weight: <%= totalWeight %>g");
        setTimeout(() => {
            window.location.href = "/VRVM/leader.jsp";
        }, 500);
    </script>
<%
        }
    } catch (Exception e) {
%>
    <script>
        alert("Error: <%= e.getMessage().replace("\"", "\\\"") %>");
        setTimeout(() => {
            window.location.href = "machine.html";
        }, 500);
    </script>
<%
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (selectStmt != null) selectStmt.close();
        if (updateStmt != null) updateStmt.close();
        if (insertStmt != null) insertStmt.close();
        if (con != null) con.close();
    }
%>
s