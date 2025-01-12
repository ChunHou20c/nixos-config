{ pkgs, pkgs-unstable,... }:{

  programs.steam.enable = true;
  environment.systemPackages =
    (with pkgs; 
      [ 
	lutris  
	gamemode
	gamescope
      ]
    ) ++
    
    (with pkgs-unstable;
      [

	osu-lazer-bin
      ]
    );
}
