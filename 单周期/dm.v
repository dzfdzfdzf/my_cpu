`include "ctrl_encode_def.v"
// data memory
module dm(clk,
          DMWr,
          addr,
          DMType,
          din,
          dout);
    input          clk;
    input          DMWr;
    //input  [8:2]   addr;
    input  [8:0]   addr;
    input  [2:0]   DMType;
    input  [31:0]  din;
    output reg [31:0]  dout;
    reg [31:0] dmem[127:0];
    always @(posedge clk)
        if (DMWr) begin
            case(DMType)
                `dm_word:
                        case(addr[1:0])
                            2'b00:begin 
                            dmem[addr[8:2]] <= din;
                            $display("dmem[0x%8X] = 0x%8X,", addr[8:2] << 2, din);
                            end
                            2'b01:begin
                            dmem[addr[8:2]][31:8]<=din[23:0];
                            dmem[addr[8:2]+1][7:0]<=din[31:24];
                            $display("dmem[0x%8X] = 0x%8X,", addr[8:0], din);
                            end
                            2'b10:begin
                            dmem[addr[8:2]][31:16]<=din[15:0];
                            dmem[addr[8:2]+1][15:0]<=din[31:16];
                            $display("dmem[0x%8X] = 0x%8X,", addr[8:0], din);
                            end
                            2'b11:begin
                            dmem[addr[8:2]][31:24]<=din[7:0];
                            dmem[addr[8:2]+1][23:0]<=din[31:8];
                            $display("dmem[0x%8X] = 0x%8X,", addr[8:0], din);
                            end
                        endcase
                `dm_halfword:
                        case(addr[1:0])
                            2'b00:begin
                                dmem[addr[8:2]][15:0] <= din[15:0];
                                $display("dmem[0x%8X] = 0x%8X,", addr[8:0], din[15:0]);
                            end
                            2'b01:begin
                                dmem[addr[8:2]][23:8]<=din[15:0];
                                $display("dmem[0x%8X] = 0x%8X,", addr[8:0] , din[15:0]);
                            end
                            2'b10:begin
                                dmem[addr[8:2]][31:16]<=din[15:0];
                                $display("dmem[0x%8X] = 0x%8X,", addr[8:0],  din[15:0]);
                            end
                            2'b11:begin
                                dmem[addr[8:2]][31:24] <= din[7:0];
                                dmem[addr[8:2]+1][7:0]<=din[15:8];
                                $display("dmem[0x%8X] = 0x%8X,", addr[8:0],  din[15:0]);
                            end
                        endcase 
                `dm_byte:
                        case(addr[1:0])
                            2'b00:begin
                                dmem[addr[8:2]][7:0] <= din[7:0];
                                $display("dmem[0x%8X] = 0x%8X,", addr[8:0], din[7:0]);
                            end
                            2'b01:begin
                                dmem[addr[8:2]][15:8]<=din[7:0];
                                $display("dmem[0x%8X] = 0x%8X,", addr[8:0] , din[7:0]);
                            end
                            2'b10:begin
                                dmem[addr[8:2]][23:16]<=din[7:0];
                                $display("dmem[0x%8X] = 0x%8X,", addr[8:0],  din[7:0]);
                            end
                            2'b11:begin
                                dmem[addr[8:2]][31:24] <= din[7:0];
                                $display("dmem[0x%8X] = 0x%8X,", addr[8:0],  din[7:0]);
                            end
                        endcase 
            endcase
        end
  always @(*) begin
      case(DMType) 
          `dm_word:begin
                case(addr[1:0])
                    2'b00:
                        dout<=dmem[addr[8:2]];
                    2'b01:
                        dout<={dmem[addr[8:2]+1][7:0],dmem[addr[8:2]][31:8]};
                    2'b10:
                        dout<={dmem[addr[8:2]+1][15:0],dmem[addr[8:2]][31:16]};
                    2'b11:
                        dout<={dmem[addr[8:2]+1][23:0],dmem[addr[8:2]][31:24]};
                endcase
          end  
          `dm_halfword:begin
                case(addr[1:0])
                    2'b00:
                        dout<={{16{dmem[addr[8:2]][15]}},dmem[addr[8:2]][15:0]};
                    2'b01:
                        dout<={{16{dmem[addr[8:2]][23]}},dmem[addr[8:2]][23:8]};
                    2'b10:
                        dout<={{16{dmem[addr[8:2]][31]}},dmem[addr[8:2]][31:16]};
                    2'b11:
                        dout<={{16{dmem[addr[8:2]+1][7]}},dmem[addr[8:2]+1][7:0],dmem[addr[8:2]][31:24]};
                endcase
          end  
          `dm_halfword_unsigned:begin
                case(addr[1:0])
                    2'b00:
                        dout<={16'b0,dmem[addr[8:2]][15:0]};
                    2'b01:
                        dout<={16'b0,dmem[addr[8:2]][23:8]};
                    2'b10:
                        dout<={16'b0,dmem[addr[8:2]][31:16]};
                    2'b11:
                        dout<={16'b0,dmem[addr[8:2]+1][7:0],dmem[addr[8:2]][31:24]};
                endcase
          end  
          `dm_byte:begin
                case(addr[1:0])
                    2'b00:
                        dout<={{24{dmem[addr[8:2]][7]}},dmem[addr[8:2]][7:0]};
                    2'b01:
                        dout<={{24{dmem[addr[8:2]][15]}},dmem[addr[8:2]][15:8]};
                    2'b10:
                        dout<={{24{dmem[addr[8:2]][23]}},dmem[addr[8:2]][23:16]};
                    2'b11:
                        dout<={{24{dmem[addr[8:2]][31]}},dmem[addr[8:2]][31:24]};
                endcase
          end  
          `dm_byte_unsigned:begin
                case(addr[1:0])
                    2'b00:
                        dout<={24'b0,dmem[addr[8:2]][7:0]};
                    2'b01:
                        dout<={24'b0,dmem[addr[8:2]][15:8]};
                    2'b10:
                        dout<={24'b0,dmem[addr[8:2]][23:16]};
                    2'b11:
                        dout<={24'b0,dmem[addr[8:2]][31:24]};
                endcase
          end  
      endcase
  end
    //assign dout = dmem[addr[8:2]];
    
endmodule
