vim.g.netrw_banner = 0 
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\.\?\(/\)\?$]]

_G.get_netrw_winbar = function()
  local sort_by = vim.g.netrw_sort_by or "name"

  local parts = {
    "%#Type#'%#Comment#:up",
    "%#Type#d%#Comment#:newdir",
    "%#Type#%%%#Comment#:newfile",
    "%#Type#D%#Comment#:delete",
    "%#Type#R%#Comment#:rename",
    "%#Type#s%#Comment#:sort (%#Type#" .. sort_by .. "%#Comment#)",
    "%#Type#gh%#Comment#:hidden",
  }
  return table.concat(parts, "  ")
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "'", "-", { remap = true, buffer = true })
    vim.opt_local.winbar = "%{%v:lua.get_netrw_winbar()%}"
  end,
})
