COMP	         = gnu

DIM              = 2

PRECISION        = DOUBLE

USE_MPI          = TRUE
USE_OMP          = FALSE

DEBUG            = FALSE

PROFILE          = FALSE


USE_RAD = TRUE
USE_NEUTRINO = FALSE

USE_GRAV         = TRUE
USE_REACT        = FALSE
USE_MODELPARSER = TRUE

CASTRO_HOME = ../../..

ifdef MICROPHYSICS_HOME

#This sets the EOS directory in $(MICROPHYSICS_HOME)/eos
EOS_dir     := gamma_law_general

# This sets the network directory in $(MICROPHYSICS_HOME)/networks
Network_dir := general_null
NETWORK_INPUTS := ./planet.net

else

$(error Error: This problem requires the Microphysics repository. Please ensure that you have downloaded it and set $$MICROPHYSICS_HOME appropriately)

endif


# power-law opacity
Opacity_dir := null

Bpack   := ./Make.package
Blocs   := .

include $(CASTRO_HOME)/Exec/Make.Castro
