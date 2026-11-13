draw_set_color(c_dkgray);
draw_rectangle(x, y, x + string_width_ext(text, 24, room_width), y + string_height_ext(text, 24, room_height), false);

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text_ext(x, y, text, 24, room_width);