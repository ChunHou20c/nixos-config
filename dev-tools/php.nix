{ pkgs, ...}: {

  environment.systemPackages = with pkgs; [

    php
    phpactor

  ];
}
