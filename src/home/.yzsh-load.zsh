# ${(%):-%x}

# CONSTANTS
__YZSH_DIR="${0:a:h}"

# LOAD CONFIG
if [[ "${E_YZSH_LOAD_HOME_CONFIG:-true}" == true && -f ~/.yzsh.env ]]; then
  source ~/.yzsh.env
fi

if [[ "$PWD" != "$HOME" && -f .yzsh.env ]]; then source .yzsh.env; fi

# LOAD ENVIRONMENT & CONFIG VARIABLES on CONSTANTS
# environment variables has priority over config variables
# scheme:  __VAR="${ENV_VAR:-"${CONFIG_VAR:-default}"}"
__YZSH_CACHE_DIR="${E_YZSH_CACHE_DIR:-"${YZSH_CACHE_DIR:-"${HOME}/.var/cache"}"}"
YZSH_GIT_REPOS_DIR="${E_YZSH_GIT_REPOS_DIR:-"${YZSH_GIT_REPOS_DIR:-"${__YZSH_CACHE_DIR}/yzsh"}"}"
__YZSH_DATA_DIR="${E_YZSH_DATA_DIR:-"${YZSH_DATA_DIR:-"${0:a:h}/.yzsh"}"}"
__YZSH_THEME="${E_YZSH_THEME:-$YZSH_THEME}"
__YZSH_PLUGINS=(${E_YZSH_PLUGINS:-${YZSH_PLUGINS[@]}})

# CONSTANTS (ENV VAR DEPENDANT)
__YZSH_GEN_DIR="${__YZSH_DATA_DIR}/gen"
__YZSH_LOAD_LOCAL_FILE="${__YZSH_GEN_DIR}/load.local.generated.zsh"

# CREATE DIRECTORIES
if [[ ! -d "$YZSH_GIT_REPOS_DIR" ]]; then
  mkdir -p "$YZSH_GIT_REPOS_DIR"
fi

# INCLUDE USER YZSH DATA
source "${__YZSH_DATA_DIR}/aliases.zsh"
source "${__YZSH_DATA_DIR}/environment.zsh"

# FUNCTIONS

err() {
  echo "ERROR> $*" >&2
}

inf() {
  echo "INFO> $*"
}

infn() {
  echo -n "INFO> $*"
}

debug() {
  # its a zsh fine solution but it leads to issues with shellscript and vscode
  # [[ "${ENV:l}" = (testing|test|debug) ]] && echo "DEBUG> $*"
  [[ "${ENV:l}" = 'testing' || "${ENV:l}" = 'test' || "${ENV:l}" = 'debug' ]] &&
    echo "DEBUG> $*"
}

__yzsh_load_object() {
  local -r object="$1"
  local -r type="$2"
  # its a zsh fine solution but it leads to issues with shellscript and vscode
  # if [[ ! "$type" = (plugin|theme) ]]; then
  if [[ "$type" != 'plugin' && "$type" != 'theme' ]]; then
    err 'object type must be: plugin or theme'
    return 1
  fi

  if [[ -z "$object" ]]; then
    err "${type} name empty"
    return 1
  fi

  local -r object_data_dir="${__YZSH_DATA_DIR}/${type}s"

  local -ra object_dirs=(
    "${object_data_dir}/3rd"
    "${object_data_dir}/local"
    "${object_data_dir}/user"
  )
  local -ra object_variants=(
    "${object}/${object}.${type}.zsh"
    "${object}.${type}.zsh"
  )

  for object_dir in "${object_dirs[@]}"; do
    for object_variant in "${object_variants[@]}"; do
      local object_path="${object_dir}/${object_variant}"
      # debug "type: ${type} object: ${object} path: '${object_path}'"
      if [[ -f "$object_path" ]]; then
        source "$object_path"
        debug "${type} ${object} loaded from '${object_path}'"
        return 0
      fi
    done
  done

  err "${type} ${object} can't be loaded"
  return 1
}

__yzsh_load_plugin() { __yzsh_load_object "$1" 'plugin'; }
__yzsh_load_theme() { __yzsh_load_object "$1" 'theme'; }

yzsh_main() {
  # load theme
  if [[ -n "$__YZSH_THEME" ]]; then
    __yzsh_load_theme "$__YZSH_THEME"
  fi

  # load functions
  fpath+=("${__YZSH_DATA_DIR}/functions")
  # shellcheck disable=SC2046
  autoload -Uz "${__YZSH_DATA_DIR}/functions/"*(:t)

  # load plugins from generated file
  if [[ -f "$__YZSH_LOAD_LOCAL_FILE" ]]; then
    source "$__YZSH_LOAD_LOCAL_FILE"
  fi

  # load plugins from `__YZSH_PLUGINS` variable
  if [[ "${#__YZSH_PLUGINS[@]}" -ne 0 ]]; then
    for plugin in "${__YZSH_PLUGINS[@]}"; do
      __yzsh_load_plugin "$plugin"
    done
  fi
}

if [[ "$ZSH_EVAL_CONTEXT" = "toplevel" ]]; then
  yzsh_main "$@"
fi
