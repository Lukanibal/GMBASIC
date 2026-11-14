//draw system background
draw_set_color(back_color);
draw_rectangle(0, 0, room_width, room_height, false);

if (!surface_exists(back_buffer))
{
    back_buffer = surface_create(800, 600);
}

surface_set_target(back_buffer);
draw_clear_alpha(c_black, 1);


var _graphics = objSystem.program.graphics;
var _len = array_length(_graphics);

for (var _i = 0; _i < _len; _i++)
{
    var _item = _graphics[_i];

    if (_item.kind == "LINE")
    {
        draw_line_color(_item.x1, _item.y1, _item.x2, _item.y2,
            graphics_color, graphics_color);
    }
    else if (_item.kind == "TRI")
    {
        draw_triangle_color(_item.x1, _item.y1, _item.x2, _item.y2,_item.x3, _item.y3, graphics_color, graphics_color, graphics_color, true);
    }
    else if (_item.kind == "FTRI")
    {
        draw_triangle_color(_item.x1, _item.y1, _item.x2, _item.y2,_item.x3, _item.y3, graphics_color, graphics_color, graphics_color, false);
    }
    else if (_item.kind == "RECT")
    {
        draw_rectangle_color(_item.x1, _item.y1, _item.x2, _item.y2,
            graphics_color, graphics_color, graphics_color, graphics_color, true);
    }
    else if (_item.kind == "CIRC")
    {
        draw_circle_color(_item.x1, _item.y1, _item.x2,
            graphics_color, graphics_color, true);
    }
    else if (_item.kind == "FCIRC")
    {
        draw_circle_color(_item.x1, _item.y1, _item.x2,
            graphics_color, graphics_color, false);
    }
    else if (_item.kind == "FRECT")
    {
        draw_rectangle_color(_item.x1, _item.y1, _item.x2, _item.y2,
            graphics_color, graphics_color, graphics_color, graphics_color, false);
    }
    else if (_item.kind == "SETDRAWCOLOR")
    {
        switch (_item.col)
        {
            case "RED":    graphics_color = c_red; break;
            case "BLUE":   graphics_color = c_blue; break;
            case "GREEN":  graphics_color = c_green; break;
            case "LIME":   graphics_color = c_lime; break;
            case "MAROON": graphics_color = c_maroon; break;
            case "AQUA":   graphics_color = c_aqua; break;
            case "ORANGE": graphics_color = c_orange; break;
            case "WHITE":  graphics_color = c_white; break;
            case "BLACK":  graphics_color = c_black; break;
            case "PURPLE": graphics_color = c_purple; break;
            case "YELLOW": graphics_color = c_yellow; break;
        }
    }
}

surface_reset_target();
draw_surface(back_buffer, 10, 10);


///draw text
draw_set_halign(fa_left);
draw_set_color(text_color);
var _display_string = "";
var _num = 0;
for(var _i = 1; _i <= string_length(program.output); _i++)
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

var _display_text = typed_text;
if(on)
{
    _display_text = string_insert(cursor, _display_text, position);
}

draw_text(10, room_height - 36, ">"+_display_text);

var _pane_left = row_length + 20;
var _pane_top = 10;
var _pane_width = room_width - _pane_left;
var _pane_height = 600; // pane runs from y=10 to y=610

//draw_text_ext(string_width(_display_string), 10, "TOKENS:"+string(program.tokens_to_string()), 36, room_width-string_width(_display_string));
//draw_text_ext(row_length+20, 10 + program_scroll_y, program.text, 24, room_width - (row_length+20));
var _scissor = gpu_get_scissor();
gpu_set_scissor(_pane_left, _pane_top, _pane_width, _pane_height);


draw_text_ext( _pane_left, _pane_top - program_scroll_y, program.text, 24, _pane_width);

gpu_set_scissor(_scissor);



if (program.waiting_for_input)
{
    draw_text(10, 610, "INPUT " + program.input_var + ":");
    draw_text(10, 634, program.input_text + "_");
}
draw_text(10, room_height - 72, $"MOUSEX:{mouse_x}, MOUSEY:{mouse_y}");
draw_set_halign(fa_right);

draw_line_width_colour(row_length+15, 0, row_length+15, 610, 4, text_color, text_color);
draw_line_width_colour(0, 610, row_length+15, 610, 4, text_color, text_color);

draw_text_ext(room_width - 10, room_height - 36, "VARIABLES:"+string(program.variables), 36, room_width-36);
draw_set_halign(fa_left);



