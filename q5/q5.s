.section .data
filename: .string "input.txt"     # file
yes: .string "Yes\n"              # yes
no: .string "No\n"                # no

.section .text
.global main
.extern open
.extern read
.extern lseek
.extern close
.extern printf

main:

addi sp, sp, -16                  # sp = sp - 16
sd x1, 8(sp)                      # save x1

# open
la x10, filename                  # x10 = filename
addi x11, x0, 0                   # x11 = 0
call open                         # open
addi x20, x10, 0                  # x20 = fd

# size
addi x10, x20, 0                  # fd
addi x11, x0, 0                   # offset
addi x12, x0, 2                   # SEEK_END
call lseek                        # size
addi x21, x10, 0                  # x21 = size

addi x6, x21, -1                  # x6 = right

# check newline
addi x10, x20, 0                  # fd
addi x11, x6, 0                   # offset
addi x12, x0, 0                   # SEEK_SET
call lseek

addi x10, x20, 0                  # fd
addi x11, sp, 0                   # buffer
addi x12, x0, 1                   # read 1
call read

lbu x9, 0(sp)                     # x9 = char
addi x28, x0, 10                  # x28 = '\n'
bne x9, x28, set_right            # if not newline

addi x6, x6, -1                   # right--

set_right:
addi x5, x0, 0                    # x5 = left

loop:
bge x5, x6, is_pal                # if done

# seek left
addi x10, x20, 0                  # fd
addi x11, x5, 0                   # offset
addi x12, x0, 0                   # SEEK_SET
call lseek

# read left
addi x10, x20, 0                  # fd
addi x11, sp, 0                   # buffer
addi x12, x0, 1                   # read 1
call read

lbu x7, 0(sp)                     # x7 = left char

# seek right
addi x10, x20, 0                  # fd
addi x11, x6, 0                   # offset
addi x12, x0, 0                   # SEEK_SET
call lseek

# read right
addi x10, x20, 0                  # fd
addi x11, sp, 0                   # buffer
addi x12, x0, 1                   # read 1
call read

lbu x8, 0(sp)                     # x8 = right char

bne x7, x8, not_pal               # if not equal

addi x5, x5, 1                    # left++
addi x6, x6, -1                   # right--

beq x0, x0, loop                  # loop

is_pal:
la x10, yes                       # yes
call printf
beq x0, x0, done

not_pal:
la x10, no                        # no
call printf

done:
addi x10, x20, 0                  # fd
call close

ld x1, 8(sp)                      # load x1
addi sp, sp, 16                   # sp = sp + 16
ret