########################################
#        IOC startup entry point       #
########################################

# Dynamic loading of the necessary modules
require busy,1.7.2
require asyn,4.33.0
require autosave,5.10.0
require iocStats,3.1.16
require ADCore,3.3.2
require calc,3.7.1

require mrfioc2,2.2.0-rc5
require nds3epics,1.0.0

require admisc,develop
require adifc14,develop
require ifc1410fc,develop

# instance.cmd defines all variables that differe between instances of this
# IOC. For example hardware IDs, Naming service names,..
< instance.cmd

###############################################################################
# Top script that includes other sub unit scripts.

# digitizer support
< dataAcquisition.cmd

# timing (MRF EVR) setup
iocshLoad("$(adifc14_DIR)evr.setup")

# autosave setup
#iocshLoad("$(adifc14_DIR)/autosave.setup")

###############################################################################

# afterInit("./post_init.cmd")
# afterInit("$(adifc14_DIR)evr_standalone.init")


iocInit()

###############################################################################

iocshLoad("post_init.cmd")

# comment out if no EVR 
iocshLoad("$(adifc14_DIR)/evr_standalone.init")

# comment out if timestamping is not used 
#iocshLoad("$(adifc14_DIR)/evr_timestamping.init")

#######################################
#     End of IOC startup commands     #
#######################################
