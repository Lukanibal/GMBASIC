

if (program.waiting_for_input)
{
    if (program.input_mode == "KEY")
    {
        var _key = "";

        if (keyboard_check_pressed(vk_left))       _key = "LEFT";
        else if (keyboard_check_pressed(vk_right)) _key = "RIGHT";
        else if (keyboard_check_pressed(vk_up))    _key = "UP";
        else if (keyboard_check_pressed(vk_down))  _key = "DOWN";
        else if (keyboard_check_pressed(vk_space))  _key = "SPACE";
        else if (mouse_check_button_pressed(mb_left))  _key = "LEFT_CLICK";
        else if (mouse_check_button_pressed(mb_right))  _key = "RIGHT_CLICK";

        if (_key != "")
        {
            program.variables[$ program.input_var] = _key;

            program.waiting_for_input = false;
            program.running = true;
            program.input_var = "";
            program.input_mode = "";
            program.steps = 0;
        }
    }
    else
    {
        program.input_text = string_upper(keyboard_string);

        if (keyboard_check_pressed(vk_enter))
        {
            program.variables[$ program.input_var] = program.input_text;

            program.waiting_for_input = false;
            program.running = true;
            program.input_var = "";
            program.input_mode = "";
            program.input_text = "";
            keyboard_string = "";
            program.steps = 0;
        }
    }
}
else
{
    if(keyboard_check_pressed(vk_anykey))
   {
       if (keyboard_lastkey == vk_backspace)
       {
           if (position > 1 && string_length(typed_text) > 0)
           {
                typed_text = string_delete(typed_text, position - 1, 1);
                position--;
           }
       
            keyboard_string = "";
            keyboard_lastkey = vk_nokey;
       }
   
       
       if(keyboard_lastkey == vk_escape && running)
       {
            typed_text = "";
            keyboard_string = "";
            keyboard_lastkey = vk_nokey;
            running = false;
            program.running := false;
            program.steps = 0;
            position = 1;
       }
       
       
       if(keyboard_lastkey == vk_left)
       {
           if(position > 1)
           {
               position --;
           }
           keyboard_lastkey = vk_nokey;
           keyboard_string = "";
       }
       
       if(keyboard_lastkey == vk_right)
       {
           if(position <= string_length(typed_text))
           {
                position ++;
           }
           keyboard_lastkey = vk_nokey;
           keyboard_string = "";
       }
       
       
       if(keyboard_lastkey == vk_enter && typed_text != "")
       {
           var _handled = false;

            if (string_copy(typed_text, 1, 4) == "DEL ")
            {
                var _line_num = real(string_delete(typed_text, 1, 4));
                program.remove_line(_line_num);
                typed_text = "";
                position = 1;
                _handled = true;
            }
           
           if(typed_text == "RUN")
           {
                typed_text = "";
                position = 1;
                running = true;
                program.tokens = tokenize(program);
                program.run(10);
                _handled = true;
           }
           else
           if(typed_text == "RESTART")
           {
                game_restart();
           }
           else
           if(typed_text == "CLS")
           {
                 notify("CLEARED PROGRAM OUTPUT");
                 typed_text = "";
                 position = 1;
                 program.output = "";
                _handled = true;
           }
           else
           if(typed_text == "NEW")
           {
                typed_text = "";
                position = 1; 
                program = new SCRIPT();
                program.add_line("10 PRINT \"HELLO WORLD!\"");
                program.add_line("20 GOTO 10");
                _handled = true;
           }
           else
           if(typed_text == "FLOAD")
           {
                typed_text = "";
                position = 1; 
                upload_basic();
                _handled = true;
            }
            else
           if(typed_text == "PASTE")
           {
                typed_text = "";
                position = 1; 
                load_basic_from_clipboard();
                _handled = true;
            }
           else
           if(typed_text == "FSAVE")
           {
                typed_text = "";
                position = 1;
            
            
                var _name = get_save_filename("BASIC Program|*.bas;*.BAS;*.txt", "");
                var _file = file_text_open_write($"{_name}.BAS");
                var _len = array_length(program.lines);
                var _i = 0;
                while(_i < _len)
                {
                    file_text_write_string(_file, program.lines[_i]);
                    file_text_writeln(_file);
                    _i++
                }
            
                file_text_close(_file);
                _handled = true;
           }
           if(typed_text == "SAVE")
           {
                typed_text = "";
                position = 1;
             
                var _str = json_stringify(program);
                var _buff = buffer_create(8, buffer_grow, 1);
                buffer_write(_buff, buffer_string, _str);
                buffer_save(_buff,"PROGRAM.bas");
                buffer_delete(_buff);
                _handled = true;
           }
           else
           if(typed_text == "LOAD")
           {
                 typed_text = "";
                 position = 1;
                 
                 var _buff = buffer_load("PROGRAM.bas");
                 var _str = buffer_read(_buff, buffer_string);
                 var _data := json_parse(_str);
                 
                 program = new SCRIPT();
                 program.lines := _data.lines;
                 program.tokens = _data.tokens;
                 //program.text = _data.text;
                 
                 buffer_delete(_buff);
                _handled = true;
               
           }
           if(string_count("COLOR",typed_text) && !string_count("SETDRAWCOLOR",typed_text))
           {
                var _color = string_replace(typed_text, "COLOR ", "");
                switch(_color)
                {
                    case "WHITE":
                    {
                        text_color = c_white;
                        break;
                    }
                        
                    case "LIME":
                    {
                        text_color = c_lime;
                        break;
                    }
                        
                    case "GREEN":
                    {
                        text_color = c_green;
                        break;
                    }
                     
                    case "BLUE":
                    {
                        text_color = c_blue;
                        break;
                    }  
                        
                    case "AQUA":
                    {
                        text_color = c_aqua;
                        break;
                    }
                     
                    case "RED":
                    {
                        text_color = c_red;
                        break;
                    }
                        
                    case "MAROON":
                    {
                        text_color = c_maroon;
                        break;
                    }
                     
                    case "PURPLE":
                    {
                        text_color = c_purple;
                        break;
                    }
                        
                    case "YELLOW":
                    {
                        text_color = c_yellow;
                        break;
                    }
                     
                    case "ORANGE":
                    {
                        text_color = c_orange;
                        break;
                    }
                        
                    case "BLACK":
                    {
                        text_color = c_black;
                        break;
                    } 
                            
                    default:
                    {
                        notify("COLOR NOT RECOGNIZED!");
                        break;
                    }
                }
                typed_text = "";
                position = 1;
                ini_open("prefs.ini");
                ini_write_real("SETTINGS", "TEXT", text_color);
                ini_close();
                _handled = true;
            }
            else if(string_count("BACKGROUND",typed_text))
            {
                var _color = string_replace(typed_text, "BACKGROUND ", "");
                switch(_color)
                {
                    case "WHITE":
                    {
                        back_color = c_white;
                        break;
                    }
                        
                    case "LIME":
                    {
                        back_color = c_lime;
                        break;
                    }
                        
                    case "GREEN":
                    {
                        back_color = c_green;
                        break;
                    }
                     
                    case "BLUE":
                    {
                        back_color = c_blue;
                        break;
                    }  
                        
                    case "AQUA":
                    {
                        back_color = c_aqua;
                        break;
                    }
                     
                    case "RED":
                    {
                        back_color = c_red;
                        break;
                    }
                        
                    case "MAROON":
                    {
                        back_color = c_maroon;
                        break;
                    }
                     
                    case "PURPLE":
                    {
                        back_color = c_purple;
                        break;
                    }
                        
                    case "YELLOW":
                    {
                        back_color = c_yellow;
                        break;
                    }
                     
                    case "ORANGE":
                    {
                        back_color = c_orange;
                        break;
                    }
                        
                    case "BLACK":
                    {
                        back_color = c_black;
                        break;
                    }  
                            
                    default:
                    {
                        notify("COLOR NOT RECOGNIZED!");
                        break;
                    }
                }
                 typed_text = "";
                 ini_open("prefs.ini");
                 ini_write_real("SETTINGS", "BACK", back_color);
                 ini_close();
                _handled = true;
           }
           else 
           if (!_handled)
            {
                if (is_digit(string_char_at(typed_text, 1)))
                {
                    program.add_line(typed_text);
                }
                else
                {
                    notify("MISSING LINE NUMBER");
                }
            
                typed_text = "";
                position = 1;
            }
           
       }
       
       
       
       if(keyboard_lastkey != vk_nokey)
       {
           var _typed = string_upper(keyboard_string);
           typed_text = string_insert(_typed, typed_text, position);
           position += string_length(_typed);
           keyboard_string = "";
           keyboard_lastkey = vk_nokey;
       }
       
   }
}

