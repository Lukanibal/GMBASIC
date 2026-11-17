function upload_basic()
{
    objSystem.program.loaded = false;
    var _filename = get_open_filename("BASIC PROGRAM|*.bas;*.txt", "");
    if (_filename == "") return;
    
    var _file = file_text_open_read(_filename);
    if (_file == -1)
    {
        notify("COULD NOT OPEN FILE");
        return;
    }
    
    var _by_num = {};
    var _nums = [];
    
    while (!file_text_eof(_file))
    {
        var _val = string_trim(file_text_read_string(_file));
        file_text_readln(_file);
        
        if (_val == "" || !is_digit(string_char_at(_val, 1))) continue;
        
        var _num = get_line_number(_val);
        var _key = string(_num);
        
        if (!variable_struct_exists(_by_num, _key))
        {
            array_push(_nums, _num);
        }
        _by_num[$ _key] = _val;
    }
    
    file_text_close(_file);
    array_sort(_nums, true);
    
    var _program = new SCRIPT();
    var _buf = buffer_create(1024, buffer_grow, 1);
    var _count = array_length(_nums);
    
    for (var _i = 0; _i < _count; _i++)
    {
        var _line = _by_num[$ string(_nums[_i])];
        array_push(_program.lines, _line);
        buffer_write(_buf, buffer_text, _line + "\r\n");
    }
    
    buffer_write(_buf, buffer_u8, 0);
    buffer_seek(_buf, buffer_seek_start, 0);
    _program.text = buffer_read(_buf, buffer_string);
    buffer_delete(_buf);
    
    _program.tokens = tokenize(_program);
    objSystem.program = _program;
    objSystem.program.loaded = true;
}

function load_basic(_filename)
{
    var _file = file_text_open_read(_filename);
    
    objSystem.program = new SCRIPT();
    
    while(!file_text_eof(_file))
    {
        objSystem.program.add_line(file_text_read_string(_file), false);
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

