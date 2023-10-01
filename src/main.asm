format ELF64 executable

include "util.inc"
segment executable

start:
  write STDOUT, msg, msg_size
  exit EXIT_SUCCESS

segment readable writeable 
  msg db "Hello world!", 10
  msg_size = $ - msg
