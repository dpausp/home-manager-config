_ :
{
  programs.qutebrowser = {
    enable = false;

    extraConfig = let
      passCmd =
        "spawn --userscript qute-pass-custom -d dmenu -U secret -u '^user: (.+)'";
    in ''
      config.bind("aa", "${passCmd}", mode="normal")
      config.bind("<Ctrl+s>", "${passCmd}", mode="insert")

      c.url.searchengines = {
          "DEFAULT": "https://www.startpage.com/do/search?query={}",
          "ddg": "https://duckduckgo.com/?q={}",
          "py": "https://docs.python.org/3.10/search.html?q={}",
          "pyl": "https://docs.python.org/3.10/library/{}.html",
          "pypi": "https://pypi.org/search/?q={}",
          "sp": "https://www.startpage.com/do/search?query={}",
          "np": "https://mynixos.com/search?q=package+{}",
          "n": "https://mynixos.com/search?q={}",
      }

    '';

    settings = {

      editor.command = ''
        ["konsole", "-e", "vim", "{file}", "-c", "normal {line}G{column0}l"]'';
      colors.webpage.bg = "grey";
      tabs.background = true;
      tabs.new_position.unrelated = "last";

    };
  };
}
