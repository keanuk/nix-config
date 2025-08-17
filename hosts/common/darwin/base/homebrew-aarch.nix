{...}: {
  homebrew = {
    casks = [
      {
        name = "lm-studio";
        args = {appdir = "/Applications";};
      }
      {
        name = "ollama";
        args = {appdir = "/Applications";};
      }
    ];
  };
}
