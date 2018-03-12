{ config, pkgs, ... }:

{
  imports = [
    ../../modules
    ../common-x86.nix
    ./monitoring
    ./gitolite
    ./bitlbee
    ./kornel
    ./jabber
    ./openvpn
    ./web
    ./feeds/annibot.nix
    ./feeds/stosowana.nix
    ./feeds/rss2email.nix
    ./znc
  ];

  boot.tmpOnTmpfs = false;

  networking.hostName = "michalrus_com";

  networking.firewall.allowedTCPPorts = [
    113  # identd
  ];

  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [
    weechat
  ];

  programs = {
    ssh.startAgent = false;
  };

  systemd.extraConfig = ''
    DefaultCPUAccounting=yes
    DefaultBlockIOAccounting=yes
    DefaultMemoryAccounting=yes
    DefaultTasksAccounting=yes
    DefaultIPAccounting=yes
  '';

  services = {
    openssh = {
      enable = true;
      permitRootLogin = pkgs.lib.mkForce "no";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
    };

    oidentd.enable = true;
    smartd.enable = false; # TODO: why won’t it work? `/dev/xvda: Unable to detect device type`
  };

  users = {
    users.root.dotfiles.profiles = [ "base" ];

    extraUsers.m = {
      isNormalUser = true;
      linger = true;
      openssh.authorizedKeys.keyFiles = [ ../../../dotfiles/michalrus/base/.ssh/authorized_keys.d/michalrus_notebook.pub ];
      description = "Michal Rus";
      extraGroups = [ "wheel" ];

      # The password is only used for sudo; should probably use custom PAM setup, cf. http://unix.stackexchange.com/a/94646
      hashedPassword = "$6$.lrNvojxVb.$rebh/ELnYtO69DyvnqL4IWE8Gsg.neIzfGTsM0NbUsl7vhblv.P.SgLQk05mJiLFMXje/9paO8DCB2M8lEfQQ1";

      dotfiles.base = config.users.users.m.home + "/.dotfiles/dotfiles";
      dotfiles.profiles = [ "base" "michalrus/base" "michalrus/personal" ];
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";
}
