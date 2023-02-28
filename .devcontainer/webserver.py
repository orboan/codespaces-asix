import sys

URL = 'https://github.dev'
PORT = 8181

if len(sys.argv) == 3:
    URL= sys.argv[1].replace(" ", "")
    PORT = int(sys.argv[2])

if len(sys.argv) == 4:
    URL= 'https://' + sys.argv[1].strip() + '.' + sys.argv[2].strip()
    PORT = int(sys.argv[3])

KEEP_RUNNING = True

def keep_running():
    return KEEP_RUNNING

import http.server
import socketserver

class RedirectHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(301)
        self.send_header('Location', f'{URL}')
        self.end_headers()
        KEEP_RUNNING = False

with socketserver.TCPServer(("", PORT), RedirectHandler) as httpd:
    print("Serving at port", PORT)
    while keep_running():
        httpd.handle_request()

        
