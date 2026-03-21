
import http.server
import socketserver
import os
import socket

def find_available_port(start_port=8000):
    port = start_port
    while port < start_port + 100:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            if s.connect_ex(('', port)) != 0: return port
        port += 1
    return start_port

DIRECTORY = os.path.dirname(os.path.abspath(__file__))
class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def address_string(self):
        return self.client_address[0]

class ThreadingTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    allow_reuse_address = True

if __name__ == "__main__":
    PORT = find_available_port(81)
    with ThreadingTCPServer(("", PORT), Handler) as httpd:
        print(f"Serving build at http://0.0.0.0:{PORT}")
        httpd.serve_forever()
