########## FOR SMF ##########

# Create the project and directory structure
create_project sx_c2c_smf ./vivado/sx_c2c_smf -part xczu4eg-fbvb900-2-e

# Add various sources to the project
add_files -fileset constrs_1 ./srcs/smf/constrs
add_files ./srcs/smf/rtl

# Now import/copy the files into the project
import_files -force

# Create block diagram
source ./srcs/smf/bd/bd_smf.tcl

# Generate wrapper file for block diagram
make_wrapper -files [get_files ./vivado/sx_c2c_smf/sx_c2c_smf.srcs/sources_1/bd/sx_c2c_smf/sx_c2c_smf.bd] -top

# Set wrapper as top
add_files -norecurse ./vivado/sx_c2c_smf/sx_c2c_smf.gen/sources_1/bd/sx_c2c_smf/hdl/sx_c2c_smf_wrapper.v
set_property top sx_c2c_smf_wrapper [current_fileset]



########## FOR HAPS-SX ##########

# Create the project and directory structure
create_project sx_c2c_haps ./vivado/sx_c2c_haps -part xcvu19p-fsva3824-2-e

# Add various sources to the project
add_files -fileset constrs_1 ./srcs/haps/constrs
add_files ./srcs/haps/rtl

# Now import/copy the files into the project
import_files -force

# Create block diagram
source ./srcs/haps/bd/bd_haps.tcl

# Generate wrapper file for block diagram
make_wrapper -files [get_files ./vivado/sx_c2c_haps/sx_c2c_haps.srcs/sources_1/bd/sx_c2c_haps/sx_c2c_haps.bd] -top

# Set wrapper as top
add_files -norecurse ./vivado/sx_c2c_haps/sx_c2c_haps.gen/sources_1/bd/sx_c2c_haps/hdl/sx_c2c_haps_wrapper.v
set_property top sx_c2c_haps_wrapper [current_fileset]
