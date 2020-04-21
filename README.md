https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html

```bash
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/mshogren/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
git dot config --local status.showUntrackedFiles no
```
