

if (program.waiting_for_input)
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
else
{
    if(keyboard_check(vk_anykey))
    {
        if (keyboard_lastkey == vk_backspace && can_delete)
        {
            if (position > 1 && string_length(typed_text) > 0)
            {
                typed_text = string_delete(typed_text, position - 1, 1);
                position--;
            }
            
            call_later(0.25, time_source_units_seconds, function()
            {
                can_delete = true;
            });
            can_delete = false;
        }
        
        if(keyboard_lastkey == vk_left)
       {
           if(position > 1)
           {
               position --;
           }
           call_later(0.35, time_source_units_seconds, function()
            {
                can_move = true;
            });
            can_move = false;
       }
       
       if(keyboard_lastkey == vk_right)
       {
           if(position <= string_length(typed_text))
           {
                position ++;
           }
           call_later(0.35, time_source_units_seconds, function()
            {
                can_move = true;
            });
            can_move = false;
       }
    }
    
    if(keyboard_check_pressed(vk_anykey))
   {
       
        
        if (keyboard_lastkey == vk_delete)
       {
            typed_text = "";
            position = 1;
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
       
       
       if(keyboard_lastkey == vk_enter && typed_text != "" && room == rmConsole)
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
                program.start();
                _handled = true;
           }
           if(typed_text == "STOP")
           {
                   typed_text = "";
                   position = 1;
                   running = false;
                   program.running = false;
                   program.steps = 0;
                   _handled = true;
            }
            if (string_pos("SPRITE ", typed_text) == 1)
            {
                var _rest = string_trim(string_delete(typed_text, 1, 7));
                var _space = string_pos(" ", _rest);
                var _name = _rest;
                var _frames = 1;
                
                if (_space > 0)
                {
                    _name = string_copy(_rest, 1, _space - 1);
                    var _digits = string_digits(string_delete(_rest, 1, _space));
                    if (_digits != "")
                    {
                        _frames = max(1, real(_digits));
                    }
                }
                
                _name = string_upper(_name);
                
                var _path = get_open_filename("PNG Images|*.png", "");
                
                if (_path == "")
                {
                    notify("SPRITE: NO FILE CHOSEN");
                }
                else
                {
                    var _spr = sprite_add(_path, _frames, false, false, 0, 0);
                    file_copy(_path, objSystem.project.name+$"/assets/sprites/{_name}_{_frames}.png");
                    if (_spr == -1)
                    {
                        notify("SPRITE: COULD NOT LOAD " + _path);
                    }
                    else
                    {
                        objSystem.sprites[$ _name] = _spr;
                        
                        objSystem.sprite_info[$ _name] = 
                        {
                            name:_name,
                            source_path: objSystem.project.name+$"/assets/sprites/{_name}_{_frames}.png",
                            frames: _frames
                        };
                        var _file  = file_text_open_write(objSystem.project.name+$"/assets/sprites/{_name}_{_frames}.json");
                        file_text_write_string(_file, json_stringify(objSystem.sprite_info[$ _name]));
                        file_text_close(_file);
                        
                        notify($"SPRITE {_name} ADDED TO PROJECT");
                    }
                }
                
                typed_text = "";
                position = 1;
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
            else if(typed_text == "HELP" || typed_text == "?")
            {
                typed_text = "";
                position = 1;
                var _options = "toolbar=0, location=0, menubar=0";
                
                url_open_full("https://lukanibal.github.io/GMBASIC", "_top", _options);
            }
           else
           if(string_count("NEW ", typed_text) > 0)
           {
                typed_text = "";
                position = 1; 
                var _n = string_replace(typed_text, "NEW ", ""); 
                project = new PROJECT(_n, string_upper(get_save_filename_ext("", "", working_directory, "Create a Project Directory")));
                program = new SCRIPT();
                program.add_line("10 PRINT \"HELLO WORLD!\"");
                program.add_line("20 GOTO 10");
                _handled = true;
           }
           else
           if(typed_text == "LOAD")
           {
                typed_text = "";
                position = 1; 
                load_project();
                _handled = true;
            }
            else
            if(typed_text == "COPY")
            {
                typed_text = "";
                position = 1; 
                clipboard_set_text(program.to_text());
                _handled = true;
            }
            else
            if(string_count("COPY ", typed_text))
            {
                var _num = string_replace(typed_text, "COPY ", "")
                var _len = array_length(program.lines);
                
                for(var _j = 0; _j < _len; _j++)
                {
                    if(get_line_number(program.lines[_j]) == _num)
                    {
                        typed_text = program.lines[_j];
                        clipboard_set_text(typed_text);
                        position = string_length(typed_text) + 1;
                        _handled = true;
                        break;
                    }
                }
                if(!_handled)
                notify("NOT FOUND OR INVALID LINE NUMBER TO COPY");
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
            if(typed_text == "BUILD")
           {
                typed_text = "";
                position = 1;
                compile();
                _handled = true;
            }
            else
            if(string_count("AUTO", typed_text) && !array_contains(global.function_names, string_letters(typed_text)))
           {
                
                var _end = real(string_digits(typed_text))
                for(var _j = 10; _j <= _end; _j += 10)
                {
                    program.add_line($"{_j}", false);
                }
                notify($"AUTOMATICALLY ADDED {_end} LINES, DESTRUCTIVELY")    
                typed_text = "";
                position = 1; 
                _handled = true;
            }
           else
           if(typed_text == "SAVE")
           {
                typed_text = "";
                position = 1;
                objSystem.project.to_file();
                _handled = true;
           }
           else
           if(string_count("TEXTCOLOR",typed_text) && !string_count("SETDRAWCOLOR",typed_text))
           {
                var _color = string_upper(string_replace(typed_text, "TEXTCOLOR ", ""));
                var _cols = struct_get_names(objSystem.RESERVED.WORDS)
                if(array_contains(_cols, _color))
                {
                    text_color = objSystem.RESERVED.WORDS[$ _color];
                }
                else 
                {
                	notify("EXPECTED A COLOR");
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
                var _color = string_upper(string_replace(typed_text, "BACKGROUND ", ""));
                var _cols = struct_get_names(objSystem.RESERVED.WORDS)
                if(array_contains(_cols, _color))
                {
                    back_color = objSystem.RESERVED.WORDS[$ _color];
                }
                else 
                {
                	notify("EXPECTED A COLOR");
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
                    typed_text = "";
                }
                else
                {
                    notify("MISSING LINE NUMBER");
                }
            
                position = 1;
            }
           
       }
       
       
       
       if(keyboard_lastkey != vk_nokey && keyboard_lastkey != vk_backspace)
       {
           var _typed = string_upper(keyboard_string);
           typed_text = string_insert(_typed, typed_text, position);
           position += string_length(_typed);
           keyboard_string = "";
           keyboard_lastkey = vk_nokey;
       }
       
   }
}

if(room == rmConsole)
{
   if(running)
   {
       window_set_caption("GMBASIC - RUNNING");
   }
   else if(viewing)
   {
       window_set_caption("GMBASIC - VIEWING PROGRAM OUTPUT");
   }
   else 
   {
       window_set_caption("GMBASIC - EDITING");
   }
}
///keep running!
if(program.running && program.steps <= 0 && objSystem.running)
{
    RESERVED = new SPECIAL();
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

/// //SCROLL ERRORS
if (mouse_x >= _pane_left && mouse_x <= room_width && mouse_y >= _pane_top && mouse_y <= _pane_top + _pane_height)
{
    if (mouse_wheel_up())
    {
        errors_scroll_y -= errors_scroll_speed;
    }
    else if (mouse_wheel_down())
    {
        errors_scroll_y += errors_scroll_speed;
    }
}
///clamp so this doesn't scroll off the dang screen
_content_height = 24 * array_length(program.errors);
_max_scroll = max(0, _content_height - _pane_height);
errors_scroll_y = clamp(errors_scroll_y, 0, _max_scroll);

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


