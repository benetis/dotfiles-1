self: super:

with (import ./ulib.nix super);

let

  nixos-unstable = config:
    let src = nixpkgsOf "831ef4756e372bfff77332713ae319daa3a42742"
                        "1rbfgfp9y2wqn1k0q00363hrb6dc0jbqm7nmnnmi9az3sw55q0rv";
        nixpkgs = (import src { inherit config; });
    in nixpkgs // {
      preventGC = nixpkgs.writeTextDir "prevent-ifd-gc" (toString [ src ]);
    };

in

#
# You can try out any given package by running:
#
#   $ nix-build -E 'with import <nixpkgs> { overlays = [ (import ./pkgs/tcp-broadcast.nix) ]; }; tcp-broadcast'
#
#   $ cd result/
#

composeOverlays [

  # `config.programs.mtr` uses the global definition… 🙄
  (import ./pkgs/mtr.nix)

  (self: super: {
    nixos-unstable = composeOverlays [
      (import ./pkgs/haskell-ide-engine.nix)
    ] self.nixos-unstable (super.nixos-unstable or (nixos-unstable {}));
  })

  (self: super: {

    michalrus = composeOverlays [

      (import ./pkgs/git-annex-hacks.nix)
      (import ./pkgs/influxdb.nix)
      (import ./pkgs/leksah.nix)
      (import ./pkgs/tcp-broadcast.nix)
      (import ./pkgs/gnucash.nix) # TODO: move to hledger from this crap
      (import ./pkgs/msmtp-no-security-check.nix)

      (fromNixpkgs "peek" "0e6ee9d2d814ca9dc0b48e6c15fa77dce19038ee"
         "0y26ar1hqnyvmssnph2z6077m7q252b2hj2vn142j0lss4dkvsjf" {})

      # TODO: contribute these:
      (import ./pkgs/gettext-emacs.nix)
      (import ./pkgs/gregorio.nix)
      (import ./pkgs/lemonbar-xft.nix)
      (import ./pkgs/pms5003.nix)

      # TODO: contributed:

      (fromNixpkgs "arpoison" "075b01b35513853a57006ecda04ea981158a869e"
         "05gyim4b309fkv6iqy1dh4lz6v747v0z3p68nc8ns34q8ng5vdgk" {})

    ] self.michalrus (super.michalrus or super);


    unfree = composeOverlays [

      (_: _: { nixos-unstable = nixos-unstable { allowUnfree = true; }; })

      (self: super: {

        michalrus = composeOverlays [

          (import ./pkgs/transcribe.nix)

          (fromNixpkgs "discord" "d72b8700797105e6dc38a7518786c35b1692bc00"
             "01pxwg7rkbfpyfrs9qm6fsafd4d8jlw83hfhbv464xc7kzzrb7l0" { allowUnfree = true; })

          (fromNixpkgs "hubstaff" "b32839211ba7727ed87cb2b8e4ec80f3b1006b84"
             "0bn8w66y05ik3ffa8ccrnlaqji08kw4kvh3qj44adf4h0dfjzc5q" { allowUnfree = true; })

        ] self.michalrus (super.michalrus or super);

      })

    ] self.unfree (super.unfree or (import <nixpkgs> { config.allowUnfree = true; }));

  })

] self super
