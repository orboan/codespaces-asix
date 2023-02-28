import sys

URL = 'https://github.dev'
PORT = 8181

if len(sys.argv) == 3:
    URL= sys.argv[1]
    PORT = int(sys.argv[2])

import http.server
import socketserver

class RedirectHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(301)
        self.send_header('Location', URL)
        self.end_headers()

with socketserver.TCPServer(("", PORT), RedirectHandler) as httpd:
    print("Serving at port", PORT)
    httpd.serve_forever()
