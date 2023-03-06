module SPI_Protocal( input wire sclk                                      ,
                     input wire reset                                     ,
                     input wire mosi                                      , // master out slave in constraint_mode
                     input wire slave_select                              , // slave selection port
                     input [7:0] data_in                                  , // data to store in shift register
                     
                     output  miso                                         , // master out slave in port
                     output reg [7:0] data_out                            , // to show the updated shift register
                     output reg shift_done                                  //  aknowledgement to show that shift is done
                   )                                                      ;
                   
reg [7:0] slave_shift_register                                            ;
reg mosi_internal_reg                                                     ;

reg miso_internal_reg                                                     ;
reg [7:0] internal_data_out                                               ;

reg [3:0] counter                                                         ;

integer i = 0                                                             ;

assign miso     = miso_internal_reg                                       ;

always @(posedge sclk) begin
    if(reset == 1'b1) begin
        data_out             <= 8'b0                                      ;
        shift_done           <= 1'b0                                      ;
        
        slave_shift_register <= 8'b0                                      ;  
        mosi_internal_reg    <= 1'b0                                      ;
        miso_internal_reg    <= 1'b0                                      ;
        internal_data_out    <= 8'b0                                      ;
        counter              <= 4'b0                                      ;
          
    end   
    else begin // reset == 1'b0 condition             
        if(slave_select == 1'b1) begin
            slave_shift_register <= data_in                               ; 
                                       
        end //slave_select == 1'b0 condition
        else begin
            mosi_internal_reg     <= mosi                                 ; // reading a bit from matser
            if(i == 0) begin
                miso_internal_reg <= slave_shift_register[7]              ; // sending out MSB
               internal_data_out  <= {slave_shift_register[6:0],mosi}     ; // shifted
               i = i + 1                                                  ;   
               counter = counter + 4'b1                                   ;                                   
            end
            else begin
                miso_internal_reg <= internal_data_out[7]                ;
                internal_data_out <= {internal_data_out[6:0],mosi}        ; 
                counter           <= counter + 4'b1                       ;
                if(counter == 4'b1000) begin
                    data_out      <= internal_data_out                    ;
                    shift_done    <= 1'b1                                 ;
                    counter       <= 4'b0                                 ;
                end
                else begin
                    counter       <= counter + 4'b1                       ;
                end
            end 
       end
   end
end
endmodule