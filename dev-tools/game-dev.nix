{ pkgs, ...}: {

  environment.systemPackages = with pkgs; [

    # for tidying html output
    aseprite
    ldtk

  ];
}
