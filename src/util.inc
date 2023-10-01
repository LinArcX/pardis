;; syscalls
SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

;; file descriptors
STDIN equ 0
STDOUT equ 1
STDERR equ 2

;; error codes
EXIT_SUCCESS equ 0
EXIT_ERROR equ 1

macro exit code
{
  mov rax, SYS_EXIT
  mov rdi, code 
  syscall
}

macro write fd, msg, msg_size
{
  ; ssize_t write(int fd, const void *buf, size_t count);
  mov rax, SYS_WRITE
  mov rdi, fd 
  mov rsi, msg
  mov rdx, msg_size
  syscall
}
