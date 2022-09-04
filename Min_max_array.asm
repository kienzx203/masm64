extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data?
    num_array	db	40 DUP (?)
	num_output	db	40 DUP (?)
	len			dq	?
    nByte		dq	?
.data
    sSizeReq    db  'Nhap kich thuoc mang n: ', 0
    sArrReq     db  'Nhap n phan tu cua mang: ', 0
    sMinResult  db  'Min: ', 0
    sMaxResult  db  'Max: ', 0
    max			dq	0
	min			dq	1000000

.code
main proc
    mov     rbp, rsp
    sub     rsp, 48h

    mov     rcx, -10
    call    GetStdHandle
    mov     [rbp - 8], rax      ;hInput
    mov     rcx, -11
    call    GetStdHandle
    mov     [rbp - 10h], rax    ;hOutput
    xor     r12, r12

    mov     rcx, [rbp - 10h]
    mov     rdx, offset sSizeReq
    mov     r8, sizeof sSizeReq
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    WriteFile

    mov     rcx, [rbp - 8h]
    mov     rdx, offset num_array
    mov     r8, 10
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    ReadFile

    mov     r13, offset num_array
    push    r13
    call    ATOI
    mov     len, rax

    mov     rcx, [rbp - 10h]
    mov     rdx, offset sArrReq
    mov     r8, sizeof sArrReq
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    WriteFile

L1:
    cmp     len, 0
    jz      L4
    mov     rcx, [rbp - 8h]
    mov     rdx, offset num_array
    mov     r8, 10
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    ReadFile
    dec		len
    mov     r13, offset num_array
    push    r13
    call    ATOI
    xor     r14, r14
    mov     r14, rax
    cmp     r14, max 
    jg      L3
    jmp     l2

L2:	
	cmp		r14, min
	jl		L5
	jmp		L1
	
L5:
	mov		min, r14
	jmp		L1

L3: 

	mov		max, r14
	jmp		L2

L4:
    xor     r12, r12
    mov     rcx, [rbp - 10h]
    mov     rdx, offset sMaxResult
    mov     r8, sizeof sMaxResult
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    WriteFile
    mov     r14, max
    push    r14
    mov     r13, offset num_output
    push    r13
    call    REATOI
    xor     r12, r12
    mov     rcx, [rbp - 10h]
    mov     rdx, offset num_output
    mov     r8, sizeof num_output
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    WriteFile

    mov     rcx, [rbp - 10h]
    mov     rdx, offset sMinResult
    mov     r8, sizeof sMinResult
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    WriteFile
    mov     r14, min
    push    r14
    mov     r13, offset num_output
    push    r13
    call    REATOI
    xor     r12, r12
    mov     rcx, [rbp - 10h]
    mov     rdx, offset num_output
    mov     r8, sizeof num_output
    mov     r9, offset nByte
    mov     [rsp + 20h], r12
    call    WriteFile

    mov		ecx, 0
	call	ExitProcess

main endp
ATOI PROC
	push	rbp
	mov		rbp, rsp
	push	rbx
	mov		rbx, [rbp+16]
	xor		rsi, rsi								
	xor		rax, rax
	mov		rcx, 10
L1:
	xor		rdx,rdx
	mov		dl, byte ptr [rbx+rsi]				
	cmp		dl, 0Dh								
	jz		L2
	sub 	rdx, 30h							
	add		rax, rdx							
	mul		rcx									
	inc		rsi									
	jmp		L1

L2:
	xor		rdx, rdx
	div		rcx
	pop		rbx
	pop		rbp
	ret		8
ATOI ENDP

REATOI PROC

    push    rbp
    mov     rbp, rsp
	xor		rax, rax
	xor		rbx, rbx
    mov     rax, [rbp + 24]						
    mov     rbx, [rbp + 16]						
    xor     rsi, rsi 
    mov     rcx, 10
    push    3Ah										

L1:
    xor     rdx, rdx
    div     rcx									
    or      rdx, 30h						
    push    rdx									
    cmp     rax, 0					
    jz      L2
    jmp     L1

L2:

    pop     rdx
    cmp     dl, 3Ah								
    jz      L3						
    mov     byte ptr [rbx + rsi], dl			
    inc     rsi
    jmp     L2

L3:
	mov		r8w, 0a0dh 
    mov     word ptr [rbx + rsi], r8w
    pop     rbp
    ret     16
REATOI ENDP
  
end