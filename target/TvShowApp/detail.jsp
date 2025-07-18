<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONObject" %>
<html>
<head>
    <title>Detail TV Show</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
        }

        img {
            max-width: 200px;
            float: right;
            margin-left: 20px;
            border-radius: 8px;
        }

        p {
            margin: 8px 0;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #007bff;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            String detailJson = (String) request.getAttribute("detailResult");
            if (detailJson != null) {
                try {
                    JSONObject show = new JSONObject(detailJson);
                    String name = show.optString("name", "Tanpa Nama");
                    String summary = show.optString("summary", "Tidak ada deskripsi");
                    String imageUrl = show.isNull("image") ? null : show.getJSONObject("image").optString("medium");
                    String language = show.optString("language", "-");
                    String status = show.optString("status", "-");
                    String genreList = show.has("genres") ? show.getJSONArray("genres").join(", ").replace("\"", "") : "-";
                    String rating = show.has("rating") && !show.isNull("rating") ? show.getJSONObject("rating").optString("average", "-") : "-";
                    String premiered = show.optString("premiered", "-");
                    String ended = show.optString("ended", "-");
                    String runtime = show.optString("runtime", "-");
                    String officialSite = show.optString("officialSite", "");
                    String network = "-";
                    if (!show.isNull("network")) {
                        network = show.getJSONObject("network").optString("name", "-");
                    } else if (!show.isNull("webChannel")) {
                        network = show.getJSONObject("webChannel").optString("name", "-");
                    }
        %>
        <h2><%= name %></h2>
        <% if (imageUrl != null) { %>
            <img src="<%= imageUrl %>" alt="Poster">
        <% } %>
        <p><strong>Bahasa:</strong> <%= language %></p>
        <p><strong>Status:</strong> <%= status %></p>
        <p><strong>Genre:</strong> <%= genreList %></p>
        <p><strong>Rating:</strong> <%= rating %></p>
        <p><strong>Tayang Perdana:</strong> <%= premiered %></p>
        <p><strong>Tamat:</strong> <%= ended %></p>
        <p><strong>Durasi per episode:</strong> <%= runtime %> menit</p>
        <p><strong>Jaringan/Platform:</strong> <%= network %></p>
        <% if (officialSite != null && !officialSite.equals("null") && !officialSite.isEmpty()) { %>
            <p><strong>Situs Resmi:</strong> <a href="<%= officialSite %>" target="_blank"><%= officialSite %></a></p>
        <% } %>
        <p><strong>Deskripsi:</strong></p>
        <div><%= summary %></div>
        <div style="clear:both;"></div>
        <a href="shows" class="back-link">← Kembali ke daftar</a>
        <%
                } catch (Exception e) {
        %>
        <p>Gagal memuat detail: <%= e.getMessage() %></p>
        <%
                }
            } else {
        %>
        <p>Data tidak tersedia.</p>
        <%
            }
        %>
    </div>
</body>
</html>
