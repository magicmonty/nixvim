{
  plugins.which-key = {
    enable = true;
    registrations = {
      "g" = {desc = "+goto";};
      "gs" = {desc = "+surround";};
      "z" = {desc = "+fold";};
      "ä" = {desc = "+next";};
      "ö" = {desc = "+prev";};
      "<leader><Tab>" = {desc = "+tabs";};
      "<leader>b" = {desc = "+buffer";};
      "<leader>c" = {desc = "+code";};
      "<leader>f" = {desc = "+file/find";};
      "<leader>g" = {desc = "+git";};
      "<leader>gh" = {desc = "+hunks";};
      "<leader>q" = {desc = "+quit/session";};
      "<leader>s" = {desc = "+search";};
      "<leader>u" = {desc = "+ui";};
      "<leader>w" = {desc = "+windows";};
      "<leader>x" = {desc = "+diagnostics/quickfix";};
      "<leader>sn" = {desc = "+noice";};
      "<localLeader>l" = {desc = "+vimtex";};
    };
  };
}
