{inputs, ...}: {
  additions = final: prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    openjdk8 = prev.openjdk8.overrideAttrs  { 
      separateDebugInfo = false;
      __structuredAttrs = false;
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
