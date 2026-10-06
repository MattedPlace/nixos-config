{
  flake.modules.nixos.base =
    { config, pkgs, ... }:
    {

      users.users.${config.host.user.name} = {
        shell = pkgs.zsh;
      };

      programs = {
        zsh = {
          enable = true;
          autosuggestions.enable = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          histSize = 100000;

          ohMyZsh = {
            enable = true;
            plugins = [ "git" ];
          };

          shellInit = ''
            # Spaceship
            source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
            autoload -U promptinit; promptinit
            # Hook direnv
            #emulate zsh -c "$(direnv hook zsh)"

            #eval "$(direnv hook zsh)"
          '';
        };

      };
    };

  flake.modules.homeManager.zsh =
    {
      host,
      lib,
      pkgs,
      ...
    }:
    {
      home.file.".p10k.zsh".source = ./p10k.zsh;

      home.packages = with pkgs; [
        eza
        zsh-powerlevel10k
      ];

      programs = {
        zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          history.size = 10000;
          # dotDir = "${config.xdg.configHome}/zsh";
          oh-my-zsh = {
            enable = true;
            plugins = [
              "macos"
            ];
          };
          initContent = ''
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'

            alias ls="${pkgs.eza}/bin/eza --icons=always --color=always"
            alias finder="ofd" # open find in current path.
            #cdf will change directory to active finder directory
          ''
          + lib.optionalString (host.system == "aarch64-darwin") ''
            ssh-add --apple-load-keychain &>/dev/null
          ''
          + lib.optionalString (host.name == "MacbookAirM1") ''
            export PATH=$PATH:`cat $HOME/Library/Application\ Support/Garmin/ConnectIQ/current-sdk.cfg`/bin
          '';
          zsh-abbr = {
            enable = true;
            abbreviations = {
              # git
              gst = "git status";
              gco = "git checkout";
              gaa = "git add --all";
              gcm = "git commit -m";
              gca = "git commit -v --amend";
              gpu = "git push";
              gpl = "git pull";
              gdf = "git diff";
              gbr = "git branch";
              glg = "git log --oneline --graph --decorate -20";
              r = "ranger";
              # nix
              nfu = "nix flake update";
              nbd = "nix build";
              nfc = "nix flake check";
              ndv = "nix develop";
              nsh = "nix-shell";
              drs = "sudo nixos-rebuild switch --flake .#$(hostname)";
            };
            globalAbbreviations = {
              # expand anywhere on the line, e.g.  ls G foo
              G = "| grep -i";
              L = "| less";
              J = "| jq";
              H = "| head";
              T = "| tail";
              NE = "2>/dev/null";
              NUL = "&>/dev/null";
            };
          };
        };
      };
    };
}
