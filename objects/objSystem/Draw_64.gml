draw_set_halign(fa_left);
if(!running)
draw_text(10, 10, ">"+typed_text);
else 
draw_text(10, 10, program.output);

draw_text_ext(10, room_height - 36, "VARIABLES:"+string(program.variables), 36, room_width-36);

draw_set_halign(fa_right);
draw_text(room_width-10, 10, program.text);

//draw_text_ext(room_width-10, room_height - 36, "TOKENS:"+string(program.tokens), 36, room_width-36);
