{ ... }: {
  flake.modules.nixos.fish = { ... }: {
    environment.persistence."/persist".users.Maxwell.directories = [
      ".local/share/fish"
      ".config/fish"
    ];
  };

  flake.modules.homeManager.fish = { ... }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      functions = {
        ntest = "cd $NH_FLAKE && just test";
        nswitch = "cd $NH_FLAKE && just switch";
        ts = "sudo tailscale up --accept-routes";
        r = "ranger";
        nfu = "nix flake update";
        gst = "git status";
        gp = "git push";
        gc = "git commit -v";
        gl = "git log --oneline --graph --decorate";
        ls = "eza --icons=auto --color=auto --group-directories-first";
        gco = "git checkout";
        gaa = "git add --all";
        gcm = "git commit -m";
        gca = "git commit -v --amend";
        gpu = "git push";
        gpl = "git pull";
        gdf = "git diff";
        gbr = "git branch";
        glg = "git log --oneline --graph --decorate -20";

      };
    };
  };
}
