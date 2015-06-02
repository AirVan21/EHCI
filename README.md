# EHCI (Enhanced Host Controller Interface) #

EHCI-driver with related extensions which are written in Assembly. 

Implemented code could be used as a tunable module in projects (e.g. in embedded operation systems) where USB support is needed. 
Functionality is divided into parts:

* Host controller detection via PCI configuration space (with separate approach for UHCI, OHCI, EHCI, xHCI controlles)  
* EHCI controller initialization 
* EHCI controller driver implementation
* High-speed device configuration (Control Transfers)
* Bulk-Only Transport implementation for Mass Storage Devices (Bulk Transfers)




