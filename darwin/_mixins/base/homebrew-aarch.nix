_:
let
  mkCask = name: {
    inherit name;
    args = {
      appdir = "/Applications";
    };
  };

  casksWithAppdir = map mkCask [
    "lm-studio"
    "ollama-app"
  ];
in
{
  homebrew = {
    casks = casksWithAppdir;
  };
}
