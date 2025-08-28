{
  enable = true;
  settings = {
    directory = {
      truncation_length = 10;
      truncate_to_repo = false;
      truncation_symbol = ".../";
      before_repo_root_style = "#333333";
    };

    git_commit = {
      disabled = false;
      format = "on [$hash]($style) ";
      style = "bold green";
      only_detached = false;
      tag_disabled = false;
      tag_symbol = " tag ";
      commit_hash_length = 7;
    };

    hostname = {
      ssh_only = false;
      ssh_symbol = "";
      style = "green";
    };

    nix_shell = {
      pure_msg = "pure";
      impure_msg = "";
    };

    shell = {
      disabled = false;
      style = "yellow";
    };

    status = {
      disabled = false;
      map_symbol = true;
      format = "[$status $common_meaning$signal_name]($style) ";
    };

    sudo = {
      disabled = false;
    };

    username = {
      show_always = true;
      format = "[$user]($style)@";
      style_root = "red bold bg:white";
    };
  };
}
