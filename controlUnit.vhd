library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
entity controlUnit is
	port(opcode			: in std_logic_vector(5 downto 0); --Instr[31-26]
	     Funct			: in std_logic_vector(5 downto 0); --Instr[5-0]
		 ALUSrc			: out std_logic;
		 ALUControl     : out std_logic_vector(3 downto 0); 
		 MemtoReg		: out std_logic;
		 MemRd			: out std_logic;
		 DMemWr		    : out std_logic;
		 RegWr		    : out std_logic;
		 RegDst			: out std_logic;
		 jump  			: out std_logic;
		 beq			: out std_logic;
		 jumpR			: out std_logic;
		 SignExt 		: out std_logic;
		 UnsignIns      : out std_logic);
end controlUnit;
architecture dataflow of controlUnit is
begin 
	jump <='1' when ((opcode="000010") or ((opcode="000000") and Funct="001000")) else
			'0';
	with Funct select
		jumpR<='1' when "001000",		--signal for jr base on function code
			'0' when others;
	with opcode select						--signal for beq base on opcode
		beq<='1' when "000100",
			'0' when others;
	ALUSrc <='0' when (opcode="000000" or opcode="000100") else
			'1';
	with opcode select
		MemtoReg<='1' when "100011",
			'0' when others;
	with opcode select
		DMemWr<='1' when "101011",
			'0' when others;
	RegWr <='0' when ((opcode="101011") or (opcode="XXXXXX") or (Funct="001100") or (opcode="000010") or (Funct="001000") or (opcode="000100")) else
			'1';
	SignExt <= '0' when ((opcode="001100") or (opcode="001101")) else
			'1';
	UnsignIns <= '1' when (opcode="001001" or opcode="001011" or (opcode="000000" and (Funct="100001" or Funct="101011" or Funct="100011"))) else
			'0';
	with opcode select
		memRd<='1' when "100011",
			'0' when others;
	with opcode select
		RegDst<='1' when "000000", 
			'0' when others;
	ALUControl<="0001" when ((opcode="001000") or ((opcode="000000") and (Funct="100000" or Funct="100001")) or (opcode= "001001") or (opcode="100011") or (opcode="101011")) else
			    "-010" when ((opcode="000000" and Funct="100100") or opcode="001100") else
				"0110" when ((opcode="000000" and Funct="000000")) else
				"-101" when (opcode="000000" and Funct="100111") else
				"-100" when ((opcode="000000" and Funct="100110") or opcode="001110") else
				"-011" when ((opcode="000000" and Funct="100101") or opcode="001101") else
				"-000" when ((opcode="000000" and (Funct="101010" or Funct="101011")) or opcode="001010" or opcode="001011") else
				"0111" when (opcode="000000" and Funct="000010") else
				"1111" when (opcode="000000" and Funct="000011") else
				"1001" when ((opcode="000000" and (Funct="100011" or Funct="100010")) or opcode="000100")else
				"1110" when (opcode="001111") else
				"----";
end dataflow;