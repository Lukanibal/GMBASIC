draw_set_font(fntDejaVuSansMono);

function TOKEN(_kind, _value) constructor 
{
    kind = _kind;
    value = _value;
}

function SCRIPT(_text = "") constructor
{
    text = _text;
    lines = [];
    tokens = [];
    output = "";
    variables =  {};
    pc = 0;
    running = false;
    steps = 0;
    
    //input handling
    waiting_for_input = false;
    input_var = "";
    input_text = "";
    
    //graphics api
    graphics = [];
    graphics_build = [];
    has_built_frame = false;
    
    start = function()
    {
        output = "";
        pc = 0;
        variables = {};
        waiting_for_input = false;
        input_var = "";
        input_text = "";
        graphics = [];
        graphics_build = [];
        has_built_frame = false;
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
    
    add_line = function(_line)
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
                _new = false;
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
        
            text = "";
            for(var _i = 0; _i < array_length(lines); _i++)
            {
                if(is_string(lines[_i]))
                text += lines[_i]+"\r\n";
            }
        self.tokens = tokenize(self);
    }
    
    remove_line = function(_num)
    {
        var _len = array_length(objSystem.program.lines);
        
        for(var _i = 0; _i < _len; _i++)
        {
            if(get_line_number(objSystem.program.lines[_i]) == _num)
            {
                array_delete(objSystem.program.lines, _i, 1);
            }
        }
    }
    
    run = function( _steps = 1000)
    {
        //output = "";
    
        var _i = self.pc;
        var _len = array_length(self.tokens);
        var _running = true;
        self.steps = _steps;
        
        if (self.waiting_for_input)
        {
            return;
        }

    
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
                        if(_var != undefined)
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
                    if(has_built_frame)
                    {
                        graphics = graphics_build;
                    }
                    graphics_build = [];
                    has_built_frame = true;
                    output = "";
                    _i++;
                }
                else if (_token.value == "INPUT")
                {
                    if (_i + 1 < _len && self.tokens[_i + 1].kind == "WORD")
                    {
                        self.input_var = self.tokens[_i + 1].value;
                        self.input_text = "";
                        keyboard_string = "";
                        self.waiting_for_input = true;
                
                        _i += 2;
                        _running = false;
                    }
                    else
                    {
                        notify("INPUT: EXPECTED A VARIABLE NAME");
                        _running = false;
                    }
                }
                else if (_token.value == "LET")
                {
                    var _equals = _i + 2;
                    var _end = _equals + 1;
                    var _name = self.tokens[_i + 1].value;
                    var _expression_start = _equals + 1;
                
                    while (_end < _len && self.tokens[_end].kind != "NEWLINE")
                    {
                        _end++;
                    }
                    
                    if (_end == _expression_start + 1
                    && self.tokens[_expression_start].kind == "STRING")
                    {
                        self.variables[$ _name] = self.tokens[_expression_start].value;
                        _i = _end;
                    }
                    else if (_i + 1 >= _len || _equals >= _len || self.tokens[_equals].value != "=" || _end == _equals + 1)
                    {
                        notify("LET: EXPECTED A DESTINATION AND EXPRESSION");
                        _running = false;
                    }
                    else
                    {
                        //var _name = self.tokens[_i + 1].value;
                        var _postfix = to_postfix(self.tokens, _equals + 1);
                
                        if (array_length(_postfix) == 0)
                        {
                            notify("LET: COULD NOT PARSE EXPRESSION");
                            _running = false;
                        }
                        else
                        {
                            var _result = evaluate_postfix(_postfix);
                            self.variables[$ _name] = _result;
                            _i = _end;
                        }
                    }
                }
                else if (_token.value == "LINE")
                {
                    var _valid = (_i + 7 < _len);
                
                    if (_valid)
                    {
                        _valid = (self.tokens[_i + 2].value == "," && self.tokens[_i + 4].value == "," && self.tokens[_i + 6].value == ","); 
                    }
                
                    if (_valid)
                    {
                        var _x1 = line_value(self.tokens[_i + 1]);
                        var _y1 = line_value(self.tokens[_i + 3]);
                        var _x2 = line_value(self.tokens[_i + 5]);
                        var _y2 = line_value(self.tokens[_i + 7]);
                
                        _valid = (!is_undefined(_x1) && !is_undefined(_y1) && !is_undefined(_x2) && !is_undefined(_y2));
                    }
                
                    if (!_valid)
                    {
                        notify("LINE: EXPECTED FOUR NUMBER OR VARIABLE ARGUMENTS");
                        _running = false;
                    }
                    else
                    {
                        array_push(self.graphics_build, { kind: "LINE", x1: _x1, y1: _y1, x2: _x2, y2: _y2 });
                
                        _i += 8;
                    }
                }
                else if (_token.value == "TRI")
                {
                    var _valid = (_i + 11 < _len);
                
                    if (_valid)
                    {
                        _valid = (self.tokens[_i + 2].value == "," && self.tokens[_i + 4].value == "," && self.tokens[_i + 6].value == ","); 
                    }
                
                    if (_valid)
                    {
                        var _x1 = line_value(self.tokens[_i + 1]);
                        var _y1 = line_value(self.tokens[_i + 3]);
                        var _x2 = line_value(self.tokens[_i + 5]);
                        var _y2 = line_value(self.tokens[_i + 7]);
                        var _x3 = line_value(self.tokens[_i + 9]);
                        var _y3 = line_value(self.tokens[_i + 11]);
                
                        _valid = (!is_undefined(_x1) && !is_undefined(_y1) && !is_undefined(_x2) && !is_undefined(_y2));
                    }
                
                    if (!_valid)
                    {
                        notify("TRI: EXPECTED SIX NUMBER OR VARIABLE ARGUMENTS");
                        _running = false;
                    }
                    else
                    {
                        array_push(self.graphics_build, { kind: "TRI", x1: _x1, y1: _y1, x2: _x2, y2: _y2, x3: _x3, y3: _y3});
                
                        _i += 12;
                    }
                }
                else if (_token.value == "FTRI")
                {
                    var _valid = (_i + 11 < _len);
                
                    if (_valid)
                    {
                        _valid = (self.tokens[_i + 2].value == "," && self.tokens[_i + 4].value == "," && self.tokens[_i + 6].value == ","); 
                    }
                
                    if (_valid)
                    {
                        var _x1 = line_value(self.tokens[_i + 1]);
                        var _y1 = line_value(self.tokens[_i + 3]);
                        var _x2 = line_value(self.tokens[_i + 5]);
                        var _y2 = line_value(self.tokens[_i + 7]);
                        var _x3 = line_value(self.tokens[_i + 9]);
                        var _y3 = line_value(self.tokens[_i + 11]);
                
                        _valid = (!is_undefined(_x1) && !is_undefined(_y1) && !is_undefined(_x2) && !is_undefined(_y2));
                    }
                
                    if (!_valid)
                    {
                        notify("FTRI: EXPECTED SIX NUMBER OR VARIABLE ARGUMENTS");
                        _running = false;
                    }
                    else
                    {
                        array_push(self.graphics_build, { kind: "FTRI", x1: _x1, y1: _y1, x2: _x2, y2: _y2, x3: _x3, y3: _y3});
                
                        _i += 12;
                    }
                }
                else if (_token.value == "RECT")
                {
                    var _valid = (_i + 7 < _len);
                
                    if (_valid)
                    {
                        _valid = (self.tokens[_i + 2].value == "," && self.tokens[_i + 4].value == "," && self.tokens[_i + 6].value == ","); 
                    }
                
                    if (_valid)
                    {
                        var _x1 = line_value(self.tokens[_i + 1]);
                        var _y1 = line_value(self.tokens[_i + 3]);
                        var _x2 = line_value(self.tokens[_i + 5]);
                        var _y2 = line_value(self.tokens[_i + 7]);
                
                        _valid = (!is_undefined(_x1) && !is_undefined(_y1) && !is_undefined(_x2) && !is_undefined(_y2));
                    }
                
                    if (!_valid)
                    {
                        notify("RECT: EXPECTED FOUR NUMBER OR VARIABLE ARGUMENTS");
                        _running = false;
                    }
                    else
                    {
                        array_push(self.graphics_build, { kind: "RECT", x1: _x1, y1: _y1, x2: _x2, y2: _y2 });
                
                        _i += 8;
                    }
                }
                else if (_token.value == "FRECT")
                {
                    var _valid = (_i + 7 < _len);
                
                    if (_valid)
                    {
                        _valid = (self.tokens[_i + 2].value == "," && self.tokens[_i + 4].value == "," && self.tokens[_i + 6].value == ","); 
                    }
                
                    if (_valid)
                    {
                        var _x1 = line_value(self.tokens[_i + 1]);
                        var _y1 = line_value(self.tokens[_i + 3]);
                        var _x2 = line_value(self.tokens[_i + 5]);
                        var _y2 = line_value(self.tokens[_i + 7]);
                
                        _valid = (!is_undefined(_x1) && !is_undefined(_y1) && !is_undefined(_x2) && !is_undefined(_y2));
                    }
                
                    if (!_valid)
                    {
                        notify("FRECT: EXPECTED FOUR NUMBER OR VARIABLE ARGUMENTS");
                        _running = false;
                    }
                    else
                    {
                        array_push(self.graphics_build, { kind: "FRECT", x1: _x1, y1: _y1, x2: _x2, y2: _y2 });
                
                        _i += 8;
                    }
                }
                else if (_token.value == "CIRC")
                {
                    var _valid = (_i + 5 < _len);
                
                    if (_valid)
                    {
                        _valid = (self.tokens[_i + 2].value == "," && self.tokens[_i + 4].value == ","); 
                    }
                
                    if (_valid)
                    {
                        var _x1 = line_value(self.tokens[_i + 1]);
                        var _y1 = line_value(self.tokens[_i + 3]);
                        var _x2 = line_value(self.tokens[_i + 5]);
                
                        _valid = (!is_undefined(_x1) && !is_undefined(_y1) && !is_undefined(_x2));
                    }
                
                    if (!_valid)
                    {
                        notify("CIRC: EXPECTED THREE NUMBER OR VARIABLE ARGUMENTS");
                        _running = false;
                    }
                    else
                    {
                        array_push(self.graphics_build, { kind: "CIRC", x1: _x1, y1: _y1, x2: _x2 });
                
                        _i += 6;
                    }
                }
                else if (_token.value == "FCIRC")
                {
                    var _valid = (_i + 5 < _len);
                
                    if (_valid)
                    {
                        _valid = (self.tokens[_i + 2].value == "," && self.tokens[_i + 4].value == ","); 
                    }
                
                    if (_valid)
                    {
                        var _x1 = line_value(self.tokens[_i + 1]);
                        var _y1 = line_value(self.tokens[_i + 3]);
                        var _x2 = line_value(self.tokens[_i + 5]);
                
                        _valid = (!is_undefined(_x1) && !is_undefined(_y1) && !is_undefined(_x2));
                    }
                
                    if (!_valid)
                    {
                        notify("FCIRC: EXPECTED THREE NUMBER OR VARIABLE ARGUMENTS");
                        _running = false;
                    }
                    else
                    {
                        array_push(self.graphics_build, { kind: "FCIRC", x1: _x1, y1: _y1, x2: _x2 });
                
                        _i += 6;
                    }
                }
                else if (_token.value == "SETDRAWCOLOR")
                {
                    var _valid = (_i + 1 < _len);
                
                    if (_valid)
                    {
                        _valid = (self.tokens[_i + 1].kind == "WORD");
                    }
                
                    var _col = "";
                
                    if (_valid)
                    {
                        _col = self.tokens[_i + 1].value;
                
                        _valid =
                            _col == "RED" ||
                            _col == "BLUE" ||
                            _col == "GREEN" ||
                            _col == "LIME" ||
                            _col == "MAROON" ||
                            _col == "AQUA" ||
                            _col == "ORANGE" ||
                            _col == "WHITE" ||
                            _col == "BLACK" ||
                            _col == "PURPLE"||
                            _col == "YELLOW";
                    }
                
                    if (!_valid)
                    {
                        notify("SETDRAWCOLOR: EXPECTED A VALID COLOR NAME");
                        _running = false;
                    }
                    else
                    {
                        array_push(self.graphics_build, { kind: "SETDRAWCOLOR",col: _col });
                        _i += 2;
                    }
                }
                else if (_token.value == "IF")
                {
                    var _then = -1;
                    var _else = -1;
                    var _end = _i + 1;
                
                    while (_end < _len && self.tokens[_end].kind != "NEWLINE")
                    {
                        var _current = self.tokens[_end];
                
                        if (_current.kind == "WORD")
                        {
                            if (_current.value == "THEN" && _then == -1)
                            {
                                _then = _end;
                            }
                            else if (_current.value == "ELSE" && _then != -1)
                            {
                                _else = _end;
                            }
                        }
                
                        _end++;
                    }
                
                    if (_then == -1)
                    {
                        notify("IF: EXPECTED THEN");
                        _running = false;
                    }
                    else
                    {
                        var _condition_tokens = [];
                
                        for (var _c = _i + 1; _c < _then; _c++)
                        {
                            array_push(_condition_tokens, self.tokens[_c]);
                        }
                
                        array_push(_condition_tokens, new TOKEN("NEWLINE", "\n"));
                
                        var _postfix = to_postfix(_condition_tokens, 0);
                
                        if (array_length(_postfix) == 0)
                        {
                            _running = false;
                        }
                        else
                        {
                            var _condition = evaluate_postfix(_postfix);
                
                            var _branch_start = -1;
                
                            if (_condition)
                            {
                                _branch_start = _then + 1;
                            }
                            else if (_else != -1)
                            {
                                _branch_start = _else + 1;
                            }
                
                            if (_branch_start == -1)
                            {
                                _i = _end;
                            }
                            else if (_branch_start + 1 >= _len || self.tokens[_branch_start].kind != "WORD" || self.tokens[_branch_start].value != "GOTO" || self.tokens[_branch_start + 1].kind != "NUMBER")
                            {
                                notify("IF: EXPECTED GOTO AND A LINE NUMBER");
                                _running = false;
                            }
                            else
                            {
                                var _target = find_line_token(
                                    self.tokens[_branch_start + 1].value
                                );
                
                                if (_target == -1)
                                {
                                    notify("IF: TARGET LINE NOT FOUND");
                                    _running = false;
                                }
                                else
                                {
                                    _i = _target;
                                }
                            }
                        }
                    }
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

function line_value(_token)
{
    if (_token.kind == "NUMBER")
    {
        return real(_token.value);
    }

    if (_token.kind == "WORD")
    {
        var _value = get_variable(_token.value);

        if (!is_undefined(_value) && is_real(_value))
        {
            return _value;
        }
    }

    return undefined;
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
    return real(string_digits(_num));
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
            var _next = "";
            if (_i < _len)
            {
                _next = string_char_at(_SCRIPT.text, _i + 1);
            }
        
            if ((_ch == "<" && (_next == ">" || _next == "=")) ||  (_ch == ">" && _next == "="))
            {
                array_push(_tokens, new TOKEN("SYMBOL", _ch + _next));
                _i += 2;
            }
            else
            {
                array_push(_tokens, new TOKEN("SYMBOL", _ch));
                _i++;
            }
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

///MATH...Based on Shunting Yard Algo
function operator_pecedence(_op)
{
    switch(_op)
    {
        case "=":
        case "<>":
        case "<":
        case ">":
        case "<=":
        case ">=":
            return 0;
        
        case "+":
        case "-":
            return 1;
            
        case "*":
        case "/":
            return 2;
    }
    
    return 0;
}

function is_math_op(_value)
{
    return _value == "+" || _value == "-" || _value == "*" || _value == "/";
}

function is_expr_op(_value)
{
    return (is_math_op(_value) || _value == "=" || _value == "<>" || _value == "<" || _value == ">" || _value == "<=" || _value == ">=");
}

///@param _tokens {ARRAY} an array of math tokens
///@param _start {INTEGER} the starting position
function to_postfix(_tokens, _start)
{
    var _output = [];
    var _ops = [];
    var _i = _start;
    var _len = array_length(_tokens);

    while (_i < _len && _tokens[_i].kind != "NEWLINE")
    {
        var _token = _tokens[_i];
        var _value = _token.value;

        if (_token.kind == "NUMBER" || _token.kind == "WORD" || _token.kind == "STRING")
        {
            array_push(_output, _token);
        }
        else if (_token.kind == "SYMBOL" && _value == "(")
        {
            array_push(_ops, _token);
        }
        else if (_token.kind == "SYMBOL" && _value == ")")
        {
            var _found_open = false;

            while (array_length(_ops) > 0)
            {
                var _top = array_pop(_ops);

                if (_top.value == "(")
                {
                    _found_open = true;
                    break;
                }

                array_push(_output, _top);
            }

            if (!_found_open)
            {
                notify("LET EXPRESSION: UNMATCHED CLOSING PARENTHESIS");
                return [];
            }
        }
        else if (_token.kind == "SYMBOL" && is_expr_op(_value))
        {
            while (array_length(_ops) > 0)
            {
                var _top = _ops[array_length(_ops) - 1];

                if (_top.value == "(")
                {
                    break;
                }

                if (operator_pecedence(_top.value) >= operator_pecedence(_value))
                {
                    array_push(_output, array_pop(_ops));
                }
                else
                {
                    break;
                }
            }

            array_push(_ops, _token);
        }
        else
        {
            notify("LET EXPRESSION: UNEXPECTED TOKEN: " + string(_value));
            return [];
        }

        _i++;
    }

    while (array_length(_ops) > 0)
    {
        var _top = array_pop(_ops);

        if (_top.value == "(")
        {
            notify("LET EXPRESSION: UNMATCHED OPENING PARENTHESIS");
            return [];
        }

        array_push(_output, _top);
    }

    return _output;
}

///@param _pf {Array} an array of postfix tokens
function evaluate_postfix(_pf)
{
    var _values = [];
    var _len = array_length(_pf);

    for (var _i = 0; _i < _len; _i++)
    {
        var _token = _pf[_i];

        if (_token.kind == "NUMBER")
        {
            array_push(_values, real(_token.value));
        }
        else if (_token.kind == "STRING")
        {
            array_push(_values, _token.value);
        }
        else if (_token.kind == "WORD")
        {
            var _value = get_variable(_token.value);
        
            if (is_undefined(_value))
            {
                notify("LET EXPRESSION: UNDEFINED VARIABLE: " + _token.value);
                return 0;
            }
        
            array_push(_values, _value);
        }
        else if (_token.kind == "SYMBOL" && is_expr_op(_token.value))
        {
            if (array_length(_values) < 2)
            {
                notify("LET EXPRESSION: MISSING OPERAND");
                return 0;
            }

            var _right = array_pop(_values);
            var _left = array_pop(_values);
            var _result = 0;

            switch (_token.value)
            {
                case "+":
                {
                    if (is_string(_left) || is_string(_right))
                    {
                        _result = string(_left) + string(_right);
                    }
                    else
                    {
                        _result = _left + _right;
                    }
                    break;
                }

                case "-":
                {
                    _result = _left - _right;
                    break;
                }
                    

                case "*":
                {
                    _result = _left * _right;
                    break;
                }
                    

                case "/":
                {
                    if (_right == 0)
                    {
                        notify("LET EXPRESSION: DIVISION BY ZERO");
                        return 0;
                    }
                    _result = _left / _right;
                    break;
                }
                    
                case "=":  
                {
                    _result = (_left == _right); 
                    break;
                }
                case "<>": 
                {
                    _result = (_left != _right); 
                    break;
                }
                case "<":  
                {
                    _result = (_left <  _right); 
                    break;
                }
                case ">":  
                {
                    _result = (_left >  _right); 
                    break; 
                    }
                case "<=":
                {
                    _result = (_left <= _right); 
                    break;
                } 
                case ">=": 
                {
                    _result = (_left >= _right); 
                    break;
                }
                    

            }

            array_push(_values, _result);
        }
    }

    if (array_length(_values) != 1)
    {
        notify("LET EXPRESSION: INVALID EXPRESSION");
        return 0;
    }

    return _values[0];
}


///SYSTEM CALLS
function notify(_text)
{
    instance_create_depth(10, 610, -1, objSystemNotification, {text:_text});
}


