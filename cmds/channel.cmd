###############################################################################
# ifc1400 digitizer channel

# C = analog input channel index for AD 0 .. 9
# N = analog input channel index for DB 1 .. 10
# ACQ_SAMPLES = maximum number of samples

# controls for analog input channel
dbLoadRecords("ifc1410fcNcharge.template",   "P=$(ACQ_PREFIX),R=$(N)-,PORT=$(ACQ_PORT),ADDR=$(C),TIMEOUT=1,NAME=Channel $(N)")

#
# COMMON CHAIN
#
# Provide converted input channel signal for other chains.
#
# plugin diagram
#
# | CHx | --> | PROC1 |

# process : Converting input signal
# chain   : common
# ports   : CHx.PROC1, CHx.PROC1.TIFF
# plugin  : NDPluginProcess, NDFileTIFF
# purpose : Convert analog input (raw) sample value (ADC counts) into engineering
#           units; depending on the application (V, mV, A, mA..). Setup conversion
#           scale factor to desired value. Leave offset at 0 (see below).
#           Subtracts background from input signal. This is done on raw (ADC) sample
#           values. Afterwards, ADC offset is in the middle of input range.
#           Background value (ADC noise) can be loaded from previously stored
#           TIFF image and applied on demand.
#           Converts to float data type.
NDProcessConfigure("CH$(C).PROC1", $(QSIZE), 0, "$(ACQ_PORT)", $(C), 0, 0)
dbLoadRecords("ifc1400Process.template",    "P=$(ACQ_PREFIX),R=$(N)-PR1-,PORT=CH$(C).PROC1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(ACQ_PORT),NDARRAY_ADDR=$(C),ENABLED=1")
# Create a TIFF file plugin to read digital noise traces into the processing plugin
NDFileTIFFConfigure("CH$(C).PROC1.TIFF", $(QSIZE), 0, "$(ACQ_PORT)", $(C))
dbLoadRecords("NDFileTIFF.template",  "P=$(ACQ_PREFIX),R=$(N)-PR1-TF-,PORT=CH$(C).PROC1.TIFF,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(ACQ_PORT),NDARRAY_ADDR=$(C)")

#
# PULSE CHAIN
#
# Deliver complete pulse waveform, optionally decimated and averaged, for
# LCR monitoring. Source of the data is converted signal. Use case would
# be inspection of the complete pulse for figuring out ROI for flat top.
#
# plugin diagram
#
# | PROC1 | --> | ROI2 | --> | PROC2 | --> | MON2 |

