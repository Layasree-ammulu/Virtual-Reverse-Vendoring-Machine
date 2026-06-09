<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    Integer attempts = (Integer) session.getAttribute("attempts");

    if (attempts == null) {
        attempts = 3; // Set max attempts
    }

    if (attempts <= 0) {
        out.println("<script>alert('Too many failed attempts. Try again later.'); window.location='login.html';</script>");
    } else {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/recycle_db", "root", "pandu@vanitha");

            String query = "SELECT password FROM users WHERE username=?";
            ps = con.prepareStatement(query);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                if (password.equals(storedPassword)) {
                    session.setAttribute("username", username);
                    session.removeAttribute("attempts"); // Reset attempts on success
                    out.println("<script>");
                    out.println("sessionStorage.setItem('loggedInUser', '" + username + "');"); // Store username
                    out.println("alert('Login Successful!'); window.location='/VRVM/machine.html';");  // Use absolute path
                    out.println("</script>");
                } else {
                    attempts--;
                    session.setAttribute("attempts", attempts);
                    out.println("<script>alert('Incorrect password! Attempts left: " + attempts + "'); window.location='login.html';</script>");
                }
            } else {
                out.println("<script>alert('Account does not exist. Please sign up first.'); window.location='login.html';</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
%>
