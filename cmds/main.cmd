###############################################################################
# Top script that includes other sub unit scripts.

# digitizer support
< dataAcquisition.cmd

# timing (MRF EVR) setup
iocshLoad("$(adifc14_DIR)/evr.setup")

# autosave setup
#iocshLoad("$(adifc14_DIR)/autosave.setup")

###############################################################################

iocInit()

###############################################################################

< post_init.cmd

# comment out if no EVR 
iocshLoad("$(adifc14_DIR)/evr_standalone.init")

# comment out if timestamping is not used 
iocshLoad("$(adifc14_DIR)/evr_timestamping.init")

#######################################
#     End of IOC startup commands     #
#######################################
