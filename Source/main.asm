    include printlib.lib 
    include pmode.lib 
    include ehci.lib
    include ehciCap.lib  
    include ehciOper.lib 
    include message.lib
    include pciconf.lib
    include control.lib
    include xhci.lib
    include xhciCap.lib
    include bulk.lib
    include timer.lib 
    USBCode segment use16
    assume	cs:USBCode, ds:USBCode, es:USBCode
    .486p
    org 100h   

main proc far

start:
	
    ; Setting Default PCI Address 
    ; ECX - parameter for searchUSBHCinPCI 
    mov ecx, (DEFAULT_ADDR + CLASS_SUBCLASS)
    call searchUSBHCinPCI

    ; Setting FS register for Memory Addressing
    call setProtectedMode     	

    ; Handle found Host Controllers 
    xor edi, edi 
    mov cx, NumberOfValidHC
  
  loopOverHC:  
	
    lea edx, HCBaseAddressStorage
    lea esi, HCPCIAddressStorage
    mov ebx, dword ptr [edx + edi]  ; Gets Base address
    mov eax, dword ptr [esi + edi]  ; Gets PCI address 
    cmp ebx, 0                      ; If Valid Base Address
    jz outLoopOverHC                ; Out in not Valid 
	
    mov HCBaseAddress, ebx          ; Save Base Address 
    mov HCPCIAddress, eax           ; Write PCI address 
	
    ;-------------------------------;
    ; Handle Host Controllers       ; 
    ; EHCI, xHCI are supported      ;

    lea ebx, HCPCIParamStorage      ; HC parameters
    mov eax, [ebx + edi]            ; 
    shr ax, 8                  	    ; ProgIF in AL
    and ax, 00FFh 				    ; 

    ; edi - contains offset for HC Addresses
    call displayUSBtype               

    cmp al, xHCI_ProgIF             ; xHCI HC 
    je handleXHCI 

    cmp al, EHCI_ProgIF             ; EHCI HC 
    je handleEHCI

    jmp handleOtherHC                
  
  handleXHCI:
    call processXHCIHC              ; Main xHCI Function
    jmp NextOverHCloop
  
  handleEHCI:
    call processEHCIHC              ; Main EHCI Function
    jmp NextOverHCloop 
  
  handleOtherHC:
    call dummyHCPrint               ; 'No support' print 	
  
  NextOverHCloop:
	
    add edi, 4                      ; Offset for HC Addresses 
    call printNewLineRM
    
    loop loopOverHC  

  outLoopOverHC:

    int 20h 	

; =====================================================================================================
; Extra libs

initPrint
initProtectedMode
initEHCI
initXHCI
initOperationalInfo
initMessageLib
initCapacityInfo
initPCIConfig
initControlLib
initCapacityInfoXHCI
initBulk
initTimer

; =====================================================================================================

	main endp
	USBCode ends
	end start 
