let
  icons = import ./icons.nix {};
in {
  extraConfigLuaPre =
    # lua
    ''
      icons = {
        diagnostics = {
          Error = "${icons.diagnostics.Error}",
          Warn = "${icons.diagnostics.Warn}",
          Hint = "${icons.diagnostics.Hint}",
          Info = "${icons.diagnostics.Info}",
        },
        git = {
          added = "${icons.git.added}",
          modified = "${icons.git.modified}",
          removed = "${icons.git.removed}",
        },
        kinds = {
          Array = "${icons.kinds.Array}",
          Boolean = "${icons.kinds.Boolean}",
          Class = "${icons.kinds.Class}",
          Codeium = "${icons.kinds.Codeium}",
          Color = "${icons.kinds.Color}",
          Control = "${icons.kinds.Control}",
          Collapsed = "${icons.kinds.Collapsed}",
          Constant = "${icons.kinds.Constant}",
          Constructor = "${icons.kinds.Constructor}",
          Copilot = "${icons.kinds.Copilot}",
          Enum = "${icons.kinds.Enum}",
          EnumMember = "${icons.kinds.EnumMember}",
          Event = "${icons.kinds.Event}",
          Field = "${icons.kinds.Field}",
          File = "${icons.kinds.File}",
          Folder = "${icons.kinds.Folder}",
          Function = "${icons.kinds.Function}",
          Interface = "${icons.kinds.Interface}",
          Key = "${icons.kinds.Key}",
          Keyword = "${icons.kinds.Keyword}",
          Method = "${icons.kinds.Method}",
          Module = "${icons.kinds.Module}",
          Namespace = "${icons.kinds.Namespace}",
          Null = "${icons.kinds.Null}",
          Number = "${icons.kinds.Number}",
          Object = "${icons.kinds.Object}",
          Operator = "${icons.kinds.Operator}",
          Package = "${icons.kinds.Package}",
          Property = "${icons.kinds.Property}",
          Reference = "${icons.kinds.Reference}",
          Snippet = "${icons.kinds.Snippet}",
          String = "${icons.kinds.String}",
          Struct = "${icons.kinds.Struct}",
          TabNine = "${icons.kinds.TabNine}",
          Text = "${icons.kinds.Text}",
          TypeParameter = "${icons.kinds.TypeParameter}",
          Unit = "${icons.kinds.Unit}",
          Value = "${icons.kinds.Value}",
          Variable = "${icons.kinds.Variable}"
        }
      }
    '';
}
