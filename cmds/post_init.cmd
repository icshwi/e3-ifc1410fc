###############################################################################
# Initialization after iocBoot()

### acquisition configuration
# See dataAcquisition.cmd for macro substitutions used here.

## setup TIFF saving for channel 1 background
dbpf $(ACQ_PREFIX)1-TF1-FilePath "$(PWD)"
dbpf $(ACQ_PREFIX)1-TF1-FileName "channel1_bg"
dbpf $(ACQ_PREFIX)1-TF1-FileTemplate "%s%s.tiff"
## setup TIFF loading for channel 1 background
dbpf $(ACQ_PREFIX)1-PR1-TF-FilePath "$(PWD)"
dbpf $(ACQ_PREFIX)1-PR1-TF-FileName "channel1_bg"
dbpf $(ACQ_PREFIX)1-PR1-TF-FileTemplate "%s%s.tiff"
