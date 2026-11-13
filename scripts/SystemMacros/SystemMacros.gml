draw_set_font(fntDejaVuSansMono);

function TOKEN(_kind, _value) constructor 
    {
        kind = _kind;
        value = _value;
    }

function SCRIPT(_text = "") constructor
{
    text := _text;
    lines = [];
    tokens = [];
    output = "";
    variables =  {};
    pc = 0;
    running = false;
    steps := 0;
    
    start := function()
    {
        output = "";
        pc = 0;
        variables = {};
        running = true;
    };
    
    tokens_to_string = function()
    {
        var _str = [];
        var _len = array_length(self.tokens);
        for(var _i = 0; _i < _len; _i ++)
        {
            array_push(_str, self.tokens[_i].value);
        }
        return _str;
    }
    
    add_line := function(_line)
    {  
        var _line_num = get_line_number(_line);
        
        
        var _len = array_length(lines);
        var _new = true;
        for(var _i = 0; _i < _len; _i++)
        {
            if(get_line_number(lines[_i]) == _line_num)
            {
                array_delete(lines, _i, 1);
                array_insert(lines, _i, _line);
                _new := false;
            }
        }
        
        if(_new)
        {

            array_push(lines, _line);
        }
        
        array_sort(lines, function(_current, _next)
            {
                return get_line_number(_current) - get_line_number(_next);
            })
        
            text := "";
            for(var _i = 0; _i < array_length(lines); _i++)
            {
                if(is_string(lines[_i]))
                text += lines[_i]+"\r\n";
            }
        self.tokens = tokenize(self);
    }
    
    run := function( _steps = 1000)
    {
        //output = "";
    
        var _i = self.pc;
        var _len = array_length(self.tokens);
        var _running = true;
        self.steps := _steps;
    
        while (_i < _len && _running && self.steps > 0)
        {
            var _token = self.tokens[_i];
    
            if (_token.kind == "NUMBER" || _token.kind == "NEWLINE")
            {
                _i++;
            }
            else if (_token.kind == "WORD")
            {
                if (_token.value == "PRINT")
                {
                    if (_i + 1 < _len)
                    {
                        var _var = get_variable(self.tokens[_i + 1].value);
                        if(_var != -1)
                        {
                            output += string(_var);
                        }
                        else 
                        {
                            output += string(self.tokens[_i + 1].value);
                        }
                        
                        
                        _i += 2;
                    }
                    else
                    {
                        _running = false; 
                    }
                }
                else if (_token.value == "GOTO")
                {
                    if (_i + 1 < _len)
                    {
                        var _target = find_line_token(self.tokens[_i + 1].value);
                
                        if (_target == -1)
                        {
                            _running = false;
                        }
                        else
                        {
                            _i = _target;
                        }
                    }
                    else
                    {
                        _running = false;
                    }
                }
                else if (_token.value == "END")
                {
                    _running = false;
                }
                else if (_token.value == "CLS")
                {
                    output = "";
                    _i++;
                }
                else if(_token.value == "LET")
                {
                    ///update_variable(self.tokens[_i+1], self.tokens[_i + 3]);///old LET code
                    var _first = get_variable(self.tokens[_i+1].value);
                    var _op = self.tokens[_i+2].value;
                    var _second = self.tokens[_i+3].value;
                    
                    if(is_undefined(_first) && _op = "=")///define a new value
                    {
                        update_variable(self.tokens[_i+1], self.tokens[_i + 3]);///old LET code
                        _i += 3;
                    }
                    
                    ///I DON:T KNOW HOW TO DO THE FUCKING MATH OKAY???
                    
                }
                else
                {
                    _i++;
                }
            }
            else
            {
                _i++;
            }
            steps --;
        }
        
        self.pc = _i;
        self.running = _running;
        
        if(string_length(self.output) > 2000)
        {
            self.output = string_delete(self.output, 1, 80);
        }
    }

}

function is_digit(_char)
{
    return (ord(_char) >= ord("0") && ord(_char) <= ord("9"))
}

function is_letter(_char)
{
    var _upper = string_upper(_char);
    return (ord(_upper) >= ord("A") && ord(_upper) <= ord("Z"))
}

function get_line_number(_line)
{
    var _i = 1;
    var _num = "";
    while (_i <= string_length(_line) && string_char_at(_line, _i) != " ")
    {
        _num += string_char_at(_line, _i);
        _i ++;
    }
    return real(_num);
}

function tokenize(_SCRIPT)
{
    var _tokens = [];
    var _i = 1;
    var _len = string_length(_SCRIPT.text);
    var _cmd = false;

    while (_i <= _len)
    {
        var _ch = string_char_at(_SCRIPT.text, _i);

        if (_ch == " " || _ch == "\t")
        {
            _i++;
        }
        else if (_ch == "\r" || _ch == "\n")
        {
            if (_ch == "\r" && _i < _len && string_char_at(_SCRIPT.text, _i + 1) == "\n")
            {
                _i += 2;
            }
            else
            {
                _i++;
            }

            array_push(_tokens, new TOKEN("NEWLINE", "\n"));
        }
        else if (is_digit(_ch))///NUMBERS
        {
            var _value = "";

            while (_i <= _len && is_digit(string_char_at(_SCRIPT.text, _i)))
            {
                _value += string_char_at(_SCRIPT.text, _i);
                _i++;
            }

            array_push(_tokens, new TOKEN("NUMBER", _value));
        }
        else if (is_letter(_ch))//WORDS
        {
            var _value = "";

            while (_i <= _len && (is_letter(string_char_at(_SCRIPT.text, _i)) || is_digit(string_char_at(_SCRIPT.text, _i))))
            {
                _value += string_char_at(_SCRIPT.text, _i);
                _i++;
            }

            array_push(_tokens, new TOKEN("WORD", _value));
            
        }
        else if (_ch == "\"")//STRINGS
        {
            _i++;
            var _value = "";

            while (_i <= _len && string_char_at(_SCRIPT.text, _i) != "\"")
            {
                _value += string_char_at(_SCRIPT.text, _i);
                _i++;
            }

            if (_i <= _len)
            {
                _i++;
            }

            array_push(_tokens, new TOKEN("STRING", _value));
        }

        else
        {
            array_push(_tokens, new TOKEN("SYMBOL", _ch));
            _i++;
        }
    }

    return _tokens;
}


function update_variable(_var_name, _value)///LET
{
    objSystem.program.variables[$ _var_name.value] = _value.value;
}


///VARIABLE HELPERS
function get_variable(_var_name)
{
    if(variable_struct_exists(objSystem.program.variables, _var_name))
    return objSystem.program.variables[$ _var_name];
    else
    return undefined;
}

function find_line_token(_number)
{
    var _tokens = objSystem.program.tokens;
    var _i = 0;
    var _line_start = true;

    while (_i < array_length(_tokens))
    {
        var _token = _tokens[_i];

        if (_line_start && _token.kind == "NUMBER"
        && real(_token.value) == real(_number))
        {
            return _i;
        }

        if (_token.kind == "NEWLINE")
        {
            _line_start = true;
        }
        else
        {
            _line_start = false;
        }

        _i++;
    }

    return -1;
}

function notify(_text)
{
    instance_create_depth(10, 10, -1, objSystemNotification, {text:_text});
}



