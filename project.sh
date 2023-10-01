#!/usr/bin/bash
###########################################################################################
#                                    Pardis
###########################################################################################
# there's a project.sh in root of the project. before do anything, source it: . project.sh
#
# tools:
# memory debugger: valgrind
# system call tracer: strace
# display info about .obj files: objdump
#
# opening/editing files: noevim
#   folding/unfolding: z Shift+m, z Shift+r
#   switch between source/header: F1
#
# lookup refrences: ctags
# find/replace in single file: neovim
# find/replace in whole project: ambr <source_text> <dest_text>
# find files: ctrl-t | ff <file-name> | fzf | fd
# find string/text in single file: neovim (/)
# find string/text in whole project: ft <text> | rg <text>
# find docs of c standard librariy: install man-pages-devel and man <method>
#
# debugging: seergdb(uses gdb under the hood)
###########################################################################################
# pardis, test
app="pardis"
output_dir="output"

_createBuildDir() {
  echo ">>> Creating '$output_dir' directory"
  mkdir -p "$output_dir"
}

_generateTags() {
  echo ">>> generating tags"
  ctags --fields=+iaS --extras=+q --extras=+f -R src/*
}

_compile() {
  assembler="fasm"
  src="src/main.asm"

  echo ">>> Compiling"
  $assembler $src $output_dir/$app
}

_build() {
  _createBuildDir
  _generateTags
  _compile
}

_debug() {
  pushd $output_dir > /dev/null
  seergdb -s $app
  popd > /dev/null
}

_run() {
  echo ">>> Running $app"
  pushd $output_dir > /dev/null
  ./$app
  popd > /dev/null
}

_clean() {
  echo ">>> Cleaning '$output_dir' directory"
  rm -r "$output_dir"
}

_valgrind() {
  valgrind --leak-check=yes --show-leak-kinds=all -s -v $output_dir/$app
}

_findStrings() {
  strings $output_dir/$app | less
}

_findSymbolsInObj() {
  nm $output_dir/$app | less
}

p() {
  commands=("build" "run" "clean" "debug" "search" "search/replace" "generate tags" "valgrind" "find strings in the binary" "list symbols from object files")
  selected=$(printf '%s\n' "${commands[@]}" | fzf --header="project:")

  case $selected in
    "build")
      _build;;
    "debug")
      _debug;;
    "run")
      _run;;
    "clean")
      _clean;;
    "search")
      read -p "keyword: " p_keyword; rg "$p_keyword" ;;
    "search/replace")
      read -p "to_search: " to_search
      read -p "to_replace: " to_replace
      ambr "$to_search" "$to_replace" ;;
    "generate tags")
      _generateTags;;
    "valgrind")
      _valgrind;;
    "find strings in the binary")
      _findStrings;;
    "list symbols from object files")
      _findSymbolsInObj;;
    *) ;;
  esac
}
