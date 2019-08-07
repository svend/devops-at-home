{ config, lib, pkgs, user, ... }:
with lib; {
  options.local.wget = mkEnableOption "wget configuration";

  config = mkIf config.local.jsdev.enable {
    home.packages = with pkgs; [ wget ];

    home.file = {
      ".wgetrc".text = ''
        # Use the server-provided last modification date, if available
        timestamping = on

        # Do not go up in the directory structure when downloading recursively
        no_parent = on

        # Wait 60 seconds before timing out. This applies to all timeouts: DNS, connect and read. (The default read timeout is 15 minutes!)
        timeout = 30

        # Retry a few times when a download fails, but don’t overdo it. (The default is 20!)
        tries = 10

        # Retry even when the connection was refused
        retry_connrefused = on

        # Use the last component of a redirection URL for the local file name
        trust_server_names = on

        # Follow FTP links from HTML documents by default
        follow_ftp = on

        # Add a `.html` extension to `text/html` or `application/xhtml+xml` files that lack one, or a `.css` extension to `text/css` files that lack one
        adjust_extension = on

        # Ignore `robots.txt` and `<meta name=robots content=nofollow>`
        robots = off

        # Print the HTTP and FTP server responses
        server_response = on
      '';
    };
  };
}
