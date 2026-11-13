draw_set_halign(fa_left);
if(!running && !viewing)
draw_text(10, 10, ">"+typed_text);
else 
{
    var _display_string = "";
    var _num = 0;
    for(var _i = 1; _i < string_length(program.output); _i++)
    {
        _display_string += string_char_at(program.output, _i);
        _num++;
        if(_num == 80)
        {
            _display_string += "\r\n";
            _num = 0;
        }
    }
    
    
    draw_text_ext(10, 10, _display_string, 24, room_width - 20);
}




draw_text_ext(10, room_height - 36, "VARIABLES:"+string(program.variables), 36, room_width-36);

draw_set_halign(fa_right);
draw_text(room_width-10, 10, program.text);

//draw_text_ext(room_width-10, room_height - 36, "TOKENS:"+string(program.tokens), 36, room_width-36);
