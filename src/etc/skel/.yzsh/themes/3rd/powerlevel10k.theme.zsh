# shellcheck disable=SC1094

plugin_dir="${0:a:h}"
repo_dir="${YZSH_GIT_REPOS_DIR}/powerlevel10k"

[[ ! -d "$repo_dir" ]] &&
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$repo_dir"

source "${repo_dir}/powerlevel10k.zsh-theme"
