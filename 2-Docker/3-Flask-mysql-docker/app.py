from flask import Flask
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    connection = mysql.connector.connect(
        host="db",
        user="root",
        password="example",
        database="test_db"
    )
    return connection

@app.route('/')
def hello_world():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT 'Hello, Docker + Flask + MySQL!'")
    result = cursor.fetchone()
    connection.close()
    return str(result[0])

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
