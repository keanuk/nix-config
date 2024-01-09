{
  add_newline = true;
  scan_timeout = 30;

  format = builtins.concatStringsSep "" [
    "$username"
    "$hostname"
    "$shlvl"
    "$singularity"
    "$kubernetes"
    "$directory"
    "$git_branch"
    "$git_commit"
    "$git_state"
    "$git_status"
    "$hg_branch"
    "$docker_context"
    "$package"

    "$cmake"
    "$dart"
    "$dotnet"
    "$elixir"
    "$elm"
    "$erlang"
    "$golang"
    "$helm"
    "$java"
    "$julia"
    "$nim"
    "$nodejs"
    "$ocaml"
    "$perl"
    "$php"
    "$purescript"
    "$python"
    "$ruby"
    "$rust"
    "$swift"
    "$terraform"
    "$zig"

    "$nix_shell"
    "$conda"
    "$memory_usage"
    "$aws"
    "$gcloud"
    "$env_var"
    "$crystal"
    "$cmd_duration"
    "$custom"

    "$line_break"

    "$jobs"
    "$battery"
    "$time"
    "$status"
    "$character"
  ];

  aws = {
    disabled = false;
    format = "on [$symbol$profile(\($region\))]($style) ";
    symbol = " ";
    style = "bold yellow";
  };

  battery = {
    disabled = false;
    full_symbol = "";
    charging_symbol = "";
    discharging_symbol = "";
    format = "[$symbol$percentage]($style) ";
    display = [{
      threshold = 10;
      style = "red bold";
    }];
  };

  character = {
    disabled = false;
    format = "$symbol ";
    success_symbol = "[❯](bold green)";
    error_symbol = "[❯](bold red)";
    vicmd_symbol = "[❮](bold green)";
  };

  cmake = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = "喝 ";
    style = "bold blue";
  };

  cmd_duration = {
    disabled = false;
    min_time = 2000;
    format = "took [$duration]($style) ";
    show_milliseconds = false;
    style = "yellow bold";
    show_notifications = false;
    min_time_to_notify = 45000;
  };

  conda = {
    disabled = false;
    truncation_length = 1;
    format = "via [$symbol$environment]($style) ";
    symbol = " ";
    style = "green bold";
    ignore_base = true;
  };

  crystal = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "bold red";
  };

  dart = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "bold blue";
  };

  directory = {
    disabled = false;
    truncation_length = 3;
    truncate_to_repo = true;
    fish_style_pwd_dir_length = 0;
    use_logical_path = true;
    format = "[$path]($style)[$read_only]($read_only_style) ";
    style = "cyan bold";
    read_only = "";
    read_only_style = "red";
    truncation_symbol = "";
  };

  docker_context = {
    disabled = false;
    symbol = " ";
    style = "blue bold";
    format = "via [$symbol$context]($style) ";
    only_with_files = true;
  };

  dotnet = {
    disabled = false;
    format = "[$symbol$version( 🎯 $tfm)]($style) ";
    symbol = "•NET ";
    style = "blue bold";
    heuristic = true;
  };

  elixir = {
    disabled = false;
    format = "via [$symbol$version \(OTP $otp_version\)]($style) ";
    symbol = " ";
    style = "bold purple";
  };

  elm = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "cyan bold";
  };

  env_var = {
    disabled = false;
    symbol = "";
    style = "black bold dimmed";
    format = "with [$env_value]($style) ";
  };

  erlang = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "bold red";
  };

  gcloud = {
    disabled = false;
    format = "on [$symbol$account(\($region\))]($style) ";
    symbol = " ";
    style = "bold blue";
  };

  git_branch = {
    disabled = false;
    format = "on [$symbol$branch]($style) ";
    symbol = " ";
    style = "bold purple";
    truncation_symbol = "…";
  };

  git_commit = {
    disabled = false;
    commit_hash_length = 7;
    format = "[\($hash\)]($style) ";
    style = "green bold";
    only_detached = true;
  };

  git_state = {
    disabled = false;
    rebase = "REBASING";
    merge = "MERGING";
    revert = "REVERTING";
    cherry_pick = "CHERRY-PICKING";
    bisect = "BISECTING";
    am = "AM";
    am_or_rebase = "AM/REBASE";
    style = "bold yellow";
    format = "\([$state( $progress_current/$progress_total)]($style)\) ";
  };

  git_status = {
    disabled = false;
    # format = "([\[$all_status$ahead_behind\]]($style) )";
    format = "([$all_status$ahead_behind]($style) )";
    style = "red bold";
    stashed = "S";
    ahead = "⇡";
    behind = "⇣";
    diverged = "⇕";
    conflicted = "=";
    deleted = "✘";
    renamed = "»";
    modified = "!";
    staged = "+";
    untracked = "?";
  };

  golang = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "bold cyan";
  };

  helm = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = "⎈ ";
    style = "bold white";
  };

  hostname = {
    disabled = false;
    ssh_only = false;
    trim_at = ".";
    format = "[$hostname]($style) in ";
    style = "green dimmed bold";
  };

  java = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    style = "red dimmed";
    symbol = " ";
  };

  jobs = {
    disabled = false;
    threshold = 1;
    format = "[$symbol$number]($style) ";
    symbol = "✦";
    style = "bold blue";
  };

  julia = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "bold purple";
  };

  kubernetes = {
    disabled = true;
    symbol = "☸ ";
    format = "[$symbol$context( \($namespace\))]($style) in ";
    style = "cyan bold";
  };

  line_break = {
    disabled = false;
  };

  memory_usage = {
    disabled = true;
    threshold = 75;
    format = "via $symbol[$ram( | $swap)]($style) ";
    style = "white bold dimmed";
    symbol = " ";
  };

  hg_branch = {
    disabled = false;
    symbol = " ";
    style = "bold purple";
    format = "on [$symbol$branch]($style) ";
    truncation_symbol = "…";
  };

  nim = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "yellow bold";
  };

  nix_shell = {
    disabled = false;
    format = "via [$symbol$state( \($name\))]($style) ";
    symbol = "  ";
    style = "bold blue";
    impure_msg = "impure";
    pure_msg = "pure";
  };

  nodejs = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "bold green";
  };

  ocaml = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = "🐫 ";
    style = "bold yellow";
  };

  package = {
    disabled = false;
    format = "is [$symbol$version]($style) ";
    symbol = " ";
    style = "208 bold";
    display_private = false;
  };

  perl = {
    disabled = false;
    symbol = " ";
    style = "149 bold";
    format = "via [$symbol$version]($style) ";
  };

  php = {
    disabled = false;
    symbol = " ";
    style = "147 bold";
    format = "via [$symbol$version]($style) ";
  };

  purescript = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = "<=> ";
    style = "bold white";
  };

  python = {
    disabled = false;
    format = "via [{$symbol}{$pyenv_prefix}{$version}( \\($virtualenv\\))]($style) ";
    pyenv_version_name = false;
    pyenv_prefix = "pyenv ";
    python_binary = "python";
    # scan_for_pyfiles = true;
    style = "yellow bold";
    symbol = " ";
  };

  ruby = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "bold red";
  };

  rust = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = " ";
    style = "bold red";
  };

  shlvl = {
    disabled = true;
    threshold = 2;
    format = "[$symbol$shlvl]($style) ";
    symbol = "↕";
    style = "bold yellow";
  };

  singularity = {
    disabled = false;
    format = "[$symbol\[$env\]]($style) ";
    symbol = "";
    style = "blue bold dimmed";
  };

  swift = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = "ﯣ ";
    style = "bold 202";
  };

  status = {
    disabled = true;
    format = "[$symbol$status]($style) ";
    symbol = "✖";
    style = "bold red";
  };

  terraform = {
    disabled = false;
    format = "via [$symbol$workspace]($style) ";
    symbol = "ﰉ ";
    style = "bold 105";
  };

  time = {
    disabled = true;
    format = "at [$time]($style) ";
    style = "bold yellow";
    use_12hr = false;
    time_format = "";
    utc_time_offset = "local";
    time_range = "-";
  };

  username = {
    disabled = false;
    format = "[$user]($style) in ";
    style_root = "red bold";
    style_user = "yellow bold";
    show_always = true;
  };

  zig = {
    disabled = false;
    format = "via [$symbol$version]($style) ";
    symbol = "↯ ";
    style = "bold yellow";
  };
 }
