{inputs, ...}: {
  imports = [(import ../agenix.nix "server")];

  age.secrets = {
    deployKey = {
      file = "${inputs.mysecrets}/secrets/server/deploy_key.age";
      path = "/persist/home/Maxwell/.ssh/deploy_key";
      mode = "400";
      owner = "Maxwell";
      group = "users";
    };

    komodo-env = {
      file = "${inputs.mysecrets}/secrets/server/komodo.age";
      mode = "400";
      owner = "Maxwell";
      group = "users";
    };
  };
}
