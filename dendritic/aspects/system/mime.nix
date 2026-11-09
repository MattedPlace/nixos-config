{
  flake.modules.homeManager.mime =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      xdg = {
        mime.enable = true;
        mimeApps = {
          enable = true;
          defaultApplications = {
            "image/jpeg" = [
              "image-roll.desktop"
              "feh.desktop"
            ];
            "image/png" = [
              "image-roll.desktop"
              "feh.desktop"
            ];
            "text/plain" = "nvim-ghostty.desktop";
            "text/html" = "nvim-ghostty.desktop";
            "text/csv" = "nvim-ghostty.desktop";
            "application/pdf" = [
              "brave-origin.desktop"
              
            ];
            "application/zip" = "org.gnome.Nautilus.desktop";
            "application/x-tar" = "org.gnome.Nautilus.desktop";
            "application/x-bzip2" = "org.gnome.Nautilus.desktop";
            "application/x-gzip" = "org.gnome.Nautilus.desktop";
            "x-scheme-handler/http" = [
              "brave-origin.desktop"
              
            ];
            "x-scheme-handler/https" = [
              "brave-origin.desktop"
              
            ];
            "x-scheme-handler/about" = [
              "brave-origin.desktop"
              
            ];
            "x-scheme-handler/unknown" = [
              "brave-origin.desktop"
              
            ];
            "x-scheme-handler/mailto" = [ "gmail.desktop" ];
            "audio/mp3" = "mpv.desktop";
            "audio/x-matroska" = "mpv.desktop";
            "video/webm" = "mpv.desktop";
            "video/mp4" = "mpv.desktop";
            "video/x-matroska" = "mpv.desktop";
            "inode/directory" = "pcmanfm.desktop";
          };
        };
        desktopEntries.gmail = {
          name = "Gmail";
          icon = "mail-google";
          exec = ''xdg-open "https://mail.google.com/mail/?view=cm&fs=1&to=%u"'';
          mimeType = [ "x-scheme-handler/mailto" ];
        };
        desktopEntries.nvim-ghostty = {
          name = "Neovim (Ghostty)";
          genericName = "Text Editor";
          comment = "Open text files in Neovim within the Kitty terminal";
          icon = "nvim";
          exec = "ghostty nvim %F";
          terminal = false;
          categories = [
            "Utility"
            "TextEditor"
          ];
          mimeType = [
            "text/plain"
            "text/markdown"
            "application/x-shellscript"
          ];
          settings = {
            Keywords = "Text;Editor;Vim;Nvim;";
          };
        };
      };
    };
}

