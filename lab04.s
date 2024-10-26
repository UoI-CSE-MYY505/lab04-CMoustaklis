
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
            lbu t0, 0(a0)
            lbu t1, 0(a1)
            sub t2, t0, t1
            
            addi a0, a0, 1
            addi a1, a1, 1
        
            beq t0, zero, out_str_ge
            beq t1, zero, out_str_ge
            beq t2, zero, str_ge
out_str_ge:
            srli a0, t2, 31
            xori a0, a0, 1
            jr   ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
            bne a1, zero, sfc
            addi a0, zero, 1
            jr ra
sfc:
            addi t0, zero, 1
            bne a1, t0, ssc
            addi a0, zero, 1
            jr ra
ssc:        
#keep ra, a0 ,a1
            addi sp, sp, -12
            sw ra, 8(sp)
            sw a0, 4(sp)
            sw a1, 0(sp)
#prepare inputs of str_ge
            lw a1, 0(a0)
            lw a0, 4(a0)
            jal str_ge
#check for a[1] > a[0]
            beq a0, zero, return
            #recursion
            lw a0, 4(sp)
            lw a1, 0(sp)
            addi a0, a0 4
            addi a1, a1, -1
            jal recCheck
return:
            lw ra, 8(sp)
            addi sp, sp, 12
            jr   ra
