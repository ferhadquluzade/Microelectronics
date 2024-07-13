# Bash script to execute. (tested environment: linux) 

# Execution options:
# 1. ./executer.sh
# 2. bash executer.sh
# 3. sh executer.sh 

ghdl -a --std=08 design.vhd
ghdl -a --std=08 testbench.vhd
ghdl -e --std=08 goertzel_filter
ghdl -r --std=08 goertzel_filter --wave=result.ghw
# gtkwave result.ghw
