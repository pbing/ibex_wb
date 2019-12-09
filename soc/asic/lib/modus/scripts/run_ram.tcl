set_db workdir ./work
set   WORKDIR [get_db workdir]

file delete -force $WORKDIR/tbdata      ;# Delete Test Database
file delete -force $WORKDIR/testresults ;# Delete Test Output Files/Logs


build_model -designsource ../../lib/modus/RAM16384X32.v

build_testmode -testmode FULLSCAN

report_test_structures -testmode FULLSCAN

verify_test_structures -testmode FULLSCAN

build_faultmodel -includedynamic no

create_logic_tests -experiment ram_atpg -testmode FULLSCAN

write_vectors -inexperiment ram_atpg -testmode FULLSCAN -language verilog_hw -scanformat serial

commit_tests -inexperiment ram_atpg -testmode FULLSCAN



#create_sequential_tests -experiment ram_seq_atpg -testmode FULLSCAN

#write_vectors -inexperiment ram_seq_atpg -testmode FULLSCAN -language verilog_hw -scanformat serial

prepare_fca_database -testmode FULLSCAN -fault_type static

exit
