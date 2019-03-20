use 5.010;
use strict;
use warnings;

open(my $fh, '>', glob('~/.vimrc')) or die;

my $vim = 
"syntax on
set number 
set tabstop=4 
set shiftwidth=4 
set smarttab 
set expandtab 
set smartindent
set hlsearch
nnoremap P gt
nnoremap O gT
";

print $fh $vim;
close($fh);

system('sudo apt-get install ack');

open(my $fh, '>>', glob('~/.bashrc')) or die;
my $setup = q(transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }) . "\n";
$setup .= q(alias clear_all="clear && printf '\e[3J'") . "\n";
$setup.= q(
ack_all() {
    ack "$1" /home/e.ovsepyan/mpop/mympop/
    ack "$1" /home/e.ovsepyan/mydawn/
    ack "$1" /home/e.ovsepyan/mr-music/
}

grep_all() {
    grep -r "$1" /home/e.ovsepyan/mpop/mympop/
    grep -r "$1" /home/e.ovsepyan/mydawn/
    grep -r "$1" /home/e.ovsepyan/mr-music/
}
) . "\n";

$setup.= q&
parse_git_branch() {
         git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[1;96m\]\u \[\033[0;92m\]\w\[\033[33m\]\$(parse_git_branch) \[\033[1;96m\]$ \[\033[00m\]"
& . "\n";
print $fh $setup;
close($fh);
system('source ~/.bashrc');


eval {
    system('git clone --recursive https://github.com/tony/tmux-config.git ~/.tmux');
    system('ln -s ~/.tmux/.tmux.conf ~/.tmux.conf')
};

say($@);

system('sudo apt-get install tmux');

#eval {
#    chdir glob('~/.tmux'); 
#    system('pwd');
#    system('git submodule init; git submodule update');
#    chdir glob('~/.tmux/vendor/tmux-mem-cpu-load'); 
#    system('pwd');
#    system('mkdir build');
#    chdir 'build';
#    system('pwdc');
#    system('cmake ..; make; sudo make install');
#};
#say($@);