###############################################################################
# SIS8300 digitizer

epicsEnvSet("ACQ_DEV",       "$(ACQ_DEVID)")
epicsEnvSet("ACQ_PREFIX",    "$(SYSTEM):$(ACQ_UNIT)-")
epicsEnvSet("ACQ_PORT",      "FC")
epicsEnvSet("XSIZE",         "$(ACQ_SAMPLES)")
epicsEnvSet("YSIZE",         "1")
epicsEnvSet("QSIZE",         "20")
epicsEnvSet("NCHANS",        "100")
epicsEnvSet("CBUFFS",        "500")
epicsEnvSet("MAX_THREADS",   "4")


# Create a IFC14xx driver
# ifc1400Configure(const char *portName, const int ifccard, const int numChannels,
#        int numSamples, int extraPorts, int maxBuffers, int maxMemory,
#        int priority, int stackSize)
ifc1400fcConfigure("$(ACQ_PORT)", $(ACQ_DEVID), 4, $(ACQ_SAMPLES), 0, 0)
dbLoadRecords("ifc1410fc.template",      "P=$(ACQ_PREFIX),R=,PORT=$(ACQ_PORT),ADDR=0,TIMEOUT=1,MAX_SAMPLES=$(ACQ_SAMPLES)")

iocshLoad("$(adifc14_DIR)/acq_channel.setup", "C=0, N=1")
iocshLoad("channel.cmd", "C=0, N=1")

# C = analog input channel index for AD 0 .. 9
# N = analog input channel index for DB 1 .. 10
#iocshLoad("$(adifc14_DIR)/acq_channel.setup", "C=1, N=2")
#iocshLoad("$(adifc14_DIR)/acq_channel.setup", "C=2, N=3")
#iocshLoad("$(adifc14_DIR)/acq_channel.setup", "C=3, N=4")
# C = analog input channel index for AD 0 .. 9
# N = analog input channel index for DB 1 .. 10

# asynSetTraceIOMask("$(ACQ_PORT)",0,2)
# asynSetTraceMask("$(ACQ_PORT)",0,255)
