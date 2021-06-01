`include "mux2x1.v"
`include "control.v"
`include "aluControl.v"
`include "shiftLeft.v"
`include "alu.v"
`include "clockDivider.v"
`include "progCounter.v"
`include "progMemory.v"
`include "aluADD.v"
`include "registers.v"
`include "dataMemory.v"

`include "forwardingUnit.v"
`include "hazardDetectionUnit.v"
`include "mux2x1Control.v"
`include "mux3x1.v"
`include "branchPrediction.v"
`include "pipeline_regs/ex_mem_register.v"
`include "pipeline_regs/id_ex_register.v"
`include "pipeline_regs/if_id_register.v"
`include "pipeline_regs/mem_wb_register.v"

module TP_03(	input systemClock,
				input reset);

	wire [63:0] pc_value, pc_plus_prediction, pc_new_value, pc_plus_immediate, ig_imm, imm_shifted;
	wire [63:0] if_id_pc_value;
	wire [63:0] id_ex_pc_value, id_ex_rd1, id_ex_rd2, id_ex_immediate;
	wire [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;
	wire [6:0] id_ex_funct7;
	wire [2:0] id_ex_funct3;
	wire id_ex_branch, id_ex_memRead, id_ex_memToReg, id_ex_memWrite, id_ex_aluSRC, id_ex_regWrite;
	wire [31:0] im_instruction, if_id_instruction;
	wire [63:0] rd1_reg, rd2_reg, wb_mux_value;

	wire branch, if_id_write, pc_write;
	wire ctrl_branch, ctrl_memRead, ctrl_memToReg, ctrl_memWrite, ctrl_aluSRC, ctrl_regWrite;
	wire mux_ctrl_branch, mux_ctrl_memRead, mux_ctrl_memToReg, mux_ctrl_memWrite, mux_ctrl_aluSRC, mux_ctrl_regWrite;
	wire [1:0] id_ex_aluOp, ctrl_aluOp, mux_ctrl_aluOp;

	wire [3:0] alu_ctrl;
	wire alu_zero;
	wire [63:0] alu_result;

	wire [63:0] mux_forward_rd1, mux_forward_rd2, mux_rd2;
	wire [1:0] forward_A, forward_B;

	wire [63:0] ex_mem_pc_plus_immediate, ex_mem_alu_result, ex_mem_rd2;
	wire [4:0] ex_mem_rd;
	wire ex_mem_memRead, ex_mem_memWrite, ex_mem_memToReg, ex_mem_branch, ex_mem_regWrite, ex_mem_zero;

	wire [63:0] dm_read_data;

	wire [63:0] mem_wb_read_data, mem_wb_alu_result;
	wire [4:0] mem_wb_rd;
	wire mem_wb_memToReg, mem_wb_regWrite;

	wire ctrlSelect;

	wire [63:0] ex_mem_pc_value;
	wire pred_prediction, if_id_prediction, id_ex_prediction, ex_mem_prediction;
	wire pred_flush;

	assign branch = ex_mem_zero & ex_mem_branch;
	
	progCounter 				PC(systemClock, reset, pc_write, pc_new_value, pc_value);
	progMemory 					PM(pc_value, im_instruction);
	if_id_register				if_id(systemClock, pc_value, im_instruction, pred_flush, if_id_write, pred_prediction, if_id_pc_value, if_id_instruction, if_id_prediction);

	registers 					regs(systemClock, mem_wb_regWrite, if_id_instruction[19:15], if_id_instruction[24:20], mem_wb_rd, wb_mux_value, rd1_reg, rd2_reg);
	immGenerator 				ig(if_id_instruction, ig_imm);
	control 					ctrl(if_id_instruction[6:0], ctrl_branch, ctrl_memRead, ctrl_memToReg, ctrl_aluOp, ctrl_memWrite, ctrl_aluSRC, ctrl_regWrite);
	mux2x1Control				mControl(ctrl_branch, ctrl_memRead, ctrl_memToReg, ctrl_memWrite, ctrl_aluOp, ctrl_aluSRC, ctrl_regWrite, ctrlSelect, mux_ctrl_branch, mux_ctrl_memRead, mux_ctrl_memToReg, mux_ctrl_aluOp, mux_ctrl_memWrite, mux_ctrl_aluSRC, mux_ctrl_regWrite);
	id_ex_register				id_ex(systemClock, if_id_pc_value, rd1_reg, rd2_reg, if_id_instruction[19:15], if_id_instruction[24:20], if_id_instruction[11:7], ig_imm, if_id_instruction[31:25], if_id_instruction[14:12], mux_ctrl_branch, mux_ctrl_memRead, mux_ctrl_memToReg, mux_ctrl_aluOp, mux_ctrl_memWrite, mux_ctrl_aluSRC, mux_ctrl_regWrite, pred_flush, if_id_prediction, id_ex_pc_value, id_ex_rd1, id_ex_rd2, id_ex_immediate, id_ex_funct7, id_ex_funct3, id_ex_rs1, id_ex_rs2, id_ex_rd, id_ex_branch, id_ex_memRead, id_ex_memToReg, id_ex_aluOp, id_ex_memWrite, id_ex_aluSRC, id_ex_regWrite, id_ex_prediction);


	shiftLeft 					sl(id_ex_immediate, imm_shifted);
	mux3x1						mux1(id_ex_rd1, wb_mux_value, ex_mem_alu_result, forward_A, mux_forward_rd1);
	mux3x1						mux2(id_ex_rd2, wb_mux_value, ex_mem_alu_result, forward_B, mux_forward_rd2);
	mux2x1 						aluMux(mux_forward_rd2, id_ex_immediate, id_ex_aluSRC, mux_rd2);
	aluControl 					aluCtrl(id_ex_aluOp, id_ex_funct7, id_ex_funct3, alu_ctrl);
	aluADD 						aluPcPlusImm(id_ex_pc_value, imm_shifted, pc_plus_immediate);
	alu 						aluMain(mux_forward_rd1, mux_rd2, alu_ctrl, alu_zero, alu_result);
	ex_mem_register				ex_mem(systemClock, id_ex_pc_value, pc_plus_immediate, alu_result, mux_forward_rd2, id_ex_rd, id_ex_memRead, id_ex_memWrite, id_ex_memToReg, id_ex_branch, id_ex_regWrite, alu_zero, pred_flush, id_ex_prediction, ex_mem_pc_value, ex_mem_pc_plus_immediate, ex_mem_alu_result, ex_mem_rd2, ex_mem_rd, ex_mem_memRead, ex_mem_memWrite, ex_mem_memToReg, ex_mem_branch, ex_mem_regWrite, ex_mem_zero, ex_mem_prediction);
	

	dataMemory 					DM(systemClock, ex_mem_memRead, ex_mem_memWrite, ex_mem_alu_result, ex_mem_rd2, dm_read_data);
	mem_wb_register				mem_wb(systemClock, ex_mem_alu_result, dm_read_data, ex_mem_rd, ex_mem_memToReg, ex_mem_regWrite, mem_wb_alu_result, mem_wb_read_data, mem_wb_rd, mem_wb_memToReg, mem_wb_regWrite);
	mux2x1 						wbMux(mem_wb_alu_result, mem_wb_read_data, mem_wb_memToReg, wb_mux_value);
	

	// visão alem do alcande de tudo
	forwardingUnit  			forwarding(id_ex_rs1, id_ex_rs2, ex_mem_rd, mem_wb_rd, ex_mem_regWrite, mem_wb_regWrite, forward_A, forward_B);
	hazardDetectionUnit			hazard(id_ex_memRead, id_ex_rd, if_id_instruction[19:15], if_id_instruction[24:20], pc_write, if_id_write, ctrlSelect);
	branchPrediction			pred(systemClock, ex_mem_branch, branch, ex_mem_prediction, pc_value, ex_mem_pc_value, ex_mem_pc_plus_immediate, im_instruction, pc_new_value, pred_prediction, pred_flush);

endmodule
