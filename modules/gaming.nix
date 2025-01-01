{pkgs}:{

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [

    osu-lazer-bin
    lutris  
    gamemode
    gamescope
  ];
}
