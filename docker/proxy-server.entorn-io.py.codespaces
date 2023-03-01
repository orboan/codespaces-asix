import subprocess
command = 'jq'
argument1 = '-r'
argument2 = '.CODESPACE_NAME'
argument3 = '/workspaces/.codespaces/shared/environment-variables.json'

result = subprocess.run([command, argument1, argument2, argument3], stdout=subprocess.PIPE, text=True)
subdomain = result.stdout.replace(" ", "")

c.ServerProxy.servers = {
    'vscode': {
        'command': ['python3', '/usr/bin/webserver.py', f'{subdomain}', 'github.dev', '{port}'],
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
