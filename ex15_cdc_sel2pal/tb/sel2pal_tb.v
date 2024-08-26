module tb;
reg clka  ; 
reg clkb  ; 
reg rst_n ; 
reg din   ; 
reg wra_n ; 
reg wrb   ; 
reg [7:0]db_out;

reg [3:0]cnt;

always@(posedge clka)begin
din <= #1 {$random}%2;
cnt <= #1 cnt+1;
end

always #5 clka = !clka;
always #10 clkb = !clkb;

always@(*)begin
if(cnt==0)
    wra_n=0;
else if(cnt==8)
    wra_n=1;
end

initial begin
clka  = 0;
clkb  = 0;
rst_n = 1;
cnt   = 1;

#10
rst_n = 0;

#20
rst_n = 1;

#2000
$finish;
end

sel2pal ser_pal_u(
    .clka(clka),
    .clkb(clkb),
    .rst_n(rst_n),
    .din(din),
    .wra_n(wra_n),
    .wrb(wrb),
    .db_out(db_out)

);
/* 

module sel2pal( //fast to slow 
    input clka    ,//fast
    input wra_n   ,
    input rst_n   ,
    input din     ,

    input clkb    ,//slow
    output wrb     ,
    output [7:0] db_out
);
*/
initial	begin
	    $fsdbDumpfile("tb.fsdb");	    
        $fsdbDumpvars;
end

endmodule
