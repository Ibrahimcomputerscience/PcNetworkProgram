@echo off
color F1

Title PcSpecsNetInfo 

echo /-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-\-/-\-/-\-/-\-/-\
echo.
echo Hello! This program will help you know what your computer specifications and network configuration are :)
echo.


:MENU
echo /-\-/-\-/-\-/-\-/-\ M E N U /-\-/-\-/-\-/-\-/-\
echo.
echo Press H for hardware configuration
echo Press N for network configuration 
echo Press C to clear Screen
echo.

set M=
set /p M=Make a choice or press ENTER to quit:
:: /I makes it not case sensitive 
if /I %M%==h goto Hardware
if /I %M%==n goto Network
if %M%==ENTER goto EOF
if /I %M%==C goto Cls
echo.
echo Invalid option :( , please try again 
echo.
goto MENU


:Hardware
echo.
echo /-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-\-/-\-/-\-/-\-/-\
echo.
echo Please wait a moment while we list all your hardware configuration. Thank you for your patience
echo.
rem Get the name of the device
systeminfo | findstr /C:"Host Name" 
echo.
rem Get name of company that produced the computer
systeminfo | findstr /C:"System Manufacturer"
echo.
rem Get computer model
systeminfo | findstr /C:"System Model"
echo.
rem Get number of bits in the system
systeminfo | findstr /C:"System Type"
echo.
rem Get operating system
systeminfo | findstr /C:"OS Name"
echo. 
rem Get OS version and BIOS manufacturer,version,date 
systeminfo | findstr /C:"Version"
echo.
rem get motherboard(baseboard) information
echo Motherboard:
wmic baseboard get product,Manufacturer,version
rem get chipset, number of cpus and their names
systeminfo | findstr /C:"Processor"
echo.
echo CPU(s):
wmic cpu get "name"
echo Chipset:
wmic cpu get "caption"
rem get gpus,if any
echo GPU(s):
wmic path win32_videocontroller get "name"
rem get diskdrive and its capacity
echo Disk Drive:
wmic diskdrive get Size,Model            
rem Get amount of RAM installed
echo RAM:
systeminfo | findstr /C:"Total Physical Memory"
echo.
echo Current Unused RAM:
rem Get amount of RAM that is currently not being used by the computer
systeminfo | findstr /C:"Available Physical Memory"
echo.
rem Get virtual memory(management technique where the OS uses a portion of a storage device(SSD or hard disk) as an extension of the insufficient RAM)
echo Virtual Memory:
wmic OS get TotalVirtualMemorySize
rem Get the amount of virtual memory that is currently not being used by the computer
echo Current Unused Virtual Memory:
wmic OS get FreeVirtualMemory
rem get page file space(which is the reserved space on a storage device that the OS uses as an extension of RAM) 
echo Page File Space:
wmic pagefile list /format:list | findstr "AllocatedBaseSize"
echo.
rem Get the number that differentiates devices with the same System Model name
wmic computersystem get SystemSKUNumber 
goto MENU


:Network
echo.
echo /-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-\-/-\-/-\-/-\-/-\
echo.
echo Please wait a moment while we list all your network configuration. Thank you for your patience
echo. 
echo #VPN#
rem A virtual private network creates a secure connection between a device and a network
ipconfig /all |findstr "Tunnel"
rem the special variable errorlevel holds the result of the last executed command.
if %errorlevel% == 0 (
rem errorlevel of 0 indicates that the previous command executed successfully without errors.
echo               ***Connected to a VPN***
) else (
echo     Not connected to a VPN
)
echo.
echo.
echo #Proxy#
rem A proxy server is an intermediary between a client device and the internet
netsh winhttp show proxy | findstr "Proxy Server(s): "
if %errorlevel% == 0 (
echo ****Proxy is being used****
) else (
netsh winhttp show proxy | findstr "Direct Access"
rem this means that no proxy has been found
)
echo.
echo.
echo #IPv4 Addresses#
rem IPv4 requires manual configuration of DHCP 
ipconfig | findstr /R /C:"Wireless LAN adapter Wi-Fi" /C:"Ethernet adapter" /C:"IPv4 Address" 
echo.
echo.
echo #DHCP Servers#
rem DHCP assigns IP addresses to devices
ipconfig /all | findstr /R /C:"Wireless LAN adapter Wi-Fi" /C:"Ethernet adapter" /C:"DHCP Server"
echo.
echo.
echo #IPv6 Addresses#
rem IPv6 was developed to overcome the limitations of IPv4, particularly the exhaustion of available addresses
ipconfig | findstr /R /C:"Wireless LAN adapter Wi-Fi" /C:"Ethernet adapter" /C:"IPv6 Address"
echo.
echo.
echo #Subnet Masks#
rem A subnet mask divides IP addresses into 2 parts. The first part identifies the network and the second one identifies the host 
ipconfig /all | findstr /R /C:"Wireless LAN adapter Wi-Fi" /C:"Ethernet adapter" /C:"Subnet Mask"
echo.
echo.
echo #Physical Addresses#
rem A physical address also known as a MAC address, serves as a unique identifier for a device in a network
ipconfig /all | findstr /R /C:"Wireless LAN adapter Wi-Fi" /C:"Ethernet adapter" /C:"Physical Address"
echo.
echo.
echo #DNS Servers#
rem A DNS server translates human-readable domain names into their corresponding IP addresses 
ipconfig /all | findstr /R /C:"Wireless LAN adapter Wi-Fi" /C:"Ethernet adapter" /C:"DNS Servers"
echo.
echo.
echo #Default Gateways#
rem A default gateway makes it possible for devices in one network to communicate with devices in another network. It serves as the "door" between these networks
echo  
ipconfig /all | findstr /R /C:"Wireless LAN adapter Wi-Fi" /C:"Ethernet adapter" /C:"Default Gateway"
echo.
goto MENU


:Cls
echo.
cls
goto MENU
