class alu_transaction_object;
	
	rand bit [3:0] A,B;
	bit [7:0] dut_dout;
	bit [7:0] exp_dout;
	
	function void print(string tag="");
		 $display("[%s] A=%0h B=%0h EXP=%0h DUT=%0h",tag, A, B,exp_dout,dut_dout);
	endfunction
endclass

class alu_driver;

	virtual inf vif;
	mailbox drv_mbx;
	
	task run();		
		forever begin
			alu_transaction_object item;
			drv_mbx.get(item);
			item.print("Driver");
			
			@(posedge vif.clk);
			vif.A=item.A;
			vif.B=item.B;
		end
	 endtask
endclass

class alu_monitor;
	
	virtual inf vif;
	mailbox sco_mbx;
	
	task run();
		
		bit [3:0] a,b;
		
		forever begin
		@(posedge vif.clk);
		a=vif.A;
		b=vif.B;
		@(posedge vif.clk);
		alu_transaction_object item;
		item=new();
		item.A=a;
		item.B=b;
		item.dut_dout=vif.dout;
		
		sco_mbx.put(item);
		end
	endtask
endclass

class alu_scoreboard;
  mailbox sco_mbx;

  function new(mailbox mbx);
    sco_mbx = mbx;
  endfunction

  function automatic bit [7:0] alu_ref(
    bit [3:0] x,
    bit [3:0] y
  );
    alu_ref=x*y;
  endfunction

  task run();
    forever begin
      alu_transaction_object item;
      sco_mbx.get(item);

      item.exp_dout = alu_ref(item.A, item.B);

      if (item.dut_dout !== item.exp_dout) begin
        $error("Multiplier MISMATCH!");
        item.print("SCOREBOARD");
      end else begin
        $display("Multiplier PASS");
        item.print("SCOREBOARD");
      end
    end
  endtask
endclass


class environment;

	alu_driver d0;
	alu_monitor m0;
	alu_scoreboard s0;
	
	virtual inf vif;
	
	mailbox sco_mbx;
	mailbox drv_mbx;
	
	function new;
		d0=new;
		m0=new;
		sco_mbx=new();
		drv_mbx=new();
		s0=new(sco_mbx);
	endfunction
	
	task run();
		d0.vif=vif;
		m0.vif=vif;
		d0.drv_mbx = drv_mbx;
		m0.sco_mbx=sco_mbx;
		
		fork
			d0.run();
			m0.run();
			s0.run();
		join_none
	endtask
endclass
	
class alu_test;
	environment env;

  function new();
    env = new();
  endfunction

  task run();
    env.run();
    send_txn(4'h5, 4'h3); 
    send_txn(4'h5, 4'h3); 
    send_txn(4'hF, 4'hF); 

    repeat (20) begin
      alu_transaction_object item = new();
      assert(item.randomize());
      env.drv_mbx.put(item);
    end
  endtask

  task send_txn(bit [3:0] A, bit[3:0] B);
    alu_transaction_object item = new();
    item.A   = A;
    item.B   = B;
    env.drv_mbx.put(item);
  endtask
  
endclass

interface inf(input bit clk);
	logic [3:0] A,B;
	logic [7:0] dout;
endinterface

module tb;
	reg clk;
	
	
	always #10 clk=~clk;
	inf a1(clk);
	CLA_multiplier dut(
		.A(a1.A),
		.B(a1.B),
		.P(a1.dout)
	);
		
	initial begin
		clk=0;
		alu_test t0=new();
		t0.env.vif=a1;
		t0.run();
		#200 $finish;
	end
endmodule

		
	