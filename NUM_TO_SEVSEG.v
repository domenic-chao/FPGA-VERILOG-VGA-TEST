// NUM_TO_SEVSEG
// 	MODULE TO CONVERT THREE DIGIT NUMBER TO SEVEN SEGMENT OUTPUT
// VERSION: 1.0.0
// LAST UPDATED: MAR 10, 2026
// AUTHOR: DOMENIC CHAO
module NUM_TO_SEVSEG(
	input [7:0] number, 		// THREE DIGIT NUMBER TO CONVERT TO SEVEN SEGMENT
	output [6:0] sevSegL,	// THE LEFT SEVEN SEGMENT DISPLAY (100S)
	output [6:0] sevSegC,	// THE CENTRE SEVEN SEGMENT DISPLAY (10S)
	output [6:0] sevSegR		// THE RIGHT SEVEN SEGMENT DISPLAY (1S)
);
	
	// TEMP VARIABLE FOR SINGLE DIGIT FOR ALL OF THESE DISPLAYS
	reg [3:0] number_L;
	reg [3:0] number_C;
	reg [3:0] number_R;
	
	
	// CONVERTING FROM 3 DIGIT TO THREE SINGLE DIGITS
	always @(*) begin
		number_R = number % 10;
		number_C = ((number % 100) - number_R)/10;
		number_L = (number - (number_C * 10) - number_R)/100;
	end
	
	// CONVERING ALL THE INDIVIDUAL DIGITS TO SEPERATE SEVENT SEGMENT OUTPUTS
	SEV_SEG_OUTPUT left (
		.number(number_L),
		.enable(1),
		.sevSeg(sevSegL)
	);
	
	SEV_SEG_OUTPUT center (
		.number(number_C),
		.enable(1),
		.sevSeg(sevSegC)
	);
	
	SEV_SEG_OUTPUT right (
		.number(number_R),
		.enable(1),
		.sevSeg(sevSegR)
	);
endmodule


// SEV_SEG_OUTPUT
// 	MODULE TO CONVERT SINGLE DIGIT NUMBER TO SEVEN SEGMENT OUTPUT
// VERSION: 1.0.0
// LAST UPDATED: MAR 10, 2026
// AUTHOR: DOMENIC CHAO
module SEV_SEG_OUTPUT (
	input [3:0] number, 			// ONE DIGIT NUMBER TO BE CONVERTED TO SEV_SEGMENT
	input enable,
	output reg [6:0] sevSeg		// SEVEN SEGMENT OUPUT
);
	// CASE TO CONVERT NUMBER TO SEVEN SEGENT OUTPUT
	always @(*) begin
		case(number)
			0: sevSeg = 7'b1000000;
			1: sevSeg = 7'b1111001;
			2: sevSeg = 7'b0100100;
			3: sevSeg = 7'b0110000;
			4: sevSeg = 7'b0011001;
			5: sevSeg = 7'b0010010;
			6: sevSeg = 7'b0000010;
			7: sevSeg = 7'b1111000;
			8: sevSeg = 7'b0000000;
			9: sevSeg = 7'b0011000;
			default: sevSeg = 7'b0000110;
		endcase
		
		if (!enable) begin
			sevSeg = 7'b1111111;
		end
	end
endmodule