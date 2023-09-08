# ${(%):-%x}
: "${YZSH_BASE_PATH:="${0:a:h}"}"
YZSH_LIB_PATH=${0:a:h}
# shellcheck disable=SC1094
. "${YZSH_LIB_PATH}/lib/utils.zsh"

# GLOBAL VARIABLES
# YZSH_CONFIG_DIR=~/.config/my-zsh
YZSH_GEN_DIR="${YZSH_BASE_PATH}/gen"
YZSH_LOAD_LOCAL="${YZSH_GEN_DIR}/load.local.generated.zsh"
[[ ! -d "$YZSH_GEN_DIR" ]] && mkdir -p "$YZSH_GEN_DIR"

# INCLUDE

. "${YZSH_BASE_PATH}/config.zsh"
. "${YZSH_BASE_PATH}/aliases.zsh"
. "${YZSH_BASE_PATH}/environment.zsh"

# FUNCTIONS

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

  local -r object_base_dir="${YZSH_BASE_PATH}/${type}s"

  local -ra object_dirs=(
    "${object_base_dir}/3rd"
    "${object_base_dir}/local"
    "${object_base_dir}/user"
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
        . "$object_path"
        debug "${type} ${object} loaded from '${object_path}'"
        return 0
      fi
    done
  done

  err "${type} ${object} can't be loaded"
  return 1
}

yzsh_load_plugin() { __yzsh_load_object "$1" 'plugin'; }
__yzsh_load_theme() { __yzsh_load_object "$1" 'theme'; }

yzsh_main() {
  # load theme
  if [[ -n "$YZSH_THEME" ]]; then
    __yzsh_load_theme "$YZSH_THEME"
  fi

  # load functions
  fpath+=("${YZSH_BASE_PATH}/functions")
  # shellcheck disable=SC2046
  autoload -Uz "${YZSH_BASE_PATH}/functions/"*(:t)

  # load plugins from file
  . "${YZSH_BASE_PATH}/load.zsh"

  # load plugins from dotfiles generated file
  if [[ -f "$YZSH_LOAD_LOCAL" ]]; then
    . "$YZSH_LOAD_LOCAL"
  fi

  # load plugins from `YZSH_PLUGINS` variable
  if [[ "${#YZSH_PLUGINS[@]}" -ne 0 ]]; then
    for el in "${YZSH_PLUGINS[@]}"; do
      yzsh_load_plugin "$el"
    done
  fi
}

if [[ "$ZSH_EVAL_CONTEXT" = "toplevel" ]]; then
  yzsh_main "$@"
fi
