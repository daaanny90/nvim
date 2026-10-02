return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    -- Document existing key chains
    require('which-key').add {
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>l', group = '[L]SP' },
      { '<leader>o', group = '[O]bsidian', mode = { 'n', 'v' } },
      { '<leader>u', group = '[U]I' },
      { '<leader>g', group = '[G]it' },
      { '<leader>gm', group = '[M]erge request (GitLab)' },
      -- gitlab.nvim owns the whole gl* family; these only label it in the popup
      { 'gl', group = 'Git[L]ab MR' },
      { 'gla', group = 'Assignee' },
      { 'gll', group = 'Label' },
      { 'glr', group = 'Reviewer' },
    }
  end,
}
