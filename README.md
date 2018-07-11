# zsh plugin fzf finder

Shamelessly inspired from [@ael-code][ael] [zsh fasd plugin][0] ;)

A zsh plugin to search in the local tree of subdirectories for files (just files! No directories nor links).

It is powered by [fzf][1] and optionally [bat][2] (otherwise falls back to `cat`).

The quick jump functionality is bound on ALT-f shortcut.

## Install
### Antigen
```
antigen bundle leophys/zsh-plugin-fzf-finder
```

[ael]: https://github.com/ael-code
[0]: https://github.com/ael-code/zsh-plugin-fasd-fzf
[1]: https://github.com/junegunn/fzf
[2]: https://github.com/sharkdp/bat
