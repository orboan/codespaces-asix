subdomain = os.getenv('SUBDOMAIN')
url = f"https://{subdomain}.github.dev"

c.LauncherShortcuts.shortcuts = {
    'code': {
        'title': 'VS Code',
        'target': url,
        'icon_path': os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                        'icons', 'vscode.svg')
    }
}
