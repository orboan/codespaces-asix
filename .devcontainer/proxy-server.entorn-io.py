username = os.getenv('NB_USER')
repo_root = os.getenv('JUPYTER_SERVER_ROOT')

home=f"/home/{username}"
repo = f"/home/{username}/workspaces/{repo_root}"

c.ServerProxy.servers = {
    'code': {
      'command': ['/usr/bin/code-server', '--user-data-dir', '.config/Code/', '--extensions-dir', '.vscode/extensions/', '--bind-addr', '0.0.0.0:{port}', '--auth',  'none', '--disable-telemetry', '--disable-update-check', repo],
      'environment': {},
      'absolute_url': False,
      'timeout': 60,
      'launcher_entry': {
              'title': 'VS Code',
              'icon_path': os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                        'icons', 'vscode.svg')
      }
    },
}
