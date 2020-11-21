{ config, pkgs, ... }:

let
  pkgsUnstable = import <unstable> {};
in

{
  nixpkgs.overlays = [
    (final: previous: {
      syncthing = pkgsUnstable.syncthing;
    })
  ];
  services.syncthing.enable = true;
}