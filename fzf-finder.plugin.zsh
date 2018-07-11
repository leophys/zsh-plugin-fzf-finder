if [[ $commands[bat] ]]; then
    CAT="bat --color always"
else
    CAT="cat"
fi

if [[ $commands[fzf] ]]; then
    fzf-find-widget() {
        local target
        target="$(find * -type f -not -path './.git/*\'| \
            fzf-tmux -1 -0 \
            --no-sort \
            --ansi \
            --reverse \
            --toggle-sort=ctrl-r \
            --preview 'bat --color always {}' \
            )" \
        && vim "${target}"
        local ret=$?
        zle reset-prompt
          typeset -f zle-line-init >/dev/null && zle zle-line-init
        return $ret
    }
    zle -N fzf-find-widget
    bindkey '\ef' fzf-find-widget
fi
