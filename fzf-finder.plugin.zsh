(( $+commands[fzf] )) || return
(( $+functions[fzf-find-widget] )) && return
(( $+commands[fzf-tmux] )) || return

(( $+commands[bat] )) && FZF_FINDER_CAT='bat --color always {}' || FZF_FINDER_CAT='cat {}'

if [[ -z $FZF_FINDER_PAGER ]]; then
    (( $+commands[bat] )) && FZF_FINDER_PAGER='bat' || FZF_FINDER_PAGER='less'
fi

fzf-finder-find() { 
    if (( $+commands[fd] )); then 
        if (( $+FZF_FINDER_FD_OPTS )); then
            FINDER_OPTS=$FZF_FINDER_FD_OPTS
        else 
            FINDER_OPTS='-t f'
        fi
        $commands[fd] $(echo $FINDER_OPTS ) 
    else 
        if (( $+FZF_FINDER_FIND_OPTS )); then
            FINDER_OPTS=$FZF_FINDER_FIND_OPTS
        else
            FINDER_OPTS="-type f -not -path './.git/*\'"  
        fi
        find * $(echo $FINDER_OPTS)
    fi
}

fzf-finder-widget-editor() {
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
        ${FZF_FINDER_EDITOR:-vim} "${target}"; \
     else \
        local this_session
        local target_name
        target_name=$(basename ${target}|sed -e 's/\./_/g')
        this_session=$(tmux display-message -p '#S')
        tmux new-window -t ${this_session} -n ${target_name} -d ${FZF_FINDER_EDITOR:-vim} "${target}"; \
        tmux select-window -t ${target_name}
     fi
    local ret=$?
    zle reset-prompt
      typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}

fzf-finder-widget-pager() {
    local target
    target="$(fzf-finder-find | \
        fzf-tmux -1 -0 \
        --no-sort \
        --ansi \
        --reverse \
        --toggle-sort=ctrl-r \
        --preview $FZF_FINDER_CAT \
        )"
    ${FZF_FINDER_PAGER} "${target}"
    local ret=$?
    zle reset-prompt
      typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}

zle -N fzf-finder-widget-editor
bindkey ${FZF_FINDER_EDITOR_BINDKEY:-'\ee'} fzf-finder-widget-editor
zle -N fzf-finder-widget-pager
bindkey ${FZF_FINDER_PAGER_BINDKEY:-'\er'} fzf-finder-widget-pager
