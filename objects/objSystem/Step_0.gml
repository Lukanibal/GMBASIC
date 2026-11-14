

if (program.waiting_for_input)
{
    program.input_text = string_upper(keyboard_string);

    if (keyboard_check_pressed(vk_enter))
    {
        program.variables[$ program.input_var] = program.input_text;

        program.waiting_for_input = false;
        program.running = true;
        program.input_var = "";
        program.input_text = "";
        keyboard_string = "";
        program.steps = 0
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
           if(typed_text == "UPLOAD")
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
                 program.text = _data.text;
                 
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

if(program.running && program.steps <= 0 && objSystem.running)
{
    program.run(120);
}

var _pane_left = row_length + 20;
var _pane_top = 10;
var _pane_width = room_width - _pane_left;
var _pane_height = 600; // pane runs from y=10 to y=610

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

var _content_height = string_height_ext( program.text, 24,  _pane_width);

var _max_scroll = max(0, _content_height - _pane_height);
program_scroll_y = clamp(program_scroll_y, 0, _max_scroll);
