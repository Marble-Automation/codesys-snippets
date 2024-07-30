//START HEADER

VAR
	load:						UDINT;
	cpuReadPulse:				TON;
	cpuStringValue:				STRING(3);
	result:						RTS_IEC_RESULT;

END_VAR



//END HEADER


(*
The command to get just the CPU: top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}'
The command should be encoded which results in: top -bn1 | grep "Cpu(s)" | awk $'{print $$2 + $$4}$'
Links: 
	- https://www.ascii-code.com/ISO-8859-1
	- https://help.codesys.com/api-content/2/codesys/3.5.12.0/en/_cds_operands_constant_string/
NB: If you get Error 25, there is an access issue, which you can fix by: 
	- https://forge.codesys.com/forge/talk/Engineering/thread/64904fac37/
	(
		[SysProcess]
		Command=AllowAll
		in /etc/CODESYSControl.cfg 
*)

cpuReadPulse(IN:=TRUE, PT:=T#5S);
IF(cpuReadPulse.Q) THEN
	cpuReadPulse(IN:=FALSE);
SysProcess.SysProcessExecuteCommand2( 	pszCommand:='top -bn1 | grep "Cpu(s)" | awk $'{print $$2 + $$4}$'',
											pszStdOut:=cpuStringValue,
											udiStdOutLen:=SIZEOF(cpuStringValue),
											pResult:=ADR(result));
	IF(result = Errors.ERR_OK) THEN
		cpuLoad:=STRING_TO_BYTE(cpuStringValue);
	END_IF
	
END_IF


