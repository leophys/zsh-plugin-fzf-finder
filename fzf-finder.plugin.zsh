(( $+commands[fzf] )) || return
(( $+functions[fzf-find-widget] )) && return
(( $+commands[fzf-tmux] )) || return

(( $+commands[bat] )) && FZF_FINDER_CAT='bat --color always {}' || FZF_FINDER_CAT='cat {}'

fzf-finder-find() { (( $+commands[fd] )) && $commands[fd] -t f || find * -type f -not -path './.git/*\' }

fzf-finder-widget() {
    local target
    target="$(fzf-finder-find | \
        fzf-tmux -1 -0 \
        --no-sort \
        --ansi \
        --reverse \
        --toggle-sort=ctrl-r \
        --preview $FZF_FINDER_CAT \
        )" \
    && if [[ -z $TMUX ]]; then \
        $FZF_FINDER_EDITOR "${target}"; \
     else \
        tmux new-window ${EDITOR:-vim} "${target}"; \
     fi
    local ret=$?
    zle reset-prompt
      typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}

zle -N fzf-finder-widget
bindkey ${FZF_FINDER_BINDKEY:-'\ee'} fzf-finder-widget
