package com.tvshowapp;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class TvMazeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        String apiUrl;

        if (query != null && !query.trim().isEmpty()) {
            apiUrl = "https://api.tvmaze.com/search/shows?q=" + URLEncoder.encode(query, "UTF-8");
            request.setAttribute("isSearch", true);
        } else {
            apiUrl = "https://api.tvmaze.com/shows";
            request.setAttribute("isSearch", false);
        }

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

        request.setAttribute("apiResult", apiResponse.toString());
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
    }
}
