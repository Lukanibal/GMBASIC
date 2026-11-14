global.debug = new SCRIPT();

global.debug.add_line("10 LET A = 6");
global.debug.add_line("20 LET B = 7");
global.debug.add_line("30 LET C = 0");
global.debug.add_line("40 IF B = 0 THEN GOTO 80 ELSE GOTO 50");
global.debug.add_line("50 LET C = C + A");
global.debug.add_line("60 LET B = B - 1");
global.debug.add_line("70 GOTO 40");
global.debug.add_line("80 PRINT C");
global.debug.add_line("90 END");