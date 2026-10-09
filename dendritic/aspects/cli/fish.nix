{ ... }: {
  flake.modules.nixos.fish = { ... }: {
  };

  flake.modules.homeManager.fish = { ... }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        atuin init fish | source
      '';
      functions = {
        ntest = "cd $NH_FLAKE && just test";
        nswitch = "cd $NH_FLAKE && just switch";
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
        lv = "nvim";
        lazyvim = "nvim";
        nix-fmt = "prettier";
        py-fmt = "black";
        py-isort = "isort";
        js-fmt = "prettier --write";
        lua-fmt = "stylua";
      };
    };
  };
}
