/*
 * GMBASIC does not compile in the traditional sense, it packages your code with a special version of the interpreter.
 * This version of your code is still human readable, but editing it is a hassle, more importantly it's the precompiled tokens for the runtime!
 * The longest step of running a program is tokenization, so compiling removes that step!
 */


function compile()
{
    var _token_buff = buffer_create(16, buffer_grow, 1);
    var _tokens = tokenize(objSystem.program);
    var _output = json_stringify(_tokens);
    buffer_write(_token_buff, buffer_string, _output);
    buffer_save(_token_buff,"/MAIN.GBCOM");
    buffer_delete(_token_buff);
      
    var _file = get_save_filename_ext("", "", "", "Compile game to");
    directory_create(_file);
    directory_create(_file+"/assets/");
    directory_create(_file+"/assets/sprites/");
    
}

function load_GBCOM()
{
    if(file_exists("MAIN.GBCOM"))
    {
        objSystem.program = new SCRIPT();
        
        var _token_buff = buffer_load("MAIN.GBCOM");
        var _tokens = buffer_read(_token_buff, buffer_string);
        objSystem.program.tokens = json_parse(_tokens);
        
        var _fpath = program_directory;
        if(directory_exists(_fpath+"/assets/sprites/"))
        {
            var _file_name = file_find_first(_fpath+"/assets/sprites/*.json", fa_none);
            while (_file_name != "")
            {
                var _json_file = file_text_open_read(_fpath+"/assets/sprites/"+_file_name);
                var _json = json_parse(file_text_read_string(_json_file));
                
                objSystem.sprites[$ _json.name] = sprite_add(_json.source_path, _json.frames, false, false, 0, 0);
                objSystem.sprite_info[$ _json.name] = 
                {
                    name:_json.name,
                    source_path: _json.name+$"/assets/sprites/{_json.name}_{_json.frames}.png",
                    frames: _json.frames
                };
                notify($"SPRITE {_json.name} LOADED");
                file_text_close(_json_file);
                
                _file_name = file_find_next();
            }
            
            file_find_close();
        }
    }
}