from flask import Flask, render_template_string

app = Flask(__name__)

html_page = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flask-app</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #3F5EFB, #00c6ff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: white;
        }
        h1 {
            font-size: 3rem;
        }
    </style>
</head>
<body>
    <h1>Flask-App is running 🚀</h1>
</body>
</html>
"""

@app.route("/")
def home():
    return render_template_string(html_page)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
