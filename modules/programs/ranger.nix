{ pkgs, user, ... }:

{
    home.file.".config/ranger/rc.conf".source =  ../../rsc/config/ranger/rc.conf;
    home.file.".config/ranger/scope.sh".source = ../../rsc/config/ranger/scope.sh;
    home.file.".config/ranger/plugins/ranger_devicons/devicons.py".source = ../../rsc/config/ranger/plugins/ranger_devicons/devicons.py;
    home.file.".config/ranger/plugins/ranger_devicons/__init__.py".source = ../../rsc/config/ranger/plugins/ranger_devicons/__init__.py;
}
