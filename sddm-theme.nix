{ pkgs }:
let
  imgLink = "https://w.wallhaven.cc/full/qz/wallhaven-qzo2z7.jpg";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-YhJI0gC1ztzIT+Kou+Lu2FKMd8FXI1PPIKUMkRkpT0Q=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cp -rf ${image} $out/Background.jpg
   '';
}

