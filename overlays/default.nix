{ inputs, ... }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: { };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      fprintd = super.fprintd.overrideAttrs
        (old: { 
          mesonCheckFlags = [ "--no-suite" "fprintd:TestPamFprintd" ]; 
        });
    })
  ];
}
