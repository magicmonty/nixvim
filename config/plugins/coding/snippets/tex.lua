local ls = require("luasnip")
local s = ls.s
local i = ls.i

local fmt = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local snippets = {
	s(
		{ trig = "frame", name = "Beamer frame", dscr = "New Beamer frame" },
		fmt(
			[[
        \begin{frame}
          \frametitle{<>}
          \framesubtitle{<>}
          <>
        \end{frame}
      ]],
			{ i(1), i(2), i(0) }
		)
	),
	s(
		{ trig = "sframe", name = "Beamer frame with section", dscr = "New Beamer frame with section" },
		fmt(
			[[
        \section{<>}
        \subsection{<>}
        \begin{frame}
          \frametitle{<>}
          \framesubtitle{<>}
          <>
        \end{frame}
      ]],
			{ i(1), i(2), rep(1), rep(2), i(0) }
		)
	),
}

local autosnippets = {}

return snippets, autosnippets
