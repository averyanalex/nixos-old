{ nixpkgs-unstable, ... }:
let
  overlay-unstable = final: prev: {
    unstable = nixpkgs-unstable.legacyPackages.${prev.system};
  };
in
{
  nixpkgs.overlays = [ overlay-unstable ];
}
