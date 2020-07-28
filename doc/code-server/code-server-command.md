code-server 3.4.1 48f7c2724827e526eeaa6c2c151c520f48a61259

Usage: code-server [options] [path]

Options
      --auth                The type of authentication to use. [password, none]
      --password            The password for password authentication (can only be passed in via $PASSWORD or the config file).
      --cert                Path to certificate. Generated if no path is provided.
      --cert-key            Path to certificate key when using non-generated cert.
      --disable-telemetry   Disable telemetry.
   -h --help                Show this output.
      --open                Open in browser on startup. Does not work remotely.
      --bind-addr           Address to bind to in host:port. You can also use $PORT to override the port.
      --config              Path to yaml config file. Every flag maps directly to a key in the config file.
      --socket              Path to a socket (bind-addr will be ignored).
   -v --version             Display version information.
      --user-data-dir       Path to the user data directory.
      --extensions-dir      Path to the extensions directory.
      --list-extensions     List installed VS Code extensions.
      --force               Avoid prompts when installing VS Code extensions.
      --install-extension   Install or update a VS Code extension by id or vsix.
      --uninstall-extension Uninstall a VS Code extension by id.
      --show-versions       Show VS Code extension versions.
      --proxy-domain        Domain used for proxying ports.
 -vvv --verbose             Enable verbose logging.

