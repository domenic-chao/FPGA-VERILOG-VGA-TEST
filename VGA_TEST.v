module VGA_TEST (
	input [7:0] color,					// SW[0-7]	[7: PIN_AD30; 6: PIN_AC28; 5: PIN_V25; 4: PIN_W25; 3: PIN_AC30; 2: PIN_AB28; 1: PIN_Y27; 0: PIN_AB30;]
	input confirm,							// SW[9]		PIN_AA30
	input switchInput,					// KEY[0]	PIN_AJ4
	input rstSw,							// SW[8]		PIN_AC29
	
	input clk50,							// CLOCK_50	PIN_AF14
	
	output [6:0] sevSegCurrL,			// HEX[5]	[6: PIN_AB21; 5: PIN_AF19; 4: PIN_AE19; 3: PIN_AG20; 2: PIN_AF20; 1: PIN_AG21; 0: PIN_AF21;]
	output [6:0] sevSegCurrC,			// HEX[4]	[6: PIN_AH22; 5: PIN_AF23; 4: PIN_AG23; 3: PIN_AE23; 2: PIN_AE22; 1: PIN_AG22; 0: PIN_AD21;]
	output [6:0] sevSegCurrR,			//	HEX[3] 	[6: PIN_AD20; 5: PIN_AA19; 4: PIN_AC20; 3: PIN_AA20; 2: PIN_AD19; 1: PIN_W19; 0: PIN_Y19;]
	output [6:0] sevSegNewL,			// HEX[2] 	[6: PIN_W16; 5: PIN_AF18; 4: PIN_Y18; 3: PIN_Y17; 2: PIN_AA18; 1: PIN_AB17; 0: PIN_AA21;]
	output [6:0] sevSegNewC,			// HEX[1]	[6: PIN_V17; 5: PIN_AE17; 4: PIN_AE18; 3: PIN_AD17; 2: PIN_AE16; 1: PIN_V16; 0: PIN_AF16;]
	output [6:0] sevSegNewR,			// HEX[0]	[6: PIN_AH18; 5: PIN_AG18; 4: PIN_AH17; 3: PIN_AG16; 2: PIN_AG17; 1: PIN_V18; 0: PIN_W17;]
		
	output [7:0] vgaR,					// VGA_R		[7: PIN_AJ26; 6: PIN_AG26; 5: PIN_AF26; 4: PIN_AH27; 3: PIN_AJ27; 2: PIN_AK27; 1: PIN_AK28; 0: PIN_AK29;]
	output [7:0] vgaG,					// VGA_G 	[7: PIN_AH23; 6: PIN_AK23; 5: PIN_AH24; 4: PIN_AJ24; 3: PIN_AK24; 2: PIN_AH25; 1: PIN_AJ25; 0: PIN_AK26;]
	output [7:0] vgaB,					// VGA_B		[7: PIN_AK16; 6: PIN_AJ16; 5: PIN_AJ17; 4: PIN_AH19; 3: PIN_AJ19; 2: PIN_AH20; 1: PIN_AJ20; 0: PIN_AJ21;]
	output vgaHSYNC,						//	VGA_HSYC	[PIN_AK19]
	output vgaVSYNC,						// VGA_VSYC	[PIN_AK18]
	output vga_clk							// VGA_CLK	[PIN_AK21]
);
	reg [2:0] selection = 0;
	reg [7:0] colorR = 0;
	reg [7:0] colorG = 0;
	reg [7:0] colorB = 0;
	reg [7:0] currentNumber = 0; 
	reg inputChanged = 1;
	reg clk25 = 0;
	reg prevSwitch;
	
	always @(posedge clk50) begin
		// CREATING 25MHZ CLOCK
		clk25 <= !clk25;
	end
	
	
	assign vga_clk = clk25;
	
	always @(posedge clk50) begin
		prevSwitch <= switchInput;
		
		if (prevSwitch == 1 && switchInput == 0) begin
			selection <= (selection + 1) % 3;
		end
		
		if (confirm == 1'b1) begin
			case (selection)
				0: colorR <= color;
				1: colorG <= color;
				2: colorB <= color;
			endcase
		end
		
		case (selection)
			0: currentNumber <= colorR;
			1: currentNumber <= colorG;
			2: currentNumber <= colorB;
		endcase
	end
	
	
	// CONVERING COLOR TO DISPALY
	VGA_OUTPUT display(
		.clk25(clk25),
		.colorR(colorR),
		.colorG(colorG),
		.colorB(colorB),
		.rst(rstSw),
		
		.vgaR(vgaR),
		.vgaG(vgaG),
		.vgaB(vgaB),
		.vgaHSYNC(vgaHSYNC),
		.vgaVSYNC(vgaVSYNC)
	);
	
	// CONVERTING THE THREE DIGIT NUMBER TO SEVEN SEGMENT
	NUM_TO_SEVSEG current (
		.number(currentNumber),
		.sevSegL(sevSegCurrL),
		.sevSegC(sevSegCurrC),
		.sevSegR(sevSegCurrR)
	);
	
	NUM_TO_SEVSEG new (
		.number(color),
		.sevSegL(sevSegNewL),
		.sevSegC(sevSegNewC),
		.sevSegR(sevSegNewR)
	);
endmodule
