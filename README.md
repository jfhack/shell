# Shell
This is the shell that I use daily and that I have configured with [fish](https://github.com/fish-shell/fish-shell) and the modified [shellder](https://github.com/simnalamburt/shellder) theme.

I consider it fast enough to use it in the small Raspberry Pi Zero

Tested on many debian based distros and manjaro

# Installation
```sh
./install.sh
```
This will install [fish](https://github.com/fish-shell/fish-shell) with the modified [shellder](https://github.com/simnalamburt/shellder) theme, the plugin manager [fisher](https://github.com/jorgebucaran/fisher) and the [z](https://github.com/jethrokuan/z) plugin (this is located in [fish/configure.fish](fish/configure.fish))

This will also install [exa](https://github.com/ogham/exa) and [bat](https://github.com/sharkdp/bat)

[exa](https://github.com/ogham/exa) and [bat](https://github.com/sharkdp/bat) are provided as individual installable scripts
```sh
./install_only_exa.sh
./install_only_bat.sh
```

# Screenshots

![fish completion list](images/1.png "fish completion list")
![bat alias without line numbers and pagination](images/2.png "bat alias without line numbers and pagination")
![error return](images/3.png "error return")
![exa alias with icons and behavior with git](images/4.png "exa alias with icons and behavior with git")

# Font

The font I use is `MesloLGS NF` included in the fonts directory

# Troubleshooting

In some cases the appearance of the symbols may not be correct, for example a question mark may appear at the end of the prompt, this can be solved by installing the `locales-all` package

For example in debian based distros
```sh
sudo apt install locales-all
```

# Gnome Terminal

The colors shown in the screenshots were obtained from [alacritty](https://github.com/alacritty/alacritty) and were exported to Gnome Terminal with the command
```sh
dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
```
so they can be imported as follows
```sh
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
```

and this should look like this

![Gnome Terminal profiles](images/5.png "Gnome Terminal profiles")
