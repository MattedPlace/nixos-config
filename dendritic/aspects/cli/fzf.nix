{ ... }: {
  flake.modules.homeManager.fzf = { ... }: {
    programs.fzf.enable = true;
    programs.fzf.historyWidget.command = "";
  };
}
