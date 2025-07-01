from flask import Flask, request, jsonify
import jwt
import datetime
import os

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ.get("JWT_SECRET", "mysecret")

# Endpoint de login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")

    # Aqui seria a verificação real no banco
    if username == "admin" and password == "admin":
        token = jwt.encode({
            'user': username,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
        }, app.config['SECRET_KEY'], algorithm='HS256')

        return jsonify({'token': token})

    return jsonify({'message': 'Credenciais inválidas'}), 401

# Rota de teste
@app.route('/')
def home():
    return "Auth Service ativo!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
