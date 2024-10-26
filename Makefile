SETUP_SCRIPT = /home/eda/snps_setup
RTL_SRC = ../../src/rtl/sha_algo_wrapper.sv
TB_SRC = ../../src/UVM/testbench.sv
FILELIST = ../../src/rtl/filelist_UVM.f
SIMV = simv
all: clean run

clean:
	rm -r csrc
	rm -r simv.daidir
	rm simv
	rm tr_db.log
	rm vc_hdrs.h
	rm waveforms.vcd
	rm .inter.vpd.uvm
	rm ucli.key
	rm -r DVEfiles
	rm inter.vpd
	rm compile.log
	rm cm.log
	rm -r sha256.vdb
compile: 
	. $(SETUP_SCRIPT) && vcs -sverilog -kdb -ntb_opts uvm-1.2 -l compile.log -timescale=1ps/1ps -full64 -debug_all -cm line+cond+fsm+tgl+branch+assert -cm_dir sha256.vdb -f $(FILELIST) -R $(RTL_SRC) $(TB_SRC)

cvg:
	dve -full64 -covdir ./*.vdb
simulate: $(SIMV)
	./$(SIMV) -gui -ucli
run: compile simulate

help: 
	@echo "********************************************************"
	@echo "******      make all: to clean and run            ******"
	@echo "******      make clean: to clean simulate files   ******"
	@echo "******      make cvg: report coverage             ******"
	@echo "******      make run: to compile & simulate       ******"
	@echo "***********Use run if every already cleaned*************"