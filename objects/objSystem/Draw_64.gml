//draw system background
draw_set_color(back_color);
draw_rectangle(0, 0, room_width, room_height, false);

if (!surface_exists(back_buffer))
{
    back_buffer = surface_create(800, 600);
}

var _old_world = matrix_get(matrix_world);
var _old_view = matrix_get(matrix_view);
var _old_proj = matrix_get(matrix_projection);

surface_set_target(back_buffer);
draw_clear_alpha(c_black, 1);

var _graphics = objSystem.program.graphics;
var _len = array_length(_graphics);

for (var _i = 0; _i < _len; _i++)
{
    var _item = _graphics[_i];
    
    if (_item.kind == "MATRIXSETWORLD")
    {
        matrix_set(matrix_world, _item.matrix);
    }
    if (_item.kind == "MATRIXSETPROJ")
    {
        matrix_set(matrix_projection, _item.matrix);
    }
    if (_item.kind == "MATRIXSETVIEW")
    {
        matrix_set(matrix_view, _item.matrix);
    }
    if (_item.kind == "LINE")
    {
        draw_line_color(_item.x1, _item.y1, _item.x2, _item.y2, graphics_color, graphics_color);
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
            case "FUCHSIA": graphics_color = c_fuchsia; break;
        }
    }
}

surface_reset_target();

matrix_set(matrix_world, _old_world);
matrix_set(matrix_view, _old_view);
matrix_set(matrix_projection, _old_proj);

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
var _pane_width = window_get_width() - _pane_left;
var _pane_height = window_get_height() - 168; 

var _scissor = gpu_get_scissor();

gpu_set_scissor(_pane_left, _pane_top, _pane_width, _pane_height);

var _b = program_line_bounds(program.current_line, _pane_width);
if (_b != undefined)
{
    var _hy = _pane_top - program_scroll_y + _b.top;
    draw_set_color(c_ltgray);
    draw_rectangle(_pane_left, _hy, _pane_left + _pane_width, _hy + _b.height, false);
    draw_set_color(text_color);
}
//draw_text_ext(_pane_left, _pane_top - program_scroll_y, program.text, 24, _pane_width);
var _line_count = array_length(program.lines);
var _line_h = 24;
var _first_line = max(0, floor(program_scroll_y / _line_h));
var _last_line = min(_line_count - 1, ceil((program_scroll_y + _pane_height) / _line_h));

for (var _i = _first_line; _i <= _last_line; _i++)
{
    var _y = _pane_top + (_i * _line_h) - program_scroll_y;
    
    if (_i == program.current_line)
    {
        draw_set_color(c_ltgray);
        draw_rectangle( _pane_left, _y, _pane_left + _pane_width, _y + _line_h, false );
    }
    
    draw_set_color(text_color);
    draw_text(_pane_left, _y, program.lines[_i]);
}



gpu_set_scissor(_scissor);
draw_line_width_colour(row_length+15, 0, row_length+15, window_get_height(), 4, text_color, text_color);
draw_line_width_colour(0, 610, window_get_width(), 610, 4, text_color, text_color);

/*
_pane_left = row_length + 20;
_pane_top = 615;
_pane_width = window_get_width() - _pane_left;
_pane_height = window_get_height(); 


draw_text_ext(_pane_left, _pane_top, $"VARIABLES:{program.variables}", 24, _pane_width);
*/
_pane_left = row_length + 20;
_pane_top = 615;
_pane_width = window_get_width() - _pane_left;
_pane_height = window_get_height(); 

var _names = variable_struct_get_names(program.variables);
var _count = array_length(_names);

// program.variables_scroll_y is the pane's scroll position in pixels.
var _first = max(0, floor(variables_scroll_y / _line_h));
var _last = min(_count - 1, ceil((variables_scroll_y + _pane_height) / _line_h));

_scissor = gpu_get_scissor();
gpu_set_scissor(_pane_left, _pane_top, _pane_width, _pane_height);

draw_text(_pane_left, _pane_top, "VARIABLES:");

for (var _i = _first; _i <= _last; _i++)
{
    var _y = _pane_top + _line_h + (_i * _line_h) - variables_scroll_y;
    
    var _name = _names[_i];
    var _value = variable_struct_get(program.variables, _name);
    
    draw_text(_pane_left, _y, _name + ": " + string(_value));
}

gpu_set_scissor(_scissor);



