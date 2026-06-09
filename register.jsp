<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement ps = null;

    try {
        // Load MySQL driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish connection
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/recycle_db", "root", "pandu@vanitha");

        // Check if username or email already exists
        String checkUser = "SELECT * FROM users WHERE username=? OR email=?";
        ps = con.prepareStatement(checkUser);
        ps.setString(1, username);
        ps.setString(2, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            out.println("<script>alert('Username or Email already exists! Try again.'); window.location='register.html';</script>");
        } else {
            // Insert new user
            String query = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);

            int result = ps.executeUpdate();
            if (result > 0) {
                out.println("<script>alert('Registration Successful! Please login.'); window.location='login.html';</script>");
            } else {
                out.println("<script>alert('Registration failed. Please try again.'); window.location='register.html';</script>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('An error occurred. Please try again later.'); window.location='register.html';</script>");
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
