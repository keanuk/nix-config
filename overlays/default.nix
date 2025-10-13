{inputs, ...}: {
  additions = final: prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    # Use stable versions of packages that depend on Ruby/nokogiri to avoid build issues
    # on macOS with nixpkgs-unstable
    bash-preexec = final.stable.bash-preexec or prev.bash-preexec;

    # Also use stable bats if it exists
    bats = final.stable.bats or prev.bats;
  };

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs {
      system = final.system;
      config = {
        allowUnfree = true;
      };
    };
  };

  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config = {
        allowUnfree = true;
      };
    };
  };
}
