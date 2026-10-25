{ config, ... }: {
  flake.modules.homeManager.fzf = { config, ... }: {
    programs.fzf.enable = true;
    programs.fzf.historyWidget.command = "";
  };
}
