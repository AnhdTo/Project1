-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.
  
  -- intermediate signals
  signal s_RegRead      : std_logic_vector(N-1 downto 0); -- Output of Register file, Read Data 1.
  signal s_RegRead2     : std_logic_vector(N-1 downto 0); -- Output of Register file, Read Data 2.
  signal s_SignExtImm   : std_logic_vector(N-1 downto 0); -- Output of the extender.
  signal s_ALUOpr2      : std_logic_vector(N-1 downto 0); -- Output of ALUSrc_select; Second operand of ALU.
  
  -- Output signals of ALU
  signal s_C          : std_logic; -- Carry out
  signal s_Z          : std_logic; -- Zero
  signal s_Ovf        : std_logic; -- Overflow
  signal s_ALUOp      : std_logic_vector(3 downto 0);
  signal s_MemtoReg, s_RegDst, s_ALUSrc, s_dontcare, s_Jump , s_pcShift2   : std_logic; 
  signal s_NextAddr     : std_logic_vector(N-1 downto 0);
  signal  s_PCplusfour     : std_logic_vector(31 downto 0);
  
	component mem is
		generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
		port(
			clk          : in std_logic;
			addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
			data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
			we           : in std_logic := '1';
			q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;
    component add_sub is
	   generic(N : integer := 32);
  port(A	    : in std_logic_vector(N-1 downto 0);
       B	    : in std_logic_vector(N-1 downto 0);
       nAdd_Sub	    : in std_logic;
       Overflow     : out std_logic;
       Zero	    : out std_logic;
       Carry	    : out std_logic;
       Result	    : out std_logic_vector(N-1 downto 0));
end component;

    component shift32
	generic(N : integer := 32);
	port(dataIn              : in std_logic_vector(N-1 downto 0);
       AorL                : in std_logic; --0 = Logical, 1 = Arithmetic
       dir		   : in std_logic; --0 = left, 1 = right
       sel	           : in std_logic_vector(4 downto 0);
       output          	   : out std_logic_vector(N-1 downto 0));
	end component;
	  
	  
	component ALU
	  port(A	    : in std_logic_vector(31 downto 0);
		   B	    : in std_logic_vector(31 downto 0);
		   ALUOP	    : in std_logic_vector(3 downto 0);
		   Carry	    : out std_logic;
		   Zero	    : out std_logic;
		   Overflow	    : out std_logic;
		   Result	    : out std_logic_vector(31 downto 0));
	end component;
    
	component mux2to1
	 port(i_A          : in std_logic;
       i_B	    : in std_logic;
       i_X	    : in std_logic;
       o_Y          : out std_logic);
	 end component;
	 
	 
	component extender
	  port(
		   i_s     : in std_logic; -- always sign extend instead of 0 extend
		   i_16    : in std_logic_vector(15 downto 0);
		   o_32    : out std_logic_vector(31 downto 0));
	end component;

	component register_file
	  port(i_CLK        : in std_logic;     -- Clock input
		   i_RST        : in std_logic;     -- Reset input
		   i_E          : in std_logic;     -- Write Enable
		   i_RS         : in std_logic_vector(4 downto 0);      -- Read Data select 1
		   i_RT         : in std_logic_vector(4 downto 0);      -- Read Data select 2
		   i_WE         : in std_logic_vector(4 downto 0);      -- Write Data select
		   i_WD         : in std_logic_vector(31 downto 0);     -- Write Data value
		   o_REG        : out std_logic_vector(31 downto 0); 
		   o_RS         : out std_logic_vector(31 downto 0);   -- Data value output
		   o_RT         : out std_logic_vector(31 downto 0));  -- Data value output
	end component;

	component mux2_1_structural
	  port(i_A  : in std_logic_vector(31 downto 0);
		   i_B  : in std_logic_vector(31 downto 0);
		   i_S  : in std_logic;
		   o_F : out std_logic_vector(31 downto 0));
	end component;
	
	component controlUnit
	  port(opcode			: in std_logic_vector(5 downto 0); --Instr[31-26]
			 Funct			: in std_logic_vector(5 downto 0); --Instr[5-0]
			 ALUSrc			: out std_logic;
			 ALUControl     : out std_logic_vector(3 downto 0); 
			 MemtoReg		: out std_logic;
			 MemRd			: out std_logic;
			 DMemWr		    : out std_logic;
			 RegWr		    : out std_logic;
			 RegDst			: out std_logic);
	end component;

	component mux2to1_5bitD
	    port(i_A          : in std_logic_vector(4 downto 0);
		   i_B	    : in std_logic_vector(4 downto 0);
		   i_X	    : in std_logic;
		   o_Y          : out std_logic_vector(4 downto 0));

	end component;
	
	component controlled_adder_structural
		port(i_A  : in std_logic_vector(N-1 downto 0);
		   i_B  : in std_logic_vector(N-1 downto 0);
		   i_C  : in std_logic;  --nAdd_Sub 0: add, 1: sub
		   i_D  : in std_logic;  --ALUSrc 0: rt(i_B), 1: imm
		   i_Im : in std_logic_vector(N-1 downto 0);    --immediate integer
		   o_C  : out std_logic;
		   o_F  : out std_logic_vector(N-1 downto 0));
	   
	end component;
	
	component register_32bit
  
	  port(i_CLK    : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

	end component;


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  s_Halt <='1' when (s_Inst(31 downto 26) = "000000") and (s_Inst(5 downto 0) = "001100") and (v0 = "00000000000000000000000000001010") else '0';

  -- TODO: Implement the rest of your processor below this comment! 
  
  PC: register_32bit
	port map(i_CLK => iCLK,
		   i_RST => iRST,
		   i_WE => '1',
		   i_D => s_NextAddr,
		   o_Q => s_NextInstAddr);
 pcshift: shift32
	port(dataIn=>s_SignExtImm,              
       AorL =>'0',
       dir	=>'0',	 
       sel	=>"0010",         
       output => s_pcShift2);
	   
	   
  PC4: add_sub
	port map(A=>s_NextInstAddr,
       B =>"00000000000000000000000000000100",
       nAdd_Sub=>'0',
       Overflow=>s_dontcare,
       Zero=>s_dontcare,	    
       Carry=>s_dontcare,	   
       Result=>s_PCplusfour);

  Adder: controlled_adder_structural
	port map(i_A => s_NextInstAddr,
       i_B => x"00000000",
       i_C	=> '0',
       i_D  => '1',
       i_Im	 => x"00000004",
       o_C	=> s_dontcare,
       o_F	=> s_NextAddr);
  
  RegDst_select: mux2to1_5bitD
    port map(i_A => s_Inst(20 downto 16),
		   i_B => s_Inst(15 downto 11),
		   i_X => s_RegDst, --0: A; 1: B
		   o_Y => s_RegWrAddr);
  
  register_file_1: register_file
	port map(i_CLK => iCLK,
		   i_RST => iRST,
		   i_E => s_RegWr,
		   i_RS => s_Inst(25 downto 21),
		   i_RT => s_Inst(20 downto 16),
		   i_WE => s_RegWrAddr,
		   i_WD => s_RegWrData,
		   o_REG => v0,
		   o_RS => s_RegRead,
		   o_RT => s_DMemData);
		   
  extender_1: extender
	port map(i_s => '1',
		   i_16 => s_Inst(15 downto 0),
		   o_32 => s_SignExtImm);
		   
  control: controlUnit
	port map(opcode => s_Inst(31 downto 26), --Instr[31-26]
	     Funct => s_Inst(5 downto 0), --Instr[5-0]
		 ALUSrc	=> s_ALUSrc,
		 ALUControl => s_ALUOp,
		 MemtoReg => s_MemtoReg,
		 DMemWr	=> s_DMemWr,
		 RegWr => s_RegWr,
		 RegDst => s_RegDst;
		 jump => s_Jump);

  ALUSrc_select: mux2_1_structural
	port map(i_A => s_SignExtImm,
		   i_B => s_DMemData,
		   i_S => s_ALUSrc, --1: A; 0: B
		   o_F => s_ALUOpr2);
  jump_Mux: mux2to1
	port map(i_A =>s_pcShift2,
			 i_B =>s_PCplusfour,
			 i_X=>s_Jump,
			 o_Y=s_NextInstAddr);
	
  ALU1: ALU			   
	port map(A => s_RegRead,
		   B => s_ALUOpr2,
		   ALUOP => s_ALUOp,
		   Carry => s_C,
		   Zero	=> s_Z,
		   Overflow	=> s_Ovf,
		   Result => s_DMemAddr);
		   
	oALUOut <= s_DMemAddr;

  MemtoReg_select: mux2_1_structural
	port map(i_A => s_DMemOut,
		   i_B => s_DMemAddr,
		   i_S => s_MemtoReg, --1: A; 0: B
		   o_F => s_RegWrData);

end structure;