# process : Input signal decimation (binning)
# chain   : pulse
# port    : CHx.ROI2
# plugin  : NDPluginROI
# purpose : Reduce X samples of input signal into single output sample by summing
#           X samples and dividing by X.
#           No ROI is applied for this instance.
#           Provide sample delta time at this decimation.
NDROIConfigure("CH$(C).ROI2", $(QSIZE), 0, "CH$(C).PROC1", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("ifc1400ROI.template",        "P=$(ACQ_PREFIX),R=$(N)-RI2-, PORT=CH$(C).ROI2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=CH$(C).PROC1,NDARRAY_ADDR=0,ENABLED=1")

# process : Averaging signal waveforms over time
# chain   : pulse
# port    : CHx.PROC2
# plugin  : NDPluginProcess
# purpose : Reduce X waveforms of input signal into single output waveform by applying
#           an averaging filter.
#           No additional processing is performed.
NDProcessConfigure("CH$(C).PROC2", $(QSIZE), 0, "CH$(C).ROI2", 0, 0, 0)
dbLoadRecords("ifc1400Process.template",    "P=$(ACQ_PREFIX),R=$(N)-PR2-,PORT=CH$(C).PROC2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=CH$(C).ROI2,NDARRAY_ADDR=0,ENABLED=1")

# process : Waveform for clients
# chain   : pulse
# port    : CHx.MON2
# plugin  : NDPluginStdArrays
# purpose : Provide CA clients with waveform as shaped by this chain.
#           No additional processing is performed.
NDTraceConfigure("CH$(C).MON2", 3, 0, "CH$(C).PROC2", 0)
dbLoadRecords("NDTrace.template",  "P=$(ACQ_PREFIX),R=$(N)-TR2-,PORT=CH$(C).MON2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=CH$(C).PROC2,NDARRAY_ADDR=0,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=$(ACQ_SAMPLES),TIME_LINK=$(ACQ_PREFIX)$(N)-RI2-TickValueR CP,NAME=CH$(C) pulse LCR,ENABLED=1")


#
# FLATTOP CHAIN
#
# Deliver pulse flat top waveform, optionally decimated and averaged, for
# LCR monitoring. Source of the data is converted signal. Use case would
# be inspection of the applied ROI and source of data for flat top statistics
# calculation chain.
# Essentially the same as pulse chain when it comes to used plugins.
#
# plugin diagram
#
# | PROC1 | --> | ROI3 | --> | PROC3 | --> | MON3 |
#

# process : Input signal decimation (binning) and ROI
# chain   : flattop
# port    : CHx.ROI3
# plugin  : NDPluginROI
# purpose : Reduce X samples of input signal into single output sample by summing
#           X samples and dividing by X. Can follow pulse binning settings, but not
#           it is not mandatory (appearance of the pulse vs. flat top waveforms may differ).
#           ROI is applied for this instance, as set up by the user. It should be
#           applied to only encompas flat top samples; used later for statistics
#           including charge.
#           Provide sample delta time at this decimation.
NDROIConfigure("CH$(C).ROI3", $(QSIZE), 0, "CH$(C).PROC1", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("ifc1400ROI.template",        "P=$(ACQ_PREFIX),R=$(N)-RI3-, PORT=CH$(C).ROI3,ADDR=0,TIMEOUT=1,NDARRAY_PORT=CH$(C).PROC1,NDARRAY_ADDR=0,ENABLED=1")

# process : Averaging signal waveforms over time
# chain   : pulse
# port    : CHx.PROC3
# plugin  : NDPluginProcess
# purpose : Reduce X waveforms of input signal into single output waveform by applying
#           an averaging filter.
#           No additional processing is performed.
NDProcessConfigure("CH$(C).PROC3", $(QSIZE), 0, "CH$(C).ROI3", 0, 0, 0)
dbLoadRecords("ifc1400Process.template",    "P=$(ACQ_PREFIX),R=$(N)-PR3-,PORT=CH$(C).PROC3,ADDR=0,TIMEOUT=1,NDARRAY_PORT=CH$(C).ROI3,NDARRAY_ADDR=0,ENABLED=1")

# process : Waveform for clients
# chain   : pulse
# port    : CHx.MON3
# plugin  : NDPluginStdArrays
# purpose : Provide CA clients with waveform as shaped by this chain.
#           No additional processing is performed.
NDTraceConfigure("CH$(C).MON3", 3, 0, "CH$(C).PROC3", 0)
dbLoadRecords("NDTrace.template",  "P=$(ACQ_PREFIX),R=$(N)-TR3-,PORT=CH$(C).MON3,ADDR=0,TIMEOUT=1,NDARRAY_PORT=CH$(C).PROC3,NDARRAY_ADDR=0,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=$(ACQ_SAMPLES),TIME_LINK=$(ACQ_PREFIX)$(N)-RI3-TickValueR CP,NAME=CH$(C) flat top LCR,ENABLED=1")


#
# FTSTATS CHAIN
#
# Deliver pulse flat top statistics, optionally averaged, as scalars and as
# time series waveforms for LCR monitoring.
#
# plugin diagram
#
# | PROC3 | --> | STAT3 | --> | STAT3.TS |
#

# process : Waveform statistics for clients
# chain   : pulse
# ports   : CHx.STAT3, CHx.STAT3.TS
# plugins : NDPluginStats, NDPluginTimeSeries
# purpose : Provide CA clients with waveform statistics as shaped by this chain.
#           Generate time series of the calculated statistics and provide them as waveforms.
#           No additional processing is performed.
NDStatsConfigure("CH$(C).STAT3", $(QSIZE), 0, "CH$(C).ROI3", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("ifc1400Stats.template",       "P=$(ACQ_PREFIX),R=$(N)-ST3-,  PORT=CH$(C).STAT3,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=CH$(C).ROI3,NDARRAY_ADDR=0,TS_PORT=CH$(C).STAT3.TS,ENABLED=1")
# statistics time series acquisition and waveform control
NDTimeSeriesConfigure("CH$(C).STAT3.TS", $(QSIZE), 0, "CH$(C).STAT3", 1, 23)
dbLoadRecords("NDTimeSeries.template",  "P=$(ACQ_PREFIX),R=$(N)-ST3-TS-,     PORT=CH$(C).STAT3.TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=CH$(C).STAT3,NDARRAY_ADDR=1,NCHANS=$(NCHANS),TIME_LINK=$(ACQ_PREFIX)$(N)-RI3-TickValueR CP,ENABLED=1")
# NOTE: individual time series waveform records for statistics are in NDStats.template

#
# DEBUG CHAIN
#
# Used for debugging purposes.
# Provide clients with waveforms from any point of any processing chain;
# defaults to raw input signal.
# Capture waveforms when certain 'interesting' condition is met. Used to capture
# pulses that may exceed certain threshold level (as setup by the user).
# Save "background" trace data in TIFF format for later background subtraction
# during processing.
#
# plugin diagram
#
# | any | --> | RAW |
# | any | --> | CB1 |
# | CHx | --> | TIFF1 |
#

# process : Waveform for clients
# chain   : debug
# port    : CHx.RAW
# plugin  : NDPluginStdArrays
# purpose : Provide CA clients with raw waveform.
#           No additional processing is performed.
#NDTraceConfigure("CH$(C).RAW", 3, 0, "$(ACQ_PORT)", $(C))
#dbLoadRecords("NDTrace.template",  "P=$(ACQ_PREFIX),R=$(N)-TR1-,PORT=CH$(C).RAW,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(ACQ_PORT),NDARRAY_ADDR=$(C),TYPE=Float64,FTVL=SHORT,NELEMENTS=$(ACQ_SAMPLES),TIME_LINK=$(ACQ_PREFIX)TickValueR CP,NAME=CH$(C) Raw,ENABLED=1")

# process : Circular buffer of waveforms for clients
# chain   : debug
# port    : CHx.CB1
# plugin  : NDPluginCircularBuff
# purpose : Provide CA clients with waveforms as captured by this chain according to the
#           set thresholds and condition sources (PVs).
#           No additional processing is performed.
#           PBI monitor for out of band waveforms at any point in any processing chain
#           Setup the asyn NDArray port and address at runtime.
NDCircularBuffConfigure("CH$(C).CB1", $(QSIZE), 0, "$(ACQ_PORT)", $(C), $(CBUFFS), 0)
dbLoadRecords("NDCircularBuff.template", "P=$(ACQ_PREFIX),R=$(N)-CB1-,     PORT=CH$(C).CB1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(ACQ_PORT),NDARRAY_ADDR=$(C)")

# Create a TIFF file saving plugin

# process : TIFF file saving for singnal data
# chain   : debug
# port    : CHx.TIFF1
# plugin  : NDFileTIFF
# purpose : Provide capturing and saving of raw waveforms used for background subtraction
#           later in the processing chain (PROC1).
#           Setup the asyn NDArray port and address at runtime.
NDFileTIFFConfigure("CH$(C).TIFF1", $(QSIZE), 0, "$(ACQ_PORT)", $(C))
dbLoadRecords("NDFileTIFF.template",  "P=$(ACQ_PREFIX),R=$(N)-TF1-,PORT=CH$(C).TIFF1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(ACQ_PORT),NDARRAY_ADDR=$(C)")
