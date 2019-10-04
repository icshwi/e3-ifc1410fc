########################################
#        IOC startup entry point       #
########################################

# Dynamic loading of the necessary modules
require busy,1.7.2
require asyn,4.33.0
require autosave,5.10.0
require iocStats,3.1.16
require ADCore,3.3.2

require mrfioc2,2.2.0-rc5
require nds3epics,1.0.0

require admisc,develop
require adifc14,develop
require ifc1410fc,develop

# instance.cmd defines all variables that differe between instances of this
# IOC. For example hardware IDs, Naming service names,..
< instance.cmd

# main.cmd will start with loading loading system components, call
# iocBoot() and run all the dbpf commands after IOC has started.
< main.cmd
