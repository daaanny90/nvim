return {
  'andymass/vim-matchup',
  event = { 'BufReadPost', 'BufNewFile' },
  init = function()
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
    -- The bundled treesitter matchup query references `php_end_tag`, a node
    -- removed from tree-sitter-php. Its query fails to compile and throws on
    -- every matchparen timer tick in PHP buffers (e.g. wp-config.php). Disable
    -- the treesitter engine for PHP only; matchup falls back to its classic
    -- regex/match-words engine, which still matches <?php ?>, if/endif, etc.
    vim.g.matchup_treesitter_disabled = { 'php' }
  end,
}
