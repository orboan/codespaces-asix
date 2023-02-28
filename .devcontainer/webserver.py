import sys

URL = 'https://github.dev'
PORT = 8181

if len(sys.argv) == 3:
    URL= sys.argv[1].replace(" ", "")
    PORT = int(sys.argv[2])

if len(sys.argv) == 4:
    URL= 'https://' + sys.argv[1].strip() + '.' + sys.argv[2].strip()
    PORT = int(sys.argv[3])

import http.server
import socketserver

class RedirectHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(301)
        self.send_header('Location', f'{URL}')
        self.end_headers()

with socketserver.TCPServer(("", PORT), RedirectHandler) as httpd:
    print("Serving at port", PORT)
    print("Will redirect to", URL)
    # Create a separate thread to handle the server shutdown
    def shutdown_server():
        import time
        time.sleep(5)
        httpd.shutdown()
    
    shutdown_thread = threading.Thread(target=shutdown_server)
    shutdown_thread.start()
    
    # Start serving requests
    httpd.serve_forever()

