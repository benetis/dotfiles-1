self: super:

{

  # Locales are broken in current Glibc,
  # cf. <https://github.com/NixOS/nixpkgs/issues/38988>,
  # <https://github.com/NixOS/nixpkgs/issues/38991>.

  hubstaff = let

    nixpkgsSrc = (import ../ulib.nix super).nixpkgsOf
      "b32839211ba7727ed87cb2b8e4ec80f3b1006b84"
      "0bn8w66y05ik3ffa8ccrnlaqji08kw4kvh3qj44adf4h0dfjzc5q";

    version = "1.4.0-f3657dd";
    sha256 = "1mcbkh2lvjm0rfybk9jj6izrp2xnm78zgq9f14y75kxw0v5jk0ml";

  in (import nixpkgsSrc { config.allowUnfree = true; }).hubstaff.overrideAttrs (drv: {
    name = "hubstaff-${version}";
    src = super.fetchurl {
      url = "https://hubstaff-production.s3.amazonaws.com/downloads/HubstaffClient/Builds/Release/${version}/Hubstaff-${version}.sh";
      inherit sha256;
    };
    postInstall = (drv.postInstall or "") + ''
      echo ${nixpkgsSrc} >$out/prevent-ifd-gc
    '';
  });

}