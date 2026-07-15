return {
  'andymass/vim-matchup',
  event = { 'BufReadPost', 'BufNewFile' },
  init = function()
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
  end,
}
