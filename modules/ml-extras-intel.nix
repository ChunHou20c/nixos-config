{pkgs}:{

  hardware = {

    opengl.extraPackages = with pkgs; [

        intel-ocl
        intel-gmmlib
        intel-compute-runtime
      ];

  };
}