if(running)
{
    window_set_caption("BASIC - RUNNING");
}
else if(viewing)
{
    window_set_caption("BASIC - VIEWING PROGRAM OUTPUT");
}
else 
{
    window_set_caption("BASIC - EDITING");
}

///keep running!
if(program.running && program.steps <= 0 && objSystem.running)
{
    program.run();
}

///scroll program
var _pane_left = row_length + 20;
var _pane_top = 10;
var _pane_width = room_width - _pane_left;
var _pane_height = 600; 


if (mouse_x >= _pane_left && mouse_x <= room_width && mouse_y >= _pane_top && mouse_y <= _pane_top + _pane_height)
{
    if (mouse_wheel_up())
    {
        program_scroll_y -= program_scroll_speed;
    }
    else if (mouse_wheel_down())
    {
        program_scroll_y += program_scroll_speed;
    }
}
///clamp so this doesn't scroll off the dang screen
var _content_height = 24 * array_length(program.lines);
var _max_scroll = max(0, _content_height - _pane_height);
program_scroll_y = clamp(program_scroll_y, 0, _max_scroll);

/// Scroll variables
_pane_left = row_length + 20;
_pane_top = 615;
_pane_width = window_get_width() - _pane_left;
_pane_height = window_get_height() - _pane_top;
var _line_h = 24;

if (mouse_x >= _pane_left &&  mouse_x <= _pane_left + _pane_width &&  mouse_y >= _pane_top &&  mouse_y <= _pane_top + _pane_height)
{
    if (mouse_wheel_up())
    {
        variables_scroll_y -= variables_scroll_speed;
    }
    else if (mouse_wheel_down())
    {
        variables_scroll_y += variables_scroll_speed;
    }
}
///clamp so this doesn't scroll off the dang screen too
var _variable_count = array_length(variable_struct_get_names(program.variables));
var _visible_height = max(0, _pane_height - _line_h);
_content_height = _variable_count * _line_h;
_max_scroll = max(0, _content_height - _visible_height);
variables_scroll_y = clamp(variables_scroll_y, 0, _max_scroll);


if (program.running || program.waiting_for_input)
{
    if (program.current_line != last_highlight_line)
    {
        last_highlight_line = program.current_line;

        _pane_width = room_width - (row_length + 20);
        var _b = program_line_bounds(program.current_line, _pane_width);

        if (_b != undefined)
        {
            var _view_h = 600;
            if (_b.top < program_scroll_y || _b.top + _b.height > program_scroll_y + _view_h)
            {
                program_scroll_y = max(0, _b.top - _view_h / 2 + _b.height / 2);
            }
        }
    }
}
else
{
    last_highlight_line = -1;
}


