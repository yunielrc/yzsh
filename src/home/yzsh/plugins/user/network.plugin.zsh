# Network

# Aliases
alias net-ip-public-dig='dig +short myip.opendns.com @resolver1.opendns.com'
alias net-ip-public-curl='curl checkip.amazonaws.com'
alias net-ip-public-wget='wget -qO - checkip.amazonaws.com'
alias net-random-mac="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/:$//'"
alias net-internet-speed="wget --report-speed=bits -O /dev/null http://ipv4.download.thinkbroadband.com/20MB.zip"
