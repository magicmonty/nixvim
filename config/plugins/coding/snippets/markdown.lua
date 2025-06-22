local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function clipboard()
	return vim.fn.getreg("+")
end

-- Helper function to create code block snippets
local function create_code_block_snippet(lang)
	return s({
		trig = lang,
		name = "Codeblock",
		desc = lang .. " codeblock",
	}, {
		t({ "```" .. lang, "" }),
		i(1),
		t({ "", "```" }),
	})
end

-- Define languages for code blocks
local languages = {
	"bash",
	"cpp",
	"csharp",
	"css",
	"csv",
	"dockerfile",
	"go",
	"html",
	"java",
	"javascript",
	"json",
	"jsonc",
	"lua",
	"markdown",
	"markdown_inline",
	"php",
	"python",
	"regex",
	"sql",
	"templ",
	"txt",
	"typescript",
	"yaml",
}

-- Generate snippets for all languages
local snippets = {}

for _, lang in ipairs(languages) do
	table.insert(snippets, create_code_block_snippet(lang))
end

-- Paste clipboard contents in link section, move cursor to ()
table.insert(
	snippets,
	s({
		trig = "linkc",
		name = "Paste clipboard as .md link",
		desc = "Paste clipboard as .md link",
	}, {
		t("["),
		i(1),
		t("]("),
		f(clipboard, {}),
		t(")"),
	})
)

-- Paste clipboard contents in link section, move cursor to ()
table.insert(
	snippets,
	s({
		trig = "linkex",
		name = "Paste clipboard as EXT .md link",
		desc = "Paste clipboard as EXT .md link",
	}, {
		t("["),
		i(1),
		t("]("),
		f(clipboard, {}),
		t('){:target="_blank"}'),
	})
)

local autosnippets = {}

return snippets, autosnippets
