from flask import Flask


app = Flask(__name__)


@app.route('/')
def hello_world()
    cursor = connection.cursor()
    cursor.execute("SELECT 'Hello, Docker + Flask + MySQL!'")
    result = cursor.fetchone()
    connection.close()
    return str(result[0])

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)