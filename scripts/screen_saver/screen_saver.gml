global.screen_saver = new SCRIPT();

global.screen_saver.add_line("10 LET A = 0");
global.screen_saver.add_line("20 IF A = 0 THEN GOTO 100 ELSE GOTO 30");
global.screen_saver.add_line("30 IF A = 1 THEN GOTO 110 ELSE GOTO 40");
global.screen_saver.add_line("40 IF A = 2 THEN GOTO 120 ELSE GOTO 50");
global.screen_saver.add_line("50 IF A = 3 THEN GOTO 130 ELSE GOTO 60");
global.screen_saver.add_line("60 IF A = 4 THEN GOTO 140 ELSE GOTO 70");
global.screen_saver.add_line("70 IF A = 5 THEN GOTO 150 ELSE GOTO 20");

global.screen_saver.add_line("100 PRINT \" . \"");
global.screen_saver.add_line("101 LET A = 1");
global.screen_saver.add_line("102 GOTO 20");

global.screen_saver.add_line("110 PRINT \" o \"");
global.screen_saver.add_line("111 LET A = 2");
global.screen_saver.add_line("112 GOTO 20");

global.screen_saver.add_line("120 PRINT \" O \"");
global.screen_saver.add_line("121 LET A = 3");
global.screen_saver.add_line("122 GOTO 20");

global.screen_saver.add_line("130 PRINT \" @ \"");
global.screen_saver.add_line("131 LET A = 4");
global.screen_saver.add_line("132 GOTO 20");

global.screen_saver.add_line("140 PRINT \" O \"");
global.screen_saver.add_line("141 LET A = 5");
global.screen_saver.add_line("142 GOTO 20");

global.screen_saver.add_line("150 PRINT \" o \"");
global.screen_saver.add_line("151 LET A = 0");
global.screen_saver.add_line("152 GOTO 20");
