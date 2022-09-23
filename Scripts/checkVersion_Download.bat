@echo off
setlocal EnableDelayedExpansion
set Interop_Version=%1
echo InteropVersion is %Interop_Version%
echo inside download function
P:\Data_Exchange\from_Roma\jenkins\datakit\Datakit_interop.pl -b=%Interop_Version% -r="NULL"
