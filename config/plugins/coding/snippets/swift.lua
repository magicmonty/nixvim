local ls = require("luasnip")
local s = ls.s
local i = ls.i

local fmt = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local snippets = {
	s({ trig = "pub", name = "public access control", dscr = "public access control" }, fmt("public <>", { i(0) })),
	s({ trig = "priv", name = "private access control", dscr = "private access control" }, fmt("private <>", { i(0) })),
	s(
		{ trig = "if", name = "if statement", dscr = "if statement" },
		fmt(
			[[
        if <> {
          <>
        }<>
      ]],
			{ i(1), i(2), i(0) }
		)
	),
	s(
		{ trig = "ifl", name = "if let", dscr = "if let" },
		fmt(
			[[
        if let <> = <> {
          <>
        }<>
      ]],
			{ i(1), rep(1), i(2), i(0) }
		)
	),
	s(
		{ trig = "ifcl", name = "if case let", dscr = "if case let" },
		fmt(
			[[
        if case let <> = <> {
          <>
        }<>
      ]],
			{ i(1), rep(1), i(2), i(0) }
		)
	),
	s(
		{ trig = "func", name = "function declaration", dscr = "function declaration" },
		fmt(
			[[
        func <>(<>) <> {
          <>
        }
      ]],
			{ i(1), i(2), i(3), i(0) }
		)
	),
	s(
		{ trig = "funca", name = "async function declaration", dscr = "async function declaration" },
		fmt(
			[[
        func <>(<>) async <>{
          <>
        }
      ]],
			{ i(1), i(2), i(3), i(0) }
		)
	),
	s(
		{ trig = "guard", name = "simple guard", dscr = "simple guard" },
		fmt(
			[[
        guard <> else { <> }

        <>
      ]],
			{ i(1), i(2), i(0) }
		)
	),
	s(
		{ trig = "guardl", name = "guard let", dscr = "guard let" },
		fmt(
			[[
        guard let <> else { <> }

        <>
      ]],
			{ i(1), i(2), i(0) }
		)
	),
	s(
		{ trig = "view", name = "SwiftUI View", dscr = "SwiftUI View" },
		fmt(
			[[
        struct <>: View {
          var body: some View {
            <>
          }
        }

        struct <>_Previews: PreviewProvider {
          fileprivate struct Container: View {
            var body: some View {
              <>()
            }
          }

          static var previews: some View {
            NavigationStack() {
              Container()
            }
          }
        }
      ]],
			{ i(1), i(0), rep(1), rep(1) }
		)
	),
}

return snippets
