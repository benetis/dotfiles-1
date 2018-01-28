{ config, lib, pkgs, ... }:

{
  nix = {
    extraOptions = ''
      gc-keep-outputs = true
      build-cache-failure = true
      auto-optimise-store = true
    '';

    useSandbox = true;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d"; # Is this enough?
    };
  };

  networking.firewall.rejectPackets = true;

  programs = {
    mtr.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    bash.enableCompletion = true;
  };

  services = {
    haveged.enable = true;

    smartd.enable = lib.mkDefault true;

    # Because of this insanity… → https://github.com/NixOS/nixpkgs/pull/16021
    logind.extraConfig = ''
      KillUserProcesses=yes
    '';

    journald.extraConfig = ''
      SystemMaxUse=200M
    '';
  };

  users = {
    mutableUsers = lib.mkDefault false;
    defaultUserShell = "/run/current-system/sw/bin/zsh";
  };

  environment.variables.PATH = [ "$HOME/.bin" ];

  environment.systemPackages = with pkgs; [
    (hiPrio netcat-openbsd)
    bc
    bindfs
    calc
    daemonize
    ddrescue
    dos2unix
    easyrsa
    file
    gcc
    git
    gnumake
    htop
    hwinfo
    inetutils
    inotify-tools
    iw
    jq
    libfaketime
    lshw
    lsof
    ltrace
    mkpasswd
    moreutils
    mtr
    ncdu
    nix-repl
    nmap
    openssl
    p7zip
    pciutils
    pv
    smartmontools
    socat
    sqlite-interactive
    strace
    unzip
    usbutils
    wget
    which
    wirelesstools
    zip
  ];

  security = {
    pam.services.su.requireWheel = true;

    hideProcessInformation = true;

    sudo.extraConfig = ''
      Defaults timestamp_timeout=0
      %wheel ALL=(root) NOPASSWD: ${config.system.build.nixos-rebuild}/bin/nixos-rebuild switch -k
      %wheel ALL=(root) NOPASSWD: ${config.system.build.nixos-rebuild}/bin/nixos-rebuild switch -k --upgrade
      %wheel ALL=(root) NOPASSWD: ${config.system.build.nixos-rebuild}/bin/nixos-rebuild boot -k
      %wheel ALL=(root) NOPASSWD: ${config.system.build.nixos-rebuild}/bin/nixos-rebuild boot -k --upgrade
      %wheel ALL=(root) NOPASSWD: ${config.nix.package.out}/bin/nix-collect-garbage -d
    '';
  };

  # Stability!
  system.autoUpgrade.enable = lib.mkDefault false;
}
