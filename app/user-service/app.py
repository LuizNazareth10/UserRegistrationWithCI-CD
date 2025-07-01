from flask import Flask, request, jsonify
from werkzeug.security import generate_password_hash
import psycopg2
import os

app = Flask(__name__)

# Função auxiliar para conectar ao banco
def get_connection():
    return psycopg2.connect(
        dbname=os.environ.get("POSTGRES_DB"),
        user=os.environ.get("POSTGRES_USER"),
        password=os.environ.get("POSTGRES_PASSWORD"),
        host=os.environ.get("POSTGRES_HOST"),
        port=5432
    )

# Rota inicial
@app.route('/')
def home():
    return "API Flask no ar!"

# Rota de cadastro
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data['username']
    password = generate_password_hash(data['password'])

    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": "Usuário cadastrado com sucesso!"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
