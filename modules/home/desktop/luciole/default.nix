{ config, inputs, ... }:
{
  flake.modules.homeManager.luciole =
    { ... }:
    {
      imports = [
        inputs.luciole.homeModules.default
      ];

      programs.luciole.enable = true;
    };

  flake.modules.homeManager.noctalia = config.flake.modules.homeManager.luciole;
}
