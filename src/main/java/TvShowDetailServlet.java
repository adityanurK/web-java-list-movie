package com.tvshowapp;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class TvShowDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID TV Show tidak valid");
            return;
        }

        String apiUrl = "https://api.tvmaze.com/shows/" + id;

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder apiResponse = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            apiResponse.append(line);
        }
        reader.close();

        request.setAttribute("detailResult", apiResponse.toString());
        RequestDispatcher dispatcher = request.getRequestDispatcher("detail.jsp");
        dispatcher.forward(request, response);
    }
}
