# README.TXT

This project is a generic base for a Assembly project for the MC68HC908QY4.

Folders used:
- Sources: contains your sources.
- Debugger Cmd Files: Here you can place your own specific debugger command
  files.
- Startup Code: Contains the startup code of the application. You may adapt it
  to your own needs, but in such a case make sure that you create a local copy.
- Prm: Linker parameter file used for linking. Note that the file used for the linker
  is specified in the Linker Preference Panel itself (<ALT-F7> or Edit->{Current Build Target Name} settings,
  while the project window is opened).
- Libs: contains the library to be linked with.
- Debugger Project File: This *.ini file is passed to the debugger/simulator
  as configuration file. It contains various target interface settings, and path
  information as well. This file can be edited from the simulator/debugger e.g. using
  File->Configuration in the simulator/debugger.

Available CodeWarrior Targets:

- P&E PEDebug FCS-ICS-ICD
  This target is set up to generate an application to be debugged 
  with the P&E PEDebug target interface in FCS (Full Chip Simulation),
  ICS (In-Circuit Simulation) or ICD (In-Circuit Debug/Programming). 

- MMDS-MMEVS
  This target is set up to generate an application to be debugged 
  with the Motosil target interface on MMDS/MMEVS. 

- Cyclone
  This target is set up to generate an application to be debugged 
  with the Cyclone target interface. 


Note that this project is set up for a P&E PEDebug FCS-ICS-ICD by default.
But you can easily change this to work with a target:
- launch the simulator/debugger using Project->Debug (while
  the current project window is opened)
- Choose in the simulator/debugger Component->Set Target and then choose a
  target interface
- Choose in the simulator/debugger File->Save Project so the new target
  settings are saved
  
This project includes a burner command file (.bbl) in order to generate a 
SRecord file (.s19). Remove this file from prm folder if no SRecord is needed.

This application is meant to demonstrate a framework for an application 
running on the 68HC908QY4.It demonstrates interrupts from the timer
and uses general purpose timeouts.

Application Information:

 (1) An output compare channel of the timer is used to create a time
     base for the application. Output compare intervals happen every
     2ms, and is continually set up in the timer interrupt service
     routine. The internal Bus clock is 2.4576 MHZ.
 (2) Provides three general purpose timeouts, each with a resolution of
     2ms and a maximum timeout of 510 ms (1-255). The timeout 1 is set
     to three initially, so should fire after 6ms. When the event is
     handled, the temp_byte variable is incremented and PORTA in inverted
     To see the variable being incremented, type "VAR TEMP_BYTE".  After
     starting the conversion, the timeout 1 routine schedules another
     timeout 1 routine in 6ms (timeout=3).
 (3) Note that the COP watchdog is not handled on purpose. If you run the
     simulator, you will see simulation stops after $20000 bus cycles, with
     a reset being reported due to a COP timeout. To disable the COP,
     remove the semicolon in front of the 'sta copctl' line in the main
     routine. NOTE! Before you program this into the actual MCU using
     prog08SZ, you should uncomment the 'sta copctl' line or you will
     not see a nice wave form on PORTA (COP reset will be constantly
     restarting this demo application).

Metrowerks