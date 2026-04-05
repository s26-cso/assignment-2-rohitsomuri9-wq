.globl make_node
make_node:

addi sp, sp, -16            # sp = sp - 16
sd x1, 8(sp)                # save x1

addi x5, x10, 0             # x5 = val

addi x10, x0, 24            # x10 = 24
call malloc                 # malloc

sw x5, 0(x10)               # store val
sd x0, 8(x10)               # left = 0
sd x0, 16(x10)              # right = 0

ld x1, 8(sp)                # load x1
addi sp, sp, 16             # sp = sp + 16
ret                         # return



.globl insert
insert:

# x10 = root
# x11 = val

bne x10, x0, check          # if root != 0

addi sp, sp, -16            # sp = sp - 16
sd x1, 8(sp)                # save x1
addi x10, x11, 0            # x10 = val
call make_node              # create node
ld x1, 8(sp)                # load x1
addi sp, sp, 16             # sp = sp + 16
ret

check:
lw x5, 0(x10)               # x5 = root->val

beq x11, x5, equal          # if equal
blt x11, x5, left           # if smaller

right:
addi sp, sp, -24            # sp = sp - 24
sd x1, 16(sp)               # save x1
sd x10, 8(sp)               # save root

ld x10, 16(x10)             # x10 = right
call insert                 # insert

ld x7, 8(sp)                # x7 = root
sd x10, 16(x7)              # right = result
addi x10, x7, 0             # x10 = root

ld x1, 16(sp)               # load x1
addi sp, sp, 24             # sp = sp + 24
ret

left:
addi sp, sp, -24            # sp = sp - 24
sd x1, 16(sp)               # save x1
sd x10, 8(sp)               # save root

ld x10, 8(x10)              # x10 = left
call insert                 # insert

ld x7, 8(sp)                # x7 = root
sd x10, 8(x7)               # left = result
addi x10, x7, 0             # x10 = root

ld x1, 16(sp)               # load x1
addi sp, sp, 24             # sp = sp + 24
ret

equal:
ret                         # already present



.globl get
get:

# x10 = root
# x11 = val

beq x10, x0, not_found      # if root == 0

lw x5, 0(x10)               # x5 = root->val

beq x11, x5, found          # if equal
blt x11, x5, go_left        # if smaller

go_right:
addi sp, sp, -16            # sp = sp - 16
sd x1, 8(sp)                # save x1

ld x10, 16(x10)             # x10 = right
call get                    # search right

ld x1, 8(sp)                # load x1
addi sp, sp, 16             # sp = sp + 16
ret

go_left:
addi sp, sp, -16            # sp = sp - 16
sd x1, 8(sp)                # save x1

ld x10, 8(x10)              # x10 = left
call get                    # search left

ld x1, 8(sp)                # load x1
addi sp, sp, 16             # sp = sp + 16
ret

found:
ret

not_found:
addi x10, x0, 0             # x10 = 0
ret



.globl getAtMost
getAtMost:

# x10 = val
# x11 = root

addi x5, x0, -1             # x5 = -1

loop:
beq x11, x0, end            # if root == 0

lw x6, 0(x11)               # x6 = val

ble x6, x10, new_ans        # if <=

ld x11, 8(x11)              # go left
beq x0, x0, loop

new_ans:
addi x5, x6, 0              # x5 = val
ld x11, 16(x11)             # go right
beq x0, x0, loop

end:
addi x10, x5, 0             # x10 = result
ret