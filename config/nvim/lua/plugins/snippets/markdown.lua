local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

local tbl_basic = s(
	{ trig = "tbl", name = "Markdown table (2 columns)", desc = "Minimal 2-column markdown table" },
	fmt("| {} | {} |\n| {} | {} |\n| {} | {} |\n{}", {
		i(1, "Header 1"),
		i(2, "Header 2"),
		t("---"),
		t("---"),
		i(3, "Cell"),
		i(4, "Cell"),
		i(0),
	})
)

-- `tbl<cols>x<rows>` -> a fully-formed grid with a tab stop in every cell.
-- e.g. `tbl3x2` produces 3 columns and 2 body rows.
local function build_grid(_, parent)
	local caps = parent.snippet.captures
	local cols = math.max(tonumber(caps[1]) or 1, 1)
	local rows = math.max(tonumber(caps[2]) or 1, 1)

	local nodes = {}
	local idx = 0
	local function add(node)
		nodes[#nodes + 1] = node
	end

	-- Header row.
	add(t("| "))
	for c = 1, cols do
		idx = idx + 1
		add(i(idx, "Header " .. c))
		add(t(c == cols and " |" or " | "))
	end

	-- Delimiter row.
	add(t({ "", "| " }))
	for c = 1, cols do
		add(t(c == cols and "--- |" or "--- | "))
	end

	-- Body rows.
	for _ = 1, rows do
		add(t({ "", "| " }))
		for c = 1, cols do
			idx = idx + 1
			add(i(idx, ""))
			add(t(c == cols and " |" or " | "))
		end
	end

	return sn(nil, nodes)
end

local tbl_grid = s({
	trig = "tbl(%d+)x(%d+)",
	regTrig = true,
	name = "Markdown table <cols>x<rows>",
	desc = "tbl3x2 -> 3 columns, 2 rows",
}, { d(1, build_grid), i(0) })

ls.add_snippets("markdown", { tbl_basic, tbl_grid })
