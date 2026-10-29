function ls --wraps eza --description 'alias ls=eza -lh --group-directories-first --icons=auto'
    eza -lh --group-directories-first --icons=auto $argv
end
