-- use :Copilot setup to setup the plugin!!!
-- use this table to disable/enable filetypes
vim.g.copilot_filetypes = { xml = false, markdown = false }

-- <C-]>                   Dismiss the current suggestion.
-- <Plug>(copilot-dismiss)
--
--                                                 *copilot-i_ALT-]*
-- <M-]>                   Cycle to the next suggestion, if one is available.
-- <Plug>(copilot-next)
--
--                                                 *copilot-i_ALT-[*
-- <M-[>                   Cycle to the previous suggestion.
-- <Plug>(copilot-previous)

vim.cmd[[highlight CopilotSuggestion guifg=#555555 ctermfg=8]]
