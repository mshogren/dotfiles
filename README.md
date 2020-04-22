https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html

First install the minimal dependencies
```bash
sudo apt-get update && apt-get upgrade -y
sudo apt-get install git rsync
```

Then clone the dotfiles
```bash
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/mshogren/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
git dot config --local status.showUntrackedFiles no
```
