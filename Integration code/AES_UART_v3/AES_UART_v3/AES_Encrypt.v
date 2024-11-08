module AES_Encrypt#(parameter N=128,parameter Nr=10,parameter Nk=4)(in,key,out, flag);
input [127:0] in;
input [N-1:0] key;
output [127:0] out;
wire [(128*(Nr+1))-1 :0] fullkeys;
wire [127:0] states [Nr+1:0] ;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
output reg flag;
keyExpansion #(Nk,Nr) ke (key,fullkeys);

addRoundKey addrk1 (in,states[0],fullkeys[((128*(Nr+1))-1)-:128]);
//wire p = 1'b0;
reg [3:0] out_ch = 4'b0;
genvar i;
generate
	
	for(i=1; i<Nr ;i=i+1)begin : loop
		encryptRound er(states[i-1],fullkeys[(((128*(Nr+1))-1)-128*i)-:128],states[i]);
		
		end
		subBytes sb(states[Nr-1],afterSubBytes);
		shiftRows sr(afterSubBytes,afterShiftRows);
		addRoundKey addrk2(afterShiftRows,states[Nr],fullkeys[127:0]);
//		assign p = 1'b1;
		
		assign out=states[Nr];
endgenerate
always @(out) begin    
    if (out_ch == 4'b0001) begin flag = 1'b1; end 
    else begin out_ch = out_ch + 1; flag = 1'b0; end
end
endmodule