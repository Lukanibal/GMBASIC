if(keyboard_check_pressed(vk_anykey))
{
    if(keyboard_lastkey == vk_backspace)
    {
        typed_text = string_delete(typed_text, string_length(typed_text), 1);
        keyboard_string = "";
        keyboard_lastkey = vk_nokey;
        running = false;
    }
    
    if(keyboard_lastkey == vk_escape && running)
    {
        typed_text = "";
        keyboard_string = "";
        keyboard_lastkey = vk_nokey;
        running = false;
        program.running := false;
        program.steps = 0;
    }
    
    if(keyboard_lastkey == vk_enter && typed_text != "")
    {
        //typed_text += "\r\n";
        if(typed_text == "RUN")
        {
            typed_text = "";
            running = true;
            program.tokens = tokenize(program);
            program.run(10);
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
            program.output = "";
        }
        else
        if(typed_text == "NEW")
        {
            typed_text = "";
            program = new SCRIPT();
            program.add_line("10 PRINT \"HELLO WORLD!\"");
            program.add_line("20 GOTO 10");
        }
        else
        if(typed_text == "SAVE")
        {
            typed_text = "";
            
            var _str = json_stringify(program);
            var _buff = buffer_create(8, buffer_grow, 1);
            buffer_write(_buff, buffer_string, _str);
            buffer_save(_buff,"PROGRAM.bas");
            buffer_delete(_buff);
        }
        else
        if(typed_text == "LOAD")
        {
            typed_text = "";
            
            var _buff = buffer_load("PROGRAM.bas");
            var _str = buffer_read(_buff, buffer_string);
            var _data := json_parse(_str);
            
            program = new SCRIPT();
            program.lines := _data.lines;
            program.tokens = _data.tokens;
            program.text = _data.text;
            
            buffer_delete(_buff);
            
        }
        else 
        {
        	program.add_line(typed_text);
            typed_text = "";
            keyboard_string = "";
            keyboard_lastkey = vk_nokey;
        }
        
    }
    
    if(keyboard_lastkey != vk_nokey)
    {
        typed_text += string_upper(keyboard_string);
        keyboard_string = "";
        keyboard_lastkey = vk_nokey;
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
    program.run(10);
}