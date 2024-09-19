{
  plugins.which-key = {
    enable = true;

    settings.spec = [
      {
        __unkeyed-1 = "g";
        group = "+goto";
      }
      {
        __unkeyed-1 = "gs";
        group = "+surround";
      }
      {
        __unkeyed-1 = "z";
        group = "+fold";
      }
      {
        __unkeyed-1 = "ä";
        group = "+next";
      }
      {
        __unkeyed-1 = "ö";
        group = "+prev";
      }
      {
        __unkeyed-1 = "<leader><Tab>";
        group = "+tabs";
      }
      {
        __unkeyed-1 = "<leader>b";
        group = "+buffer";
      }
      {
        __unkeyed-1 = "<leader>c";
        group = "+code";
      }
      {
        __unkeyed-1 = "<leader>f";
        group = "+file/find";
      }
      {
        __unkeyed-1 = "<leader>g";
        group = "+git";
      }
      {
        __unkeyed-1 = "<leader>gh";
        group = "+hunks";
      }
      {
        __unkeyed-1 = "<leader>q";
        group = "+quit/session";
      }
      {
        __unkeyed-1 = "<leader>s";
        group = "+search";
      }
      {
        __unkeyed-1 = "<leader>u";
        group = "+ui";
      }
      {
        __unkeyed-1 = "<leader>w";
        group = "+windows";
      }
      {
        __unkeyed-1 = "<leader>x";
        group = "+diagnostics/quickfix";
      }
      {
        __unkeyed-1 = "<leader>sn";
        group = "+noice";
      }
      {
        __unkeyed-1 = "<localLeader>l";
        group = "+vimtex";
      }
    ];
  };
}
