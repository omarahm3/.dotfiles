function notes --description 'notes - search notes and open it in nvim'
  set note (fd . $HOME/.brain | fzf)

  if test -n "$note"
    nvim $note
  end
end
