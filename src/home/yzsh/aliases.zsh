# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"
alias cdt='cd $(mktemp -d)'

# services
alias weather='curl wttr.in/havana'

# zsh
alias reload='exec $SHELL'

# test
alias disk-write-speed='dd if=/dev/zero of=/tmp/twspeed.img bs=1G count=2 oflag=dsync; rm -vf /tmp/twspeed.img'

# ssh
alias sshu='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias scpu='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# clip copy
alias pubkey-copy="cat ~/.ssh/id_rsa.pub | tr -d '\n' | \xclip -selection clipboard"
alias xclip="xclip -selection clipboard"

# node
alias node-v8-version='node -p process.versions.v8'
