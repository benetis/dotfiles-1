self: super:

with (import ../ulib.nix super);

let nixpkgs = nixpkgsOf "360089b3521af0c69a5167870c80851dedf19d76"
                "1ag2hfsv29jy0nwlwnrm5w2sby0n1arii7vcc0662hr477f4riaq";
    config = {
      allowBroken = true;
      permittedInsecurePackages = [
        "webkitgtk-2.4.11"
      ];
    };

in {

  gnucash26 = (import nixpkgs { inherit config; }).gnucash26.overrideAttrs (oldAttrs: {
    postInstall = "echo ${nixpkgs} >$out/prevent-ifd-gc";
  });

}