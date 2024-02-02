########## FOR SMF ##########

# Create the project and directory structure
create_project sx_c2c_smf ./vivado/sx_c2c_smf -part xczu4eg-fbvb900-2-e

# Add various sources to the project
add_files -fileset constrs_1 ./srcs/constrs
add_files ./srcs/rtl

# Now import/copy the files into the project
import_files -force

# Create block diagram
source ./srcs/bd/bd_smf.tcl

# Generate wrapper file for block diagram
# make_wrapper -files [get_files ./vivado/camlink_dma_4panel/camlink_dma_4panel.srcs/sources_1/bd/camlink_dma_4panel/camlink_dma_4panel.bd] -top

# Set wrapper as top
# add_files -norecurse ./vivado/camlink_dma_4panel/camlink_dma_4panel.gen/sources_1/bd/camlink_dma_4panel/hdl/camlink_dma_4panel_wrapper.v
set_property top sx_c2c_smf_wrapper [current_fileset]



########## FOR HAPS-SX ##########
