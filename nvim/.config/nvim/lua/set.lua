vim.opt.number = true                             -- line number
vim.opt.relativenumber = true                     -- relative line numbers
vim.opt.cursorline = true                         -- highlight current line
vim.opt.wrap = false                              -- do not wrap lines by default
vim.opt.scrolloff = 10                            -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10                        -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 2                               -- tabwidth
vim.opt.shiftwidth = 2                            -- indent width
vim.opt.softtabstop = 2                           -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true                          -- use spaces instead of tabs
vim.opt.smartindent = true                        -- smart auto-indent
vim.opt.autoindent = true                         -- copy indent from current line

vim.opt.ignorecase = true                         -- case insensitive search
vim.opt.smartcase = true                          -- case sensitive if uppercase in string
vim.opt.hlsearch = true                           -- highlight search matches
vim.opt.incsearch = true                          -- show matches as you type

vim.opt.signcolumn = "yes"                        -- always show a sign column
vim.opt.showmatch = true                          -- highlights matching brackets
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.synmaxcol = 300                           -- syntax highlighting limit
vim.opt.fillchars = { eob = " " }                 -- hide "~" on empty lines

local undodir = vim.fn.expand("~/.vim/undodir")
if
    vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
  vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false                  -- do not create a backup file
vim.opt.writebackup = false             -- do not write to a backup file
vim.opt.swapfile = false                -- do not create a swapfile
vim.opt.undofile = true                 -- do create an undo file
vim.opt.undodir = undodir               -- set the undo directory
vim.opt.updatetime = 300                -- faster completion
vim.opt.timeoutlen = 500                -- timeout duration
vim.opt.ttimeoutlen = 50                -- key code timeout
vim.opt.autoread = true                 -- auto-reload changes if outside of neovim
vim.opt.autowrite = false               -- do not auto-save

vim.opt.backspace = "indent,eol,start"  -- better backspace behaviour
vim.opt.autochdir = false               -- do not autochange directories
vim.opt.iskeyword:append("-")           -- include - in words
vim.opt.path:append("**")               -- include subdirs in search
vim.opt.selection = "inclusive"         -- include last char in selection
vim.opt.mouse = "a"                     -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true               -- allow buffer modifications

vim.g.netrw_banner = 0                  -- hide netrw banner
