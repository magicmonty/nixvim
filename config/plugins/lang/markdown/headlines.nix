{
  plugins.headlines = let
    headline_highlights = [
      "Headline1"
      "Headline2"
      "Headline3"
      "Headline4"
      "Headline5"
      "Headline6"
    ];

    default_settings = {
      inherit headline_highlights;
      # disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
      bullets = false;
    };
  in {
    enable = true;
    settings = {
      markdown = default_settings;
      norg = default_settings;
      rmd = default_settings;
      org = default_settings;
    };
  };

  highlight = {
    Headline1.link = "Headline";
    Headline2.link = "Headline";
    Headline3.link = "Headline";
    Headline4.link = "Headline";
    Headline5.link = "Headline";
    Headline6.link = "Headline";
  };
}
