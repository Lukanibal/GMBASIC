draw_set_font(fntCQMono);

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
    func_cache = [];
    if_cache = [];
    let_cache = [];
    output = $"GMBASIC v26.11.22.1";
    variables =  {};
    pc = 0;
    running = false;
    steps = 0;
    _out_of_time = false;
    
    current_line = -1;
    
    errors = [];
    
    loaded = true;
    
    //input handling
    waiting_for_input = false;
    input_var = "";
    input_text = "";
    input_mode = "";
    
    //graphics api
    graphics = [];
    graphics_build = [];
    has_built_frame = false;
    //also graphics but kinda seperate
    sprites = {};
    
    clear_caches = function()
    {
        func_cache = [];
        if_cache = [];
        let_cache = [];
    }
    
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
        current_line = -1;
        errors = [];
        running = true;
        if(array_length(self.tokens) == 0)
        {
            tokens = tokenize(self);
        }
        self.run();
    };
    
    to_text = function()
    {
        var _len = array_length(self.lines);
        var _i = 0;
        var _str = "";
        while( _i != _len)
        {
            _str += self.lines[_i] + "\n";
            _i ++;
        }
        
        return _str;
    }
    
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
    
    add_line = function(_line, _tokenize = true)
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
        
        if(_tokenize)
        {
            self.tokens = tokenize(self);
        }
        
    }
    
    remove_line = function(_num)
    {
        for (var _i = array_length(lines) - 1; _i >= 0; _i--)
        {
            if (get_line_number(lines[_i]) == _num)
            {
                array_delete(lines, _i, 1);
            }
        }
        
        text = "";
        for (var _i = 0; _i < array_length(lines); _i++)
        {
            text += lines[_i] + "\r\n";
        }
        self.tokens = tokenize(self);
    }
    
    run = function( _steps = 1300)
    {
        var _i = self.pc;
        var _len = array_length(self.tokens);
        var _running = true;
        var _start = get_timer();
        self.steps = _steps;
        _check = 0;
        _yield = false;
        
        if (self.waiting_for_input)
        {
            return;
        }
        
        while (_i < _len && _running && self.steps > 0 && !_yield)
        {
            var _token = self.tokens[_i];
            
            if (_token.kind == "NUMBER" && (_i == 0 || self.tokens[_i - 1].kind == "NEWLINE"))
            {
                self.current_line = real(_token.value);
                _i++;
            }
            else if (_token.kind == "NUMBER" || _token.kind == "NEWLINE")
            {
                _i++;
            }
            else if (_token.kind == "WORD")
            {
                
                if (_token.value == "PRINT")
                {
                    var _postfix = to_postfix(self.tokens, _i + 1);
                
                    if (array_length(_postfix) == 0)
                    {
                        notify($"{current_line}: PRINT: EXPECTED A VALUE");
                        _running = false;
                    }
                    else
                    {
                        output += string(evaluate_postfix(_postfix));
                
                        var _e = _i + 1;
                        while (_e < _len && self.tokens[_e].kind != "NEWLINE") _e++;
                        _i = _e;
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
                else if (_token.value == "VSYNC")
                {
                    _yield = true;
                    self.steps = 0;
                    _i++;
                }
                else if (_token.value == "INPUT")
                {
                    
                    var _mode = self.tokens[_i + 1].value;
                    if(_mode == "KEY")
                    {
                        if (_i + 2 < _len && self.tokens[_i + 2].kind == "WORD")
                        {
                            self.input_var = self.tokens[_i + 2].value;
                            self.input_mode = "KEY";
                            self.waiting_for_input = true;
                            
                            _i += 3;
                            _running = false;
                        }
                        else
                        {
                            notify($"{current_line}: INPUT KEY: EXPECTED A VARIABLE NAME");
                            _running = false;
                        }
                    }
                    else
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
                        notify($"{current_line}: INPUT: EXPECTED A VARIABLE NAME");
                        _running = false;
                    }
                }
                else if (_token.value == "LET")
                {
                    var _name = self.tokens[_i + 1].value;
                    var _equals = _i + 2;
                    var _index_pf = undefined;
                    
                    if (_i + 2 < _len && self.tokens[_i + 2].kind == "SYMBOL" && self.tokens[_i + 2].value == "(")
                    {
                        var _close = find_close_paren(self.tokens, _i + 2);
                        if (_close != -1)
                        {
                            var _inner = [];
                            for (var _k = _i + 3; _k < _close; _k++) array_push(_inner, self.tokens[_k]);
                            array_push(_inner, new TOKEN("NEWLINE", "\n"));
                            _index_pf = to_postfix(_inner, 0);
                            _equals = _close + 1;
                        }
                    }
                    
                    var _end = _equals + 1;
                    while (_end < _len && self.tokens[_end].kind != "NEWLINE") _end++;
                        
                    if (_i + 1 >= _len || _equals >= _len || self.tokens[_equals].value != "=" || _end == _equals + 1 || (!is_undefined(_index_pf) && array_length(_index_pf) == 0))
                    {
                        notify($"{current_line}: LET: EXPECTED A DESTINATION AND EXPRESSION");
                        _running = false;
                    }
                    else
                    {
                        var _postfix = to_postfix(self.tokens, _equals + 1);
                        
                        if (array_length(_postfix) == 0)
                        {
                            notify($"{current_line}: LET: COULD NOT PARSE EXPRESSION");
                            _running = false;
                        }
                        else
                        {
                            var _result = evaluate_postfix(_postfix);
                            
                            if (is_undefined(_index_pf))
                            {
                                self.variables[$ _name] = _result;
                            }
                            else
                            {
                                var _arr = get_variable(_name);
                                var _idx = floor(evaluate_postfix(_index_pf));
                                
                                if (!is_array(_arr))
                                {
                                    notify($"{current_line}: NOT AN ARRAY: " + _name);
                                    _running = false;
                                }
                                else if (_idx < 0 || _idx >= array_length(_arr))
                                {
                                    notify($"{current_line}: INDEX OUT OF RANGE: " + _name + "(" + string(_idx) + ")");
                                    _running = false;
                                }
                                else
                                {
                                    _arr[_idx] = _result;
                                }
                            }
                            _i = _end;
                        }
                    }
                }
                else if (_token.value == "MATRIXSETWORLD" || _token.value == "MATRIXSETVIEW" || _token.value == "MATRIXSETPROJ")
                {
                    var _postfix = to_postfix(self.tokens, _i);
                
                    if (array_length(_postfix) == 0)
                    {
                        notify($"{current_line}:" + _token.value + ": INVALID ARGUMENT");
                        _running = false;
                    }
                    else
                    {
                        evaluate_postfix(_postfix);
                
                        var _end = _i;
                        while (_end < _len && self.tokens[_end].kind != "NEWLINE")
                        {
                            _end++;
                        }
                        _i = _end;
                    }
                }
                else if (_token.value == "DIM")
                {
                    var _valid = (_i + 4 < _len)
                        && self.tokens[_i + 1].kind == "WORD"
                        && self.tokens[_i + 2].value == "("
                        && self.tokens[_i + 4].value == ")";
                    
                    var _size = undefined;
                    if (_valid) _size = line_value(self.tokens[_i + 3]);
                    if (_valid && is_undefined(_size)) _valid = false;
                        
                    if (!_valid || _size < 0 || _size > 4000000000)
                    {
                        notify($"{current_line}: DIM: EXPECTED NAME(SIZE)");
                        _running = false;
                    }
                    else
                    {
                        self.variables[$ self.tokens[_i + 1].value] = array_create(floor(_size) + 1, 0);
                        _i += 5;
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
                        notify($"{current_line}: IF: EXPECTED THEN");
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
                                notify($"{current_line}: IF: EXPECTED GOTO AND A LINE NUMBER");
                                _running = false;
                            }
                            else
                            {
                                var _target = find_line_token(
                                    self.tokens[_branch_start + 1].value
                                );
                                
                                if (_target == -1)
                                {
                                    notify($"{current_line}: IF: TARGET LINE NOT FOUND");
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
                else if (array_contains(global.function_names, _token.value))
                {
                    var _postfix = to_postfix(self.tokens, _i);
                
                    if (array_length(_postfix) == 0)
                    {
                        notify($"{current_line}:" + _token.value + ": INVALID ARGUMENT");
                        _running = false;
                    }
                    else
                    {
                        evaluate_postfix(_postfix);
                
                        var _end = _i;
                        while (_end < _len && self.tokens[_end].kind != "NEWLINE")
                        {
                            _end++;
                        }
                        _i = _end;
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
            _check++;
            if (_check >= 32) 
            { 
                _check = 0; 
                if (get_timer() - _start >= _steps) 
                {
                    _out_of_time = true; 
                }
            }
        }
        
        self.pc = _i;
        self.running = _running;
        
        if(string_length(self.output) > 2000)
        {
            var _output_over = string_length(output) - 2000;
            output = string_delete(output, 1, _output_over);
        }
    }

}
///BASIC HELPERS
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
    var _len = array_length(_SCRIPT.lines);
    var _result = [];
    
    for(var _i = 0; _i < _len; _i++)
    {
        _result = array_concat(_result, tokenizer(_SCRIPT.lines[_i]));
        array_push(_result, new TOKEN("NEWLINE", "\n"));
    }
    return _result;
}

function tokenizer(_line, _tokens = [])
{
    var _i = 1;
    var _len = string_length(_line);
    var _cmd = false;
    
    while (_i <= _len)
    {
        var _ch = string_char_at(_line, _i);
        
        if (_ch == " " || _ch == "\t")
        {
            _i++;
        }
        else if (_ch == "\r" || _ch == "\n")
        {
            if (_ch == "\r" && _i < _len && string_char_at(_line, _i + 1) == "\n")
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
            
            while (_i <= _len && is_digit(string_char_at(_line, _i)) || _i <= _len && string_char_at(_line, _i) == ".")
            {
                _value += string_char_at(_line, _i);
                _i++;
            }
            
            array_push(_tokens, new TOKEN("NUMBER", _value));
        }
        else if (is_letter(_ch))//WORDS
        {
            var _value = "";
            
            while (_i <= _len && (is_letter(string_char_at(_line, _i)) || is_digit(string_char_at(_line, _i)) || string_char_at(_line, _i) == "_"))
            {
                _value += string_char_at(_line, _i);
                _i++;
            }
            
            array_push(_tokens, new TOKEN("WORD", _value));
            
        }
        else if (_ch == "\"")//STRINGS
        {
            _i++;
            var _value = "";
            
            while (_i <= _len && string_char_at(_line, _i) != "\"")
            {
                var _c = string_char_at(_line, _i);
                var _n = string_char_at(_line, _i + 1);
                
                if (_c == "\\" && (_n == "n" || _n == "N"))
                {
                    _value += "\n";
                    _i += 2;
                }
                else
                {
                    _value += _c;
                    _i++;
                }
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
                _next = string_char_at(_line, _i + 1);
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
    var _reserved = objSystem.RESERVED.WORDS;
    
    if (array_contains(global.function_names, string_upper(_var_name)))
    {
        notify("VARIABLE NAME CANNOT BE FUNCTION NAME");
        return undefined;
    }
    
    if (variable_struct_exists(_reserved, _var_name))
    {
        return _reserved[$ _var_name];
    }
    
    if (variable_struct_exists(objSystem.sprites, _var_name))
    {
        return objSystem.sprites[$ _var_name];
    }
    
    
    if (variable_struct_exists(objSystem.program.variables, _var_name))
    {
        return objSystem.program.variables[$ _var_name];
    }
    
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
        
        if (_line_start && _token.kind == "NUMBER" && real(_token.value) == real(_number))
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

///MATH LIBRARY HELPERS
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
            
        case "NEG":
            return 3;
    }
    
    return 0;
}

function is_math_op(_value)
{
    return _value == "+" || _value == "-" || _value == "*" || _value == "/";
}

function is_expr_op(_value)
{
    return (is_math_op(_value) || _value == "=" || _value == "<>" || _value == "<" || _value == ">" || _value == "<=" || _value == ">=" || _value == "MOD");
}

function lengthdir_z(_len, _pitch) 
{
    return _len * dsin(_pitch);
}

///@param _tokens {ARRAY} an array of math tokens
///@param _start {INTEGER} the starting position
function to_postfix(_tokens, _start)
{
    var _output = [];
    var _ops = [];
    var _i = _start;
    var _len = array_length(_tokens);
    var _expect_value = true;

    while (_i < _len && _tokens[_i].kind != "NEWLINE")
    {
        var _token = _tokens[_i];
        var _value = _token.value;
        
        if(_token.kind == "WORD" && _i +1 < _len && _tokens[_i + 1].kind == "SYMBOL" && _tokens[_i + 1].value == "(")
        {
            var _close = find_close_paren(_tokens, _i + 1);
            
            if(_close == -1)
            {
                notify("LET EXPRESSION: UNMATCHED OPENING PARENTHESIS");
                return [];
            }
            
            if(array_contains(global.function_names, string_upper(_value)))
            {
                var _split = split_arguments(_tokens, _i + 2, _close);
                
                if(!_split.ok)
                {
                    notify("FUNCTION: EMPTY OR INVALID ARGUMENT");
                    return [];
                }
                
                var _args_pf = [];
                
                for(var _j = 0; _j < array_length(_split.parts); _j++)
                {
                    var _arg_tokens = _split.parts[_j];
                    array_push(_arg_tokens, new TOKEN("NEWLINE", "\n"))
                    
                    var _arg_pf = to_postfix(_arg_tokens, 0);
                    
                    if(array_length(_arg_pf) == 0)
                    {
                        notify("FUNCTION: EXPECTED ARGUMENT OR EXPRESSION");
                        return [];
                    }
                    
                    array_push(_args_pf, _arg_pf);
                }
                var _name = string_upper(_value);
                array_push(_output, new TOKEN("FUNCTION", {id: global.function_bridge[$ _name], name: _name, arguments: _args_pf}));
                _expect_value = false;
            }
            else 
            {
                var _inner = [];
                for(var _j = _i + 2; _j < _close; _j++)
                {
                    array_push(_inner, _tokens[_j]);
                }
                array_push(_inner, new TOKEN("NEWLINE", "\n"));
                
                var _index_pf = to_postfix(_inner, 0);
                if(array_length(_index_pf) == 0)
                {
                    notify("ARRAY INDEX: EXPECTED AN EXPRESSION");
                    return [];
                }
                
                array_push(_output, new TOKEN("ARRAYREF", { name: _value, index: _index_pf }));
                _expect_value = false;
                
            }
            
            _i = _close;
            
        }
        else if (_token.kind == "NUMBER" || _token.kind == "WORD" || _token.kind == "STRING")
        {
            array_push(_output, _token);
            _expect_value = false;
        }
        else if (_token.kind == "SYMBOL" && _value == "(")
        {
            array_push(_ops, _token);
            _expect_value = true;
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
            if (_value == "-" && _expect_value)
            {
                array_push(_ops, new TOKEN("UNARY", "NEG"));
            }
            else
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
                _expect_value = true;
            }
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
                notify("LET EXPRESSION: UNDEFINED VARIABLE: " + _token.value, true);
                return 0;
            }
            
            array_push(_values, _value);
        }
        else if(_token.kind == "ARRAYREF")
        {
            var _arr = get_variable(_token.value.name);
            if(!is_array(_arr))
            {
                notify($"NOT AN ARRAY: {_token.value.name}", true);
                return 0;
            }
            
            var _idx = evaluate_postfix(_token.value.index);
            if(!is_real(_idx))
            {
                notify("ARRAY INDEX MUST BE A NUMBER", true);
                return 0;
            }
            
            _idx = floor(_idx);
            if(_idx < 0 || _idx >= array_length(_arr))
            {
                notify($"INDEX OUT OF RANGE: {_token.value.name}({_idx})", true);
                return 0;
            }
            
            array_push(_values, _arr[_idx])
        }
        else if (_token.kind == "FUNCTION")
        {
            
            
            var _args = [];
            var _arg_count = array_length(_token.value.arguments);
            
            //eval pfs
            for(var _j = 0; _j < _arg_count; _j++)
            {
                array_push(_args, evaluate_postfix(_token.value.arguments[_j]));
            }
            
            var _argument = undefined;
            if (_arg_count > 0)
            {
                _argument = _args[0];
            }

            
            var _func = _token.value.id;
            
            switch(_func)
            {
                case function_ids.SQRT:
                {
                    if (_arg_count != 1)
                    {
                        notify("SQRT: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    if (_argument < 0)
                    {
                        notify("SQRT: ARGUMENT MUST NOT BE NEGATIVE", true);
                        return 0;
                    }
                    
                    array_push(_values, sqrt(_argument));
                    break;
                }
                case function_ids.ABS:
                {
                    if (_arg_count != 1)
                    {
                        notify("ABS: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, abs(_argument));
                    break;
                }
                case function_ids.COS:
                {
                    if (_arg_count != 1)
                    {
                        notify("COS: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, cos(_argument));
                    break;
                }
                case function_ids.SIN:
                {
                    if (_arg_count != 1)
                    {
                        notify("SIN: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, sin(_argument));
                    break;
                }
                case function_ids.TAN:
                {
                    if (_arg_count != 1)
                    {
                        notify("TAN: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, tan(_argument));
                    break;
                }
                case function_ids.MAX:
                {
                    if (_arg_count != 2)
                    {
                        notify("MAX: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, max(_argument, _args[1]));
                    break;
                }
                case function_ids.MIN:
                {
                    if (_arg_count != 2)
                    {
                        notify("MIN: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, min(_argument, _args[1]));
                    break;
                }
                case function_ids.FLOOR:
                {
                    if (_arg_count != 1)
                    {
                        notify("FLOOR: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, floor(_argument));
                    break;
                }
                case function_ids.CEIL:
                {
                    if (_arg_count != 1)
                    {
                        notify("CEIL: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, ceil(_argument));
                    break;
                }
                case function_ids.ROUND:
                {
                    if (_arg_count != 1)
                    {
                        notify("ROUND: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, round(_argument));
                    break;
                }
                case function_ids.SIGN:
                {
                    if (_arg_count != 1)
                    {
                        notify("SIGN: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, sign(_argument));
                    break;
                }
                case function_ids.ARCTAN:
                {
                    if (_arg_count != 1)
                    {
                        notify("ARCTAN: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, arctan(_argument));
                    break;
                }
                case function_ids.ARCTAN2:
                {
                    if (_arg_count != 2)
                    {
                        notify("ARCTAN2: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, arctan2(_argument, _args[1]));
                    break;
                }
                case function_ids.SQR:
                {
                    if (_arg_count != 1)
                    {
                        notify("SQR: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, sqr(_argument));
                    break;
                }
                case function_ids.RANDOM:
                {
                    if (_arg_count != 1)
                    {
                        notify("RANDOM: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, irandom(_argument));
                    break;
                }
                case function_ids.POW:
                {
                    if (_arg_count != 2)
                    {
                        notify("POW: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, power(_argument, _args[1]));
                    break;
                }
                case function_ids.LOG:
                {
                    if (_arg_count != 2)
                    {
                        notify("LOG: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, logn(_argument, _args[1]));
                    break;
                }
                case function_ids.CLAMP:
                {
                    if (_arg_count != 3)
                    {
                        notify("CLAMP: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, clamp(_argument, _args[1], _args[2]));
                    break;
                }
                case function_ids.LERP:
                {
                    if (_arg_count != 3)
                    {
                        notify("LERP: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, lerp(_argument, _args[1], _args[2]));
                    break;
                }
                case function_ids.LENGTHDIRX:
                {
                    if (_arg_count != 2)
                    {
                        notify("LENGTHDIRX: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, lengthdir_x(_argument, _args[1]));
                    break;
                }
                case function_ids.LENGTHDIRY:
                {
                    if (_arg_count != 2)
                    {
                        notify("LENGTHDIRY: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, lengthdir_y(_argument, _args[1]));
                    break;
                }
                case function_ids.LENGTHDIRZ:
                {
                    if (_arg_count != 2)
                    {
                        notify("LENGTHDIRZ: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, lengthdir_z(_argument, _args[1]));
                    break;
                }
                case function_ids.POINTDIR:
                {
                    if (_arg_count != 4)
                    {
                        notify("POINTDIR: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, point_direction(_argument, _args[1], _args[2], _args[3]));
                    break;
                }
                case function_ids.POINTDIST:
                {
                    if (_arg_count != 4)
                    {
                        notify("POINTDIST: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, point_distance(_argument, _args[1], _args[2], _args[3]));
                    break;
                }
                case function_ids.POINTDIST3D:
                {
                    if (_arg_count != 6)
                    {
                        notify("POINTDIST3D: EXPECTS 6 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, point_distance_3d(_argument, _args[1], _args[2], _args[3], _args[4], _args[5]));
                    break;
                }
                case function_ids.MOD:
                {
                    if (_arg_count != 2)
                    {
                        notify("MOD: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, _argument mod _args[1]);
                    break;
                }
                case function_ids.DIV:
                {
                    if (_arg_count != 2)
                    {
                        notify("DIV: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, _argument div _args[1]);
                    break;
                }
                case function_ids.FRAC:
                {
                    if (_arg_count != 1)
                    {
                        notify("FRAC: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, frac(_argument));
                    break;
                }
                case function_ids.RAD:
                {
                    if (_arg_count != 1)
                    {
                        notify("RAD: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, degtorad(_argument));
                    break;
                }
                case function_ids.DEG:
                {
                    if (_arg_count != 1)
                    {
                        notify("DEG: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(_values, radtodeg(_argument));
                    break;
                }
                ///MATRIX
                case function_ids.MATRIXSETWORLD:
                {
                    if (_arg_count != 1)
                    {
                        notify("MATRIXSETWORLD: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    //show_debug_message("MATRIX SET WORLD!");
                    array_push(objSystem.program.graphics_build, {kind: "MATRIXSETWORLD", matrix: _argument });
                    array_push(_values, 0);
                    break;
                }
                case function_ids.MATRIXSETVIEW:
                {
                    if (_arg_count != 1)
                    {
                        notify("MATRIXSETVIEW: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "MATRIXSETVIEW", matrix: _argument });
                    array_push(_values, 0);
                    break;
                }
                case function_ids.MATRIXSETPROJ:
                {
                    if (_arg_count != 1)
                    {
                        notify("MATRIXSETPROJ: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "MATRIXSETPROJ", matrix: _argument });
                    array_push(_values, 0);
                    break;
                }
                case function_ids.MATRIXBUILD:
                {
                    if (_arg_count != 9)
                    {
                        notify("MATRIXBUILD: EXPECTS 9 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, matrix_build(_argument, _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8]));
                    break;
                }
                case function_ids.MATRIXBUILDID:
                {
                    if (_arg_count != 0)
                    {
                        notify("MATRIXBUILDID: EXPECTS NO ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, matrix_build_identity());
                    break;
                }
                case function_ids.MATRIXBUILDLOOKAT:
                {
                    if (_arg_count != 9)
                    {
                        notify("MATRIXBUILDLOOKAT: EXPECTS 9 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, matrix_build_lookat(_argument, _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8]));
                    break;
                }
                case function_ids.MATRIXBUILDPROJORTHO:
                {
                    if (_arg_count != 4)
                    {
                        notify("MATRIXBUILDPROJORTHO: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, matrix_build_projection_ortho(_argument, _args[1], _args[2], _args[3]));
                    break;
                }
                case function_ids.MATRIXBUILDPROJPERS:
                {
                    if (_arg_count != 4)
                    {
                        notify("MATRIXBUILDPROJPERS: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, matrix_build_projection_perspective(_argument, _args[1], _args[2], _args[3]));
                    break;
                }
                case function_ids.MATRIXBUILDPROJPERSFOV:
                {
                    if (_arg_count != 4)
                    {
                        notify("MATRIXBUILDPROJPERSFOV: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, matrix_build_projection_perspective_fov(_argument, _args[1], _args[2], _args[3]));
                    break;
                }
                ///GRAPHICS
                case function_ids.LINE:
                {
                    if (_arg_count != 4)
                    {
                        notify("LINE: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "LINE", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.TRI:
                {
                    if (_arg_count != 6)
                    {
                        notify("TRI: EXPECTS 6 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "TRI", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3], x3:_args[4], y3:_args[5]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.RECT:
                {
                    if (_arg_count != 4)
                    {
                        notify("RECT: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "RECT", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.CIRC:
                {
                    if (_arg_count != 3)
                    {
                        notify("CIRC: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "CIRC", x1:_args[0], y1:_args[1], x2:_args[2]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.FTRI:
                {
                    if (_arg_count != 6)
                    {
                        notify("FTRI: EXPECTS 6 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "FTRI", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3], x3:_args[4], y3:_args[5]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.FRECT:
                {
                    if (_arg_count != 4)
                    {
                        notify("FRECT: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "FRECT", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.FCIRC:
                {
                    if (_arg_count != 3)
                    {
                        notify("FCIRC: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "FCIRC", x1:_args[0], y1:_args[1], x2:_args[2]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.DRAWSPRITE:
                {
                    if (_arg_count != 4)
                    {
                        notify("DRAWSPRITE: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "DRAWSPRITE", sprite:_args[0], frame:_args[1], x:_args[2], y:_args[3]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.SETDRAWCOLOR:
                {
                    if (_arg_count != 1)
                    {
                        notify("SETDRAWCOLOR: EXPECTS 1 COLOR ARGUMENT", true);
                        return 0;
                    }
                    
                    array_push(objSystem.program.graphics_build, {kind: "SETDRAWCOLOR", col:_args[0]});
                    array_push(_values, 0);
                    break;
                }
                case function_ids.MAKECOLORRGB:
                {
                    if (_arg_count != 3)
                    {
                        notify("MAKECOLORRGB: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, make_colour_rgb(_argument, _args[1], _args[2]));
                    break;
                }
                case function_ids.GETTIMER:
                {
                    if (_arg_count != 0)
                    {
                        notify("GETTIMER: EXPECTS NO ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, get_timer());
                    break;
                }
                case function_ids.KEYCHECK:
                {
                    if (_arg_count != 1)
                    {
                        notify("KEYCHECK: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    if(is_letter(_argument) || is_digit(_argument))
                    {
                        array_push(_values, keyboard_check(ord(_argument)));
                    }
                    break;
                }
                case function_ids.KEYCHECK_PRESSED:
                {
                    if (_arg_count != 1)
                    {
                        notify("KEYCHECK_PRESSED: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    if(is_letter(_argument) || is_digit(_argument))
                    {
                        array_push(_values, keyboard_check_pressed(ord(_argument)));
                    }
                    break;
                }
                case function_ids.KEYCHECK_RELEASED:
                {
                    if (_arg_count != 1)
                    {
                        notify("KEYCHECK_RELEASED: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    
                    if(is_letter(_argument) || is_digit(_argument))
                    {
                        array_push(_values, keyboard_check_released(ord(_argument)));
                    }
                    break;
                }
                ///BUFFERS
                case function_ids.BUFF_CREATE:
                {
                    if (_arg_count != 3)
                    {
                        notify("BUFF_CREATE: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, buffer_create(_argument, _args[1], _args[2]));
                    break;
                }
                case function_ids.BUFF_SEEK:
                {
                    if (_arg_count != 3)
                    {
                        notify("BUFF_SEEK: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    buffer_seek(_args[0], _args[1], _args[2]);
                    array_push(_values, 0);
                    break;
                }
                case function_ids.BUFF_PEEK:
                {
                    if (_arg_count != 3)
                    {
                        notify("BUFF_PEEK: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, buffer_peek(_args[0], _args[1], _args[2]));
                    break;
                }
                case function_ids.BUFF_READ:
                {
                    if (_arg_count != 2)
                    {
                        notify("BUFF_READ: EXPECTS 2 ARGUMENTS", true);
                        return 0;
                    }
                    
                    array_push(_values, buffer_read(_args[0], _args[1]));
                    break;
                }
                case function_ids.BUFF_WRITE:
                {
                    if (_arg_count != 3)
                    {
                        notify("BUFF_WRITE: EXPECTS 3 ARGUMENTS", true);
                        return 0;
                    }
                    
                    buffer_write(_args[0], _args[1], _args[2]);
                    array_push(_values, 0);
                    break;
                }
                case function_ids.BUFF_POKE:
                {
                    if (_arg_count != 4)
                    {
                        notify("BUFF_POKE: EXPECTS 4 ARGUMENTS", true);
                        return 0;
                    }
                    
                    buffer_poke(_args[0], _args[1], _args[2], _args[3]);
                    array_push(_values, 0);
                    break;
                }
                case function_ids.BUFF_DELETE:
                {
                    if (_arg_count != 1)
                    {
                        notify("BUFF_DELETE: EXPECTS 1 ARGUMENT", true);
                        return 0;
                    }
                    buffer_delete(_args[0])
                    array_push(_values, 0);
                    break;
                } 
                default:
                {
                    notify("UNKNOWN FUNCTION", true);
                    return 0;
                }
            }
        }
        else if (_token.kind == "UNARY" && _token.value == "NEG")
        {
            if (array_length(_values) < 1)
            {
                notify("LET EXPRESSION: MISSING OPERAND", true);
                return 0;
            }
        
            var _op = array_pop(_values);
            array_push(_values, 0 - _op);
        }
        else if (_token.kind == "SYMBOL" && is_expr_op(_token.value))
        {
            if (array_length(_values) < 2)
            {
                notify("LET EXPRESSION: MISSING OPERAND", true);
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
                        notify("LET EXPRESSION: DIVISION BY ZERO", true);
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
        notify("LET EXPRESSION: INVALID EXPRESSION", true);
        return 0;
    }
    
    return _values[0];
}

function split_arguments(_tokens, _start, _end)
{
    if(_start == _end)
    {
        return 
        {
            ok: true,
            parts: []
        }
    }
    
    var _parts = [];
    var _current = [];
    var _depth = 0;
    
    for(var _i = _start; _i < _end; _i++)
    {
        var _token = _tokens[_i];
        
        if(_token.kind == "SYMBOL" && _token.value == "(")
        {
            _depth ++;
            array_push(_current, _token);
        }
        else if(_token.kind == "SYMBOL" && _token.value == ")")
        {
            _depth --;
            if(_depth < 0)
            {
                return 
                {
                    ok: false,
                    parts: []
                }
            }
            array_push(_current, _token);
        }
        else if(_token.kind == "SYMBOL" && _token.value == "," && _depth == 0)
        {
            if(array_length(_current) == 0)
            {
                return 
                {
                    ok: false,
                    parts: []
                }
            }
            
            array_push(_parts, _current);
            _current = [];
        }
        else 
        {
            array_push(_current, _token);
        }
    }
    
    if(array_length(_current) == 0)
    {
        return 
        {
            ok: false,
            parts: []
        }
    }
    
    array_push(_parts, _current);
    return 
    {
        ok: true,
        parts: _parts
    }
}


///SYSTEM CALLS
function notify(_text, _halt = false)
{
    array_push(objSystem.program.errors, $"{_text}");
    var _content_height = 24 * array_length(objSystem.program.errors);
    var _max_scroll = max(0, _content_height - (window_get_height() - 615));
    objSystem.errors_scroll_y = clamp(objSystem.errors_scroll_y, 0, _max_scroll);
    if(_halt)
    {
        objSystem.running = false;
        objSystem.program.running = false;
    }
}

/// @returns {struct|undefined} the pixel top and height of a program line in the pane
function program_line_bounds(_line_num, _width)
{
    var _count = array_length(objSystem.program.lines);
    var _prefix = "";
    
    for (var _i = 0; _i < _count; _i++)
    {
        _prefix += (_prefix == "" ? "" : "\r\n") + objSystem.program.lines[_i];
        
        if (get_line_number(objSystem.program.lines[_i]) == _line_num)
        {
            var _line_h = string_height_ext(objSystem.program.lines[_i], 24, _width);
            var _end_h  = string_height_ext(_prefix, 24, _width);
            return { top: _end_h - _line_h, height: _line_h };
        }
    }

    return undefined;
}



function find_close_bracket(_tokens, _open)
{
    var _depth = 0;
    var _len = array_length(_tokens);
    
    for (var _i = _open; _i < _len; _i++)
    {
        var _t = _tokens[_i];
        if (_t.kind == "NEWLINE") return -1;
            
        if (_t.kind == "SYMBOL" && _t.value == "[") _depth++;
        else if (_t.kind == "SYMBOL" && _t.value == "]")
        {
            _depth--;
            if (_depth == 0) return _i;
        }
        
    }
    return -1;
}

function find_close_paren(_tokens, _open)
{
    var _depth = 0;
    var _len = array_length(_tokens);
    
    for (var _i = _open; _i < _len; _i++)
    {
        var _t = _tokens[_i];
        if (_t.kind == "NEWLINE") return -1;
            
        if (_t.kind == "SYMBOL" && _t.value == "(") _depth++;
        else if (_t.kind == "SYMBOL" && _t.value == ")")
        {
            _depth--;
            if (_depth == 0) return _i;
        }
        
    }
    return -1;
}
