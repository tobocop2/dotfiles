-- Seamless <C-h/j/k/l> navigation between nvim splits and tmux panes.
-- Pairs with the matching plugin in ~/.config/tmux/tmux.conf.
return {
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    cmd = {
      'TmuxNavigateLeft', 'TmuxNavigateDown',
      'TmuxNavigateUp',   'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
  },
}
