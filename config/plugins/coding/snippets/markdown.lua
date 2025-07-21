local ls = require("luasnip")
local d = ls.dynamic_node
local sn = ls.snippet_node
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

local autosnippets = {}

table.insert(
	autosnippets,
	s({ trig = "tbl(%d)[x,](%d)", regTrig = true, hidden = true }, {
		d(1, function(args, snip)
			local columns = tonumber(snip.captures[1]) or 1
			local rows = tonumber(snip.captures[2]) or 1
			local nodes = {}
			local i_counter = 0
			local hlines = ""
			table.insert(nodes, t({ "", "" }))
			for _ = 1, columns do
				i_counter = i_counter + 1
				table.insert(nodes, t("| "))
				table.insert(nodes, i(i_counter, "Column " .. i_counter))
				table.insert(nodes, t(" "))
				hlines = hlines .. "|---"
			end
			table.insert(nodes, t({ "|", "" }))
			hlines = hlines .. "|"
			table.insert(nodes, t({ hlines, "" }))
			for _ = 1, rows do
				for _ = 1, columns do
					i_counter = i_counter + 1
					table.insert(nodes, t("| "))
					table.insert(nodes, i(i_counter))
					table.insert(nodes, t(" "))
				end
				table.insert(nodes, t({ "|", "" }))
			end
			return sn(nil, nodes)
		end),
	}, {
		callbacks = {
			[-1] = {
				[events.leave] = function()
					pcall(vim.cmd.MkdnTableFormat)
				end,
			},
		},
	})
)

return snippets, autosnippets
