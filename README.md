# configfiles
My configfiles for my ubuntu configuration

Inspired by https://github.com/DoubleDotStudios/dotfiles/tree/main

1. Install kitty
   ```
   sudo apt install kitty
   ```
2. Install zsh
   ```
   sudo apt install zsh
   ```
3. Install ohmyzsh (https://github.com/ohmyzsh/ohmyzsh)
4. Install Hack Nerd Font (https://www.nerdfonts.com/font-downloads) and put *.ttf in ~/.local/share/fonts/Hack and make fc-cache -fv
5. Install lsd (https://github.com/lsd-rs/lsd/releases) or eza (https://github.com/eza-community/eza/blob/main/INSTALL.md)
6. Install bat (https://github.com/sharkdp/bat?tab=readme-ov-file#installation)
7. Install cattpuccin theme for bat (https://github.com/catppuccin/bat)
8. Install cattpuccin theme for kitty (https://github.com/catppuccin/kitty/blob/main/themes/mocha.conf)
9. Install nvim (https://github.com/neovim/neovim?tab=readme-ov-file)
10. Install nvchad (https://nvchad.com/docs/quickstart/install) -> theme: Space + t + h
11. Install fzf (https://github.com/junegunn/fzf/releases)
12. Install fzf-git (https://github.com/junegunn/fzf-git.sh?tab=readme-ov-file) mkdir ~/.config/fzf and put fzf-git.sh darein
13. Install fd (https://github.com/sharkdp/fd)
14. Install tmux (https://github.com/tmux/tmux)
15. Install tmux plugin manager (https://github.com/tmux-plugins/tpm)
16. Install tmux catppuccin (https://github.com/catppuccin/tmux?tab=readme-ov-file#installation)
17. Install git-delta (https://github.com/dandavison/delta/releases)
18. Install dunst (https://github.com/dunst-project/dunst)
19. Install zoxide (https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#getting-started)
20. Install atuin (https://docs.atuin.sh/#quickstart) (Pw: tevion89)
21. Install ctags
22. Install gptcommit


Config Files:
- ~/.config/kitty/kitty.conf
- ~/.zshrc
- ~/.config/kitt
- ~/.config/dunst/dunstrc/dunst.conf
- ~/.config/fzf/fzf-git.sh
- ~/.gitconfig
- ~/.config/bat/config
- ~/.tmux.conf

Ordner:
- ~/.config/nvim
- ~/.config/tmux/plugins/catppuccin/tmux

Optional:
1. Install btop (https://github.com/aristocratos/btop?tab=readme-ov-file#installation)
2. Install midnight commander (https://midnight-commander.org/)
3. Install ranger (https://github.com/ranger/ranger)

## Activity-Watch:

### Autostart einrichten (Ordner in ~/Applications/activitywatch)
1. Startprogramme öffnen
2. Hinzufügen
3. Name: Activity Watch
4. Befehl:
```
/home/<DEIN_USERNAME>/Applications/activitywatch/aw-qt
```

### Als Desktop-Icon hinzufügen

Datei erstellen:
```
vi ~/.local/share/applications/activitywatch-dashboard.desktop
```

Mit folgendem Inhalt:
```
[Desktop Entry]
Name=ActivityWatch Dashboard
Exec=xdg-open http://localhost:5600
Type=Application
Terminal=false
Icon=utilities-system-monitor
```

Dann ausführbar machen:
```
chmod +x ~/.local/share/applications/activitywatch-dashboard.desktop
```

Dann an Dash anheften

## Timewarior
https://timewarrior.net/docs/install/

Copy in Ordner ~/Applications:
```
cp check_wortkime.sh ~/Applications
```

Cron öffnen:
```
crontab -e
```

Cron job alle 5 Minuten ausführen lassen:
```
# Stündlich prüfen jeweils zur vollen Stunde
*/5 * * * * /home/lgbo/Applications/check_worktime.sh daily

# Tägliche Wochenübersicht um 10:00 und 16:00
0 10 * * * /home/lgbo/Applications/check_worktime.sh weekly
0 16 * * * /home/lgbo/Applications/check_worktime.sh weekly

```

Start und stop
```
timew start '!arbeit' issue '~Kommentar'

timew stop
```
