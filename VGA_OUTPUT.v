// VGA_OUTPUT
// 	MODULE TO CONVERT RGB VALUE TO DISPLAY OUTPUT
// VERSION: 1.0.0
// LAST UPDATED: MAR 11, 2026
// AUTHOR: DOMENIC CHAO
module VGA_OUTPUT (
	input clk25,				// 25MHZ CLOCK
	input [7:0] colorR,		// RED COLOR INPUT
	input [7:0] colorG,		//	GREEN COLOR INPUT
	input [7:0] colorB,		// BLUE COLOR INPUT
	
	input rst,					// RESET INPUT
	
	output reg [7:0] vgaR, 	// VGA RED COLOR OUTPUT (0-255)
	output reg [7:0] vgaG,	// VGA GREEN COLOR OUTPUT (0-255)
	output reg [7:0] vgaB,	// VGA BLUE COLOR OUTPUT (0-255)
	output vgaHSYNC,			// VGA HORIZONTAL SYNC OUTPUT 
	output vgaVSYNC,			// VGA VERTICAL SYNC OUTPUT	
);

	// VARIABLES FOR HEIGHT AND WIDTH
   localparam H_ACTIVE = 640;
   localparam V_ACTIVE = 480;
	
   localparam H_FRONT_P = 16;
	localparam V_FRONT_P = 10;
	
	localparam H_SYNC = 96;
	localparam V_SYNC = 2;
	
	localparam H_BACK_P = 48;
	localparam V_BACK_P = 33;
	
	localparam H_TOTAL = H_ACTIVE + H_FRONT_P + H_SYNC + H_BACK_P;
   localparam V_TOTAL = V_ACTIVE + V_FRONT_P + V_SYNC + V_BACK_P;
	
	// TEMPORARY HEIGHT AND WIDTH VARIABLE
	reg [11:0] Hpos = 0;
	reg [11:0] Vpos = 0;
	wire videoActive;

	// UPDATING THE VERTICAL AND HORIZONTAL POSITION
	always @(posedge clk25) begin
		if (rst) begin
			Hpos <= 0;
			Vpos <= 0;
		end else	if (Hpos < H_TOTAL - 1) begin
			// UPDATING HORIZONTAL POSITION
			Hpos <= Hpos + 1;
		end else begin
			Hpos <= 0;
			// UPDATING VERTICAL POSITION
			if (Vpos < V_TOTAL - 1) begin
				Vpos <= Vpos + 1;
			end else begin
				Vpos <= 0;
			end
		end
	end
	
	// HORIZONTAL SYNCING
	assign vgaHSYNC = rst ? 1'b1 :  ~((Hpos >= (H_ACTIVE + H_FRONT_P) && Hpos < (H_ACTIVE + H_FRONT_P + H_SYNC)));
		
	// VERTICAL SYNCING
	assign vgaVSYNC = rst ? 1'b1 : ~((Vpos >= (V_ACTIVE + V_FRONT_P) && Vpos < (V_ACTIVE + V_FRONT_P + V_SYNC)));
		
	assign videoActive = (Hpos < H_ACTIVE) && (Vpos < V_ACTIVE);
	
	assign vgaBlankN = videoActive;
	
	// COLOR LOGIC
	always @(posedge clk25) begin
		
		// ADDING COLOR
		if (videoActive) begin
			vgaR <= colorR;
			vgaG <= colorG;
			vgaB <= colorB;
		end else begin
			vgaR <= 0;
			vgaG <= 0;
			vgaB <= 0;
		end
	end	
endmodule
