{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "0xkowalski1";
    userEmail = "0xkowalskiaudit@gmail.com";
  };

  programs.ssh = {
    enable = true;
    startAgent = true;
    privateKeyFiles = [ "~/.ssh/id_rsa" ];
  };
}

