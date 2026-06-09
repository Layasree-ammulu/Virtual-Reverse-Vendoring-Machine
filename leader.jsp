<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("login.html");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String userPlasticWeight = "0";
    String userRewardPoints = "0";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/recycle_db", "root", "pandu@vanitha");

        // Fetch current user data
        String userQuery = "SELECT total_weight, total_points FROM users WHERE username=?";
        ps = con.prepareStatement(userQuery);
        ps.setString(1, username);
        rs = ps.executeQuery();
        if (rs.next()) {
            userPlasticWeight = rs.getString("total_weight");
            userRewardPoints = rs.getString("total_points");
        }
        rs.close();
        ps.close();

        // Fetch top 10 users
        String topUsersQuery = "SELECT username, total_points FROM users ORDER BY total_points DESC LIMIT 10";
        ps = con.prepareStatement(topUsersQuery);
        rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #dbeafe;
            text-align: center;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #007bff;
        }

        .dashboard {
            background: #eef2ff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }

        th {
            background: #007bff;
            color: white;
        }

        .back-button {
            display: inline-block;
            background: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 15px;
        }

        .back-button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Welcome, <%= username %>!</h1>
        <h2>User Performance Dashboard</h2>

        <div class="dashboard">
            <table>
                <tr>
                    <th>👤 USERNAME</th>
                    <th>📦 PLASTIC WEIGHT (KG)</th>
                    <th>🏆 REWARD POINTS</th>
                </tr>
                <tr>
                    <td><%= username %></td>
                    <td><%= userPlasticWeight %></td>
                    <td><%= userRewardPoints %></td>
                </tr>
            </table>
        </div>

        <h2>🏅 Top 10 Users</h2>
        <table>
            <tr>
                <th>🏆 RANK</th>
                <th>👤 USERNAME</th>
                <th>🎯 REWARD POINTS</th>
            </tr>
            <%
                int rank = 1;
                while (rs.next()) {
            %>
            <tr>
                <td><%= rank++ %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("total_points") %></td>
            </tr>
            <%
                }
            %>
        </table>

        <a href="machine.html" class="back-button">⬅ Back to Machine</a>
    </div>

</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
