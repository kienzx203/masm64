extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	Tong_chan		dq	0
	Tong_le			dq	0
	space			db  20h, 0
.data?
	num_array		db	40 DUP (?)
	num_output		db	40 DUP (?)
	len				dq	?
	nByte			dd	?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 28h
 	xor		rbx, rbx
	mov		rcx, -10
	call	GetStdHandle

	mov		rcx, rax
	mov		rdx, offset num_array
	mov		r8, 30
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	ReadFile

	mov		r12, offset num_array
	push	r12
	call	ATOI
	mov		len, rax

L1:	

	cmp		len, 0
	jz		L4
	xor		rbx, rbx
	mov		rcx, -10
	call	GetStdHandle

	mov		rcx, rax
	mov		rdx, offset num_array
	mov		r8, 30
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	ReadFile
	dec		len
	mov		r12, offset num_array
	push	r12
	call	ATOI
	mov		rbx, 0
	mov		rcx, 0
	mov		rcx,rax
	mov		rbx, 2
	mov		rdx, 0
	div		rbx
	cmp		rdx, 0
	jz		L3
	jmp		L2

L2:	
	add		Tong_le, rcx
	jmp		L1
	
L3: 

	add		Tong_chan, rcx
	jmp		L1

L4:
 	mov		r12, Tong_chan
	mov		r13, offset num_output
	push	r12
	push	r13
	call	REATOI
	xor		rbx, rbx
	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset num_output
	mov		r8, 30
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile

	mov		r12, Tong_le
	push	r12
	mov		r13, offset num_output
	push	r13
	call	REATOI

	xor		rbx, rbx
	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset num_output
	mov		r8, 30
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile

	mov		ecx, 0
	call	ExitProcess


	
main ENDP
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
END