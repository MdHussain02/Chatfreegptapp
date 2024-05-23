from flask import Flask, request, jsonify
from flask_cors import CORS
from main import process_query  # Import the process_query function
import threading

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

shutdown_event = threading.Event()

@app.route('/chat', methods=['POST'])
def chat():
    query = request.form['user_input']
    response = process_query(query)  # Use the imported function
    return jsonify({"response": response})

@app.route('/shutdown', methods=['POST'])
def shutdown():
    shutdown_event.set()
    return 'Server shutting down...'

def run_flask():
    from werkzeug.serving import make_server

    class ServerThread(threading.Thread):
        def __init__(self, app):
            threading.Thread.__init__(self)
            self.srv = make_server('0.0.0.0', 5000, app)
            self.ctx = app.app_context()
            self.ctx.push()

        def run(self):
            self.srv.serve_forever()

        def shutdown(self):
            self.srv.shutdown()

    server = ServerThread(app)
    server.start()
    shutdown_event.wait()
    server.shutdown()
