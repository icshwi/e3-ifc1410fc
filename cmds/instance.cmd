###############################################################################
#
# PBI system   : Faraday Cup
# Location     : lab
#
# Support      : https://jira.esss.lu.se/projects/WP7FC
#
###############################################################################

# LOCATION: location of the system (section-subsection)
epicsEnvSet("LOCATION",                     "LAB-010")
epicsEnvSet("RACKROW",                     "LAB-010")
# INSTANCE: PBI device name (discipline-device-index)
epicsEnvSet("INSTANCE",                     "PBI-FC-002")
# SYSTEM: system name (LOCATION:SYSTEM)
epicsEnvSet("SYSTEM",                       "$(LOCATION):$(INSTANCE)")
# # EVR_FRU: EVR device name for this system/IOC (discipline-device-index)
# epicsEnvSet("EVR_FRU",                      "PBI-EVR-031")

# # HV_FRU: high voltage control unit logical name
# epicsEnvSet("HV_FRU",                       "HV06")
# # MCU_FRU: motion control unit logical name
# epicsEnvSet("MCU_FRU",                      "MCU08")

# # ACQ_FRU: acquisition unit logical name
# epicsEnvSet("ACQ_FRU",                      "AMC31")
# # ECIO_xxx_FRU: individual EtherCAT IO control unit logical names
# #               used in HV_FRU and MCU_FRU
# epicsEnvSet("ECIO_CPLR_FRU",                "ECIO81")
# epicsEnvSet("ECIO_AIN1_FRU",                "ECIO82")
# epicsEnvSet("ECIO_AOUT1_FRU",               "ECIO83")
# epicsEnvSet("ECIO_DOUT1_FRU",               "ECIO84")
# epicsEnvSet("ECIO_DOUT2_FRU",               "ECIO85")
# epicsEnvSet("ECIO_DIN1_FRU",                "ECIO86")
# # Note: above values should come from ESS Naming service

# ACQ_DEVID: digitizer device index (from list of /dev/sis8300-n path)
epicsEnvSet("ACQ_DEVID",                    "4")
# ACQ_UNIT: acquisition sub unit logical name
epicsEnvSet("ACQ_UNIT",                     "AQ$(ACQ_DEVID)")

# ACQ_SAMPLES: maximum number of samples to acquire
#              100k per channel per rate (14 Hz), this is highly conservative
#              when looking at ~10Msps for 6ms of pulse length.
epicsEnvSet("ACQ_SAMPLES",                  "100000")

# HV_UNIT: high voltage control sub unit logical name
#epicsEnvSet("HV_UNIT",                      "HV1")
# MC_UNIT: motion control unit logical name
#epicsEnvSet("MC_UNIT",                      "MC1")

# EVR_DEVID: EVR device PCI ID (from lspci)
epicsEnvSet("EVR_DEVID",                    "0b:00.0")
# EVR_UNIT: EVR unit logical name
epicsEnvSet("EVR_UNIT",                     "PBI-EVR-031")

# ECAT_FREQ: ethercat frequency
#epicsEnvSet("ECAT_FREQ",                    "1000")
# limit CAS to controls network only
# not sure if it helps?!
# epicsEnvSet("EPICS_CAS_INTF_ADDR_LIST",     "enp0s25")
# epicsEnvSet("EPICS_CAS_IGNORE_ADDR_LIST",   "192.168.1.25")

# EVR unit logical name (make compatible with E3-MRFIOC)
epicsEnvSet("EVR_DISDEV", "PBI-EVR")
epicsEnvSet("EVR_INDEX",  "031")

# AUTOSAVE folder to store sav files
epicsEnvSet("AS_TOP", "$(E3_CMD_TOP)")

# Timestamp event code (14 for internal 14hz or 10 for external event)
epicsEnvSet("TSTAMPEVT", "14")

