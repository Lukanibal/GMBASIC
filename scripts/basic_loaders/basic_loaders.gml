function upload_basic()
{
    var _filename = get_open_filename("BASIC PROGRAM|*.bas;*.txt", ""); 
    var _file = file_text_open_read(_filename);
    
    objSystem.program = new SCRIPT();
    
    while(!file_text_eof(_file))
    {
        objSystem.program.add_line(file_text_read_string(_file));
        file_text_readln(_file);
    }
    
    file_text_close(_file);
}

function load_basic(_filename)
{
    var _file = file_text_open_read(_filename);
    
    objSystem.program = new SCRIPT();
    
    while(!file_text_eof(_file))
    {
        objSystem.program.add_line(file_text_read_string(_file));
        file_text_readln(_file);
    }
    
    file_text_close(_file);
}

function load_basic_from_string(_string)
{
    objSystem.program = new SCRIPT();

    var _line = "";
    var _len = string_length(_string);
    var _i = 1;

    while (_i <= _len)
    {
        var _ch = string_char_at(_string, _i);

        if (_ch == "\r" || _ch == "\n")
        {
            if (string_length(_line) > 0)
            {
                objSystem.program.add_line(_line);
                _line = "";
            }

            if (_ch == "\r" && _i < _len && string_char_at(_string, _i + 1) == "\n")
            {
                _i++;
            }
        }
        else
        {
            _line += _ch;
        }

        _i++;
    }

    if (string_length(_line) > 0)
    {
        objSystem.program.add_line(_line);
    }
}

function load_basic_from_clipboard()
{
    var _string = clipboard_get_text();
    load_basic_from_string(_string);
    show_debug_message("Clipboard length: " + string(string_length(_string)));
    show_debug_message(string_copy(_string, 1, 100));

}

