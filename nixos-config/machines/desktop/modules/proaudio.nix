{ config, lib, pkgs, ... }:

{

  # TODO: don’t add these globally…?

  environment.profileRelativeEnvVars = {
    DSSI_PATH   = ["/lib/dssi"];
    LADSPA_PATH = ["/lib/ladspa"];
    LV2_PATH    = ["/lib/lv2"];
    LXVST_PATH  = ["/lib/lxvst"];
    VST_PATH    = ["/lib/vst"];
  };

  # TODO: don’t add these globally…?

  environment.systemPackages = with pkgs; [

    ardour
    distrho
    calf
    x42-plugins
    nixos-unstable.x42-avldrums
    nixos-unstable.x42-gmsynth
    michalrus.autotalent
    michalrus.talentedhack
    michalrus.surge
    michalrus.vocproc
    michalrus.tap-plugins
    rubberband

  ];

}
