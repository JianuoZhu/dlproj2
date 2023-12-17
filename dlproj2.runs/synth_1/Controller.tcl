# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_param synth.incrementalSynthesisCache C:/Users/Jianuo_Zhu/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-37692-JianuoLegion/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir E:/OneDrive/Code/FPGA/dlproj2/dlproj2.cache/wt [current_project]
set_property parent.project_path E:/OneDrive/Code/FPGA/dlproj2/dlproj2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo e:/OneDrive/Code/FPGA/dlproj2/dlproj2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  E:/OneDrive/Code/FPGA/dlproj2/DigitalDesignProject.srcs/sources_1/new/Buzzer.v
  E:/OneDrive/Code/FPGA/dlproj2/DigitalDesignProject.srcs/sources_1/new/debounce.v
  E:/OneDrive/Code/FPGA/dlproj2/DigitalDesignProject.srcs/sources_1/new/Controller.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/OneDrive/Code/FPGA/dlproj2/DigitalDesignProject.srcs/constrs_1/new/try.xdc
set_property used_in_implementation false [get_files E:/OneDrive/Code/FPGA/dlproj2/DigitalDesignProject.srcs/constrs_1/new/try.xdc]


synth_design -top Controller -part xc7a35tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Controller.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Controller_utilization_synth.rpt -pb Controller_utilization_synth.pb"
