<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<html>
<head>
    <title>Daftar TV Show</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        form {
            text-align: center;
            margin-bottom: 30px;
        }

        input[type="text"] {
            padding: 8px;
            font-size: 16px;
            width: 300px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            padding: 8px 15px;
            font-size: 16px;
            margin-left: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        a {
            text-decoration: none;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }

        .card-small {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 10px;
            transition: transform 0.2s;
            text-align: center;
        }

        .card-small:hover {
            transform: scale(1.03);
        }

        .card-small img {
            width: 100%;
            border-radius: 8px;
            max-height: 280px;
            object-fit: cover;
        }

        .card-meta {
            margin-top: 10px;
            font-size: 14px;
            color: #333;
        }

        .card-meta .show-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 6px;
        }

        .card-meta .show-title a {
            text-decoration: none;
            color: #222;
        }

        .card-meta .show-title a:hover {
            text-decoration: underline;
        }

        .footer {
            text-align: center;
            margin-top: 40px;
            font-size: 14px;
            color: #888;
        }
    </style>
</head>
<body>
    <h2><a href="shows" style="text-decoration: none; color: inherit;">TV Show (API TVMaze)</a></h2>

    <form method="get" action="shows">
        <input type="text" name="q" placeholder="Cari TV Show..." value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>" />
        <button type="submit">Cari</button>
    </form>

    <div class="container">
        <%
            String result = (String) request.getAttribute("apiResult");
            boolean isSearch = request.getAttribute("isSearch") != null && (Boolean) request.getAttribute("isSearch");

            if (result != null) {
                try {
                    JSONArray array = new JSONArray(result);
                    int maxToShow = 30;

        %>
        <div class="grid">
        <%
                    for (int i = 0; i < Math.min(array.length(), maxToShow); i++) {
                        JSONObject show = isSearch ? array.getJSONObject(i).getJSONObject("show") : array.getJSONObject(i);
                        String name = show.optString("name", "Tanpa Nama");
                        int id = show.optInt("id");
                        String imageUrl = "#";
                        if (!show.isNull("image")) {
                            JSONObject imageObj = show.getJSONObject("image");
                            imageUrl = imageObj.optString("medium", "#");
                        }
                        String rating = show.has("rating") && !show.isNull("rating") ? show.getJSONObject("rating").optString("average", "-") : "-";
                        String genreList = show.has("genres") ? show.getJSONArray("genres").join(", ").replace("\"", "") : "-";
        %>
            <div class="card-small">
                <% if (!imageUrl.equals("#")) { %>
                    <a href="detail?id=<%= id %>">
                        <img src="<%= imageUrl %>" alt="Poster">
                    </a>
                <% } %>
                <div class="card-meta">
                    <div class="show-title"><a href="detail?id=<%= id %>"><%= name %></a></div>
                    <div><strong>Rating:</strong> <%= rating %></div>
                    <div><strong>Genre:</strong> <%= genreList %></div>
                </div>
            </div>
        <%
                    } // end for
        %>
        </div>
        <%
                } catch (Exception e) {
        %>
            <div class="card-small">Terjadi kesalahan saat parsing data: <%= e.getMessage() %></div>
        <%
                }
            } else {
        %>
            <div class="card-small">Belum ada data. Akses <a href="shows">/shows</a> untuk melihat daftar show dari API.</div>
        <%
            }
        %>
    </div>

    <div class="footer">
        &copy; <%= java.time.Year.now() %> TvShowApp - Data from TVMaze API - Moto: Pantang turu sebelum berez 🗿
    </div>
</body>
</html>
