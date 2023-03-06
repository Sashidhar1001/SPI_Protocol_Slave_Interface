module SPI_Protocal_TB()                       ;
reg sclk                                       ;
reg reset                                      ;
reg mosi                                       ; // master out slave in constraint_mode
reg slave_select                               ; // slave selection constraint_mode
reg [7:0] data_in                              ; // data to store in shift register
                     
wire miso                                      ; // master out slave in port
wire [7:0] data_out                            ; // to show the updated shift register
wire shift_done                                ; //  aknowledgement to show that shift is done
                                                  


reg [7:0] master_shift_register = 8'b10101101  ;

integer n                                     ;

SPI_Protocal test( .sclk(sclk)                ,
                   .reset(reset)              ,
                   .mosi(mosi)                ,
                   .slave_select(slave_select),
                   .miso(miso)                ,
                   .data_in(data_in)          ,
                   .data_out(data_out)        ,
                   .shift_done(shift_done)
                 )                            ;
initial sclk     <= 1'b1                      ;
always #5 sclk   <= ~sclk                     ;

initial begin
    reset        <= 1'b1                      ;
    n = 6;
    
    slave_select <= 1'b1                      ;
    data_in      <= 8'b0                      ;
    
    repeat(2) begin  
    @(posedge sclk)                           ;
    end
    
    reset        <= 1'b0                      ;
    mosi         <= master_shift_register[7]  ;
    slave_select <= 1'b1                      ;
    data_in      <= 8'b11001110               ;
    
    repeat(1) begin
    @(posedge sclk)                           ;
    end
    
    slave_select <= 1'b0                      ;
    
    repeat(7) @ (posedge sclk) begin
        mosi   <= master_shift_register[n]    ;
        n = n - 1                             ;
    end
    repeat(2) begin
    @(posedge sclk)                           ;
    end
    slave_select <= 1'b1                      ;  
end
endmodule