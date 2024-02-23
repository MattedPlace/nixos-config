{ config, lib, pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs = {
      chromium = {
        enable = true;
        package = pkgs.brave;
        extensions = [
        { id = "ammjkodgmmoknidbanneddgankgfejfh"; }  #7TV
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } #ublock origin
        {
        id = "dcpihecpambacapedldabdbpakmachpb";
        updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
        }
        { id = "dpacanjfikmhoddligfbehkpomnbgblf"; } #music finder
        { id = "ajopnjidmegmdimjlfnijceegpefgped"; } #betterttv
        { id = "fadndhdgpmmaapbmfcknlfgcflmmmieb"; } #frankerface
        { id = "mgijmajocgfcbeboacabfgobmjgjcoja"; } #dictionary
        { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } #translate
        { id = "pmkpddhfbiojipiehnejbjkgdgdpkdpb"; } #hyde
        { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; } #reddit enhancement suite
        { id = "fcphghnknhkimeagdglkljinmpbagone"; } #youtube autohd
        { id = "hdannnflhlmdablckfkjpleikpphncik"; } #youtube playback speed control
        ];
      };
    };
  };
}
