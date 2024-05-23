import tkinter as tk
from tkinter import messagebox
import threading
import socket
import requests
from app import run_flask, shutdown_event

server_thread = None

def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.254.254.254', 1))
        ip = s.getsockname()[0]
    except Exception:
        ip = '127.0.0.1'
    finally:
        s.close()
    return ip

def start_server():
    global server_thread
    server_thread = threading.Thread(target=run_flask, daemon=True)
    server_thread.start()
    server_status.set("Server is running on IP: " + get_ip_address() + " Port: 5000")
    start_button.config(text="Stop Server", bg="red")

def stop_server():
    try:
        requests.post('http://127.0.0.1:5000/shutdown')
    except requests.exceptions.RequestException:
        pass
    shutdown_event.set()
    server_status.set("Server is stopped")
    start_button.config(text="Start Server", bg="green")
    app.quit()

def toggle_server():
    if start_button.config('text')[-1] == 'Start Server':
        start_server()
    else:
        stop_server()

app = tk.Tk()
app.title("API Server")
app.geometry("600x300")  # Increased window size

# Styling
font_large = ("Helvetica", 14)

# IP Address Label
ip_label = tk.Label(app, text="IP Address: " + get_ip_address(), font=font_large)
ip_label.pack(pady=10)

# Port Label
port_label = tk.Label(app, text="Port: 5000", font=font_large)
port_label.pack(pady=10)

# Server Status Label
server_status = tk.StringVar()
server_status.set("Server is not running")
status_label = tk.Label(app, textvariable=server_status, fg="red", font=font_large)
status_label.pack(pady=10)

# Start/Stop Server Button
start_button = tk.Button(app, text="Start Server", command=toggle_server, font=font_large, bg="green", fg="white", padx=20, pady=10)
start_button.pack(pady=20)

app.mainloop()
