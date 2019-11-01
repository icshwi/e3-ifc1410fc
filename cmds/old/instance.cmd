###############################################################################
#
# PBI system   : Faraday Cup
# Location     : lab
#
# Support      : https://jira.esss.lu.se/projects/WP7FC
#
###############################################################################

# LOCATION: location of the system (section-subsection)
epicsEnvSet("RACKROW",                      "LAB-090Row")
epicsEnvSet("LOCATION",                     "LAB-010")
# INSTANCE: PBI device name (discipline-device-index)
epicsEnvSet("INSTANCE",                     "PBI-FC-002")
# SYSTEM: system name (LOCATION:SYSTEM)
epicsEnvSet("SYSTEM",                       "$(LOCATION):$(INSTANCE)")

# IF1410 device index (from the MTCA slot - see dmesg)
epicsEnvSet("ACQ_DEVID",                    "4")

# acquisition sub unit logical name
epicsEnvSet("ACQ_UNIT",                     "Ctrl-DAQ-003")

# maximum number of samples to acquire 
# for ADC3117 4 channels, maximum is 131072
epicsEnvSet("ACQ_SAMPLES",                  "131072")

# EVR device PCI ID (from lspci)
epicsEnvSet("EVR_DEVID",                    "0b:00.0")

# EVR unit logical name (make compatible with E3-MRFIOC)
epicsEnvSet("EVR_DISDEV", "TS-EVR")
epicsEnvSet("EVR_INDEX",  "001")

# AUTOSAVE folder to store sav files
epicsEnvSet("AS_TOP", "$(E3_CMD_TOP)")

# Timestamp event code (14 for internal 14hz or 10 for external event)
epicsEnvSet("TSTAMPEVT", "14")
