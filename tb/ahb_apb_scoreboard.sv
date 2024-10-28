class ahb_apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(ahb_apb_scoreboard)
  uvm_tlm_analysis_fifo#(ahb_xtn) ahb_fifo;
  uvm_tlm_analysis_fifo#(apb_xtn) apb_fifo;

    
  ahb_xtn ahb;
  apb_xtn apb;
  
  ahb_xtn ahb_cov_data;
  apb_xtn apb_cov_data;
  
  covergroup ahb_cg;
		option.per_instance = 1;

		//RST: coverpoint ahb_cov_data.hresetn;
		
		HSIZE: coverpoint ahb_cov_data.hsize {bins b2[] = {[0:2]} ;}//1,2,4 bytes of data
		
		HTRANS: coverpoint ahb_cov_data.htrans {bins trans[] = {[2:3]} ;}//NS and S
		
		//BURST: coverpoint ahb_cov_data.Hburst {bins burst[] = {[0:7]} ;}
		
		HADDR: coverpoint ahb_cov_data.haddr {bins first_slave = {[32'h8000_0000:32'h8000_03ff]};
						                     bins second_slave = {[32'h8400_0000:32'h8400_03ff]};
                                             bins third_slave = {[32'h8800_0000:32'h8800_03ff]};
                                             bins fourth_slave = {[32'h8C00_0000:32'h8C00_03ff]};}

		DATA_IN: coverpoint ahb_cov_data.hwdata {
                                                 bins data_in = {[32'h0000_0000:32'hffff_ffff]};}

        DATA_OUT : coverpoint ahb_cov_data.hrdata {
                                                   bins data_out = {[32'h0000_0000:32'hffff_ffff]};
												   }
		HWRITE : coverpoint ahb_cov_data.hwrite;

		SIZEXWRITE: cross HWRITE,HSIZE;
		
   endgroup
   
   	covergroup apb_cg;
		option.per_instance = 1;
		
		PADDR : coverpoint apb_cov_data.paddr {bins first_slave = {[32'h8000_0000:32'h8000_03ff]};
                                               bins second_slave = {[32'h8400_0000:32'h8400_03ff]};
                                               bins third_slave = {[32'h8800_0000:32'h8800_03ff]};
                                               bins fourth_slave = {[32'h8C00_0000:32'h8C00_03ff]};}
				
		DATA_IN : coverpoint apb_cov_data.pwdata {
                                                          bins data_in = {[32'h0000_0000:32'hffff_ffff]};}

                DATA_OUT : coverpoint apb_cov_data.prdata {bins data_out = {[0:32'hffff_ffff]};}

                PWRITE : coverpoint apb_cov_data.pwrite;

                PSEL : coverpoint apb_cov_data.pselx {bins first_slave = {4'b0001,4'b0010,4'b0100,4'b1000};}

		WRITEXSEL: cross PADDR,PSEL;
	endgroup
	
	function new (string name = "ahb_apb_scoreboard",uvm_component parent = null);
     		 super.new(name,parent);
		 // ahb_cov_data = new();
 	 //	apb_cov_data = new();
		  ahb_cg = new();
		  apb_cg = new();
 	 endfunction


	function void build_phase(uvm_phase phase );
	   super.build_phase(phase);
	   ahb_fifo = new("ahb_fifo",this);
	   apb_fifo = new("apb_fifo",this);
	endfunction
	
	task run_phase (uvm_phase phase);
	  super.run_phase(phase);
	  forever
	    begin
		  fork 
		    begin
    
			  ahb_fifo.get(ahb);
			  `uvm_info(get_type_name(),"AHB-MONITOR",UVM_NONE)
			  ahb.print();
			  ahb_cov_data = ahb;
			  ahb_cg.sample();
			end
			begin
			  apb_fifo.get(apb);
			  `uvm_info(get_type_name(),"APB-MONITOR",UVM_NONE)
			  apb.print();
			  apb_cov_data = apb;
			  apb_cg.sample();
			end
		  join
		  check_data(ahb,apb);
		end
	endtask
	
	task check_data(ahb_xtn ahb,apb_xtn apb);
	   if(ahb.hwrite)
	    begin
		  if(ahb.hsize == 3'b0)
		    begin
			   if(ahb.haddr[1:0] == 2'b00)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hwdata[7:0],apb.pwdata);
				  end
				else if(ahb.haddr[1:0] == 2'b01)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hwdata[15:8],apb.pwdata);
				  end
				else if(ahb.haddr[1:0] == 2'b10)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hwdata[23:16],apb.pwdata);
				  end
				else if(ahb.haddr[1:0] == 2'b11)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hwdata[31:24],apb.pwdata);
				  end
				  
			end
			
	      else if(ahb.hsize == 3'b01)
		    begin
			   if(ahb.haddr[1:0] == 2'b00)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hwdata[15:0],apb.pwdata);
				  end
				else if(ahb.haddr[1:0] == 2'b10)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hwdata[31:16],apb.pwdata);
				  end
				  
			end
	       else if(ahb.hsize == 3'b10)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hwdata,apb.pwdata);
				  end
				  
			
		end
		
	  else if(ahb.hwrite == 1'b0)
	    begin
		  if(ahb.hsize == 3'b0)
		    begin
			   if(ahb.haddr[1:0] == 2'b00)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hrdata,apb.prdata[7:0]);
				  end
				else if(ahb.haddr[1:0] == 2'b01)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hrdata,apb.prdata[15:8]);
				  end
				else if(ahb.haddr[1:0] == 2'b10)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hrdata,apb.prdata[23:16]);
				  end
				else if(ahb.haddr[1:0] == 2'b11)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hrdata,apb.prdata[31:24]);
				  end
				  
			end
			
	      else if(ahb.hsize == 3'b01)
		    begin
			   if(ahb.haddr[1:0] == 2'b00)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hrdata,apb.prdata[15:0]);
				  end
				else if(ahb.haddr[1:0] == 2'b10)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hrdata,apb.prdata[31:16]);
				  end
				  
			end
	       else if(ahb.hsize == 3'b10)
			      begin
				    compare_data(ahb.haddr,apb.paddr,ahb.hrdata,apb.prdata);
				  end
				  
			
		end
		
		

	endtask
	
	
	task compare_data(int haddr,paddr,hdata,pdata);
	  if(haddr == paddr)
	    begin
		 $display("-------------------------------------------------------------------------------------------------");
		   $display("ADDRESS MATCHING");
		   $display("AHB-Address = %0h,APB-Address = %0h",haddr,paddr);
		 $display("-------------------------------------------------------------------------------------------------");
		end
	  else
	    begin
		 $display("-------------------------------------------------------------------------------------------------");
	     $display("ADDRESS MISMATCH");
		 $display("-------------------------------------------------------------------------------------------------");
		end
		
	  if(hdata == pdata)
	    begin
		$display("--------------------------------------------------------------------------------------------------");
		  $display("DATA MATCH SUCCESSFUL");
		  $display("AHB-Data = %0h,APB-Data = %0h",hdata,pdata);
		$display("--------------------------------------------------------------------------------------------------");
		end
	  else 
	    begin
		$display("--------------------------------------------------------------------------------------------------");
	     $display("DATA MISMATCH");
		$display("--------------------------------------------------------------------------------------------------");
		end
	endtask	
	
endclass
