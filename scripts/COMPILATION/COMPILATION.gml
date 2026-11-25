/*
 * GMBASIC does not compile in the traditional sense, it packages your code with a special version of the interpreter.
 * This version of your code is still human readable, but editing it is a hassle, more importantly it's the precompiled tokens for the runtime!
 * The longest step of running a program is tokenization, so compiling removes that step!
 */


function compile()
{
    var _project_name = objSystem.project.filepath;
    var _file = get_save_filename_ext("", "", _project_name, "Compile game to");
    
    if(_file == "")
    {
        return;
    }
    
    directory_create(_file);
    
    file_copy("Runner/data.win", _file+"/data.win");
    file_copy("Runner/new_blank.exe", _file+$"/{objSystem.project.name}.exe");
    file_copy("Runner/options.ini", _file+"/options.ini");
    
    directory_create(_file+"/assets/");
    directory_create(_file+"/assets/sprites/");
    
    if(!directory_exists(_file+"/assets/sprites/"))
    {
        notify("COMPILE: COULD NOT CREATE " + _file, true);
        return;
    }
    
    var _token_buff = buffer_create(16, buffer_grow, 1);
    var _tokens = tokenize(objSystem.program);
    var _output = json_stringify(_tokens);
    buffer_write(_token_buff, buffer_string, _output);
    buffer_save(_token_buff, _file+"/MAIN.GBCOM");
    buffer_delete(_token_buff);
    
    var _source_dir = _project_name+"/assets/sprites/";
    var _target_dir = _file+"/assets/sprites/";
    
    if(directory_exists(_source_dir))
    {
        var _file_name = file_find_first(_source_dir+"*.json", fa_none);
        while (_file_name != "")
        {
            var _json_file = file_text_open_read(_source_dir+_file_name);
            var _json = json_parse(file_text_read_string(_json_file));
            file_text_close(_json_file);
            
            var _png_name = $"{_json.name}_{_json.frames}.png";
            if(file_exists(_source_dir+_png_name))
            {
                file_copy(_source_dir+_png_name, _target_dir+_png_name);
                file_copy(_source_dir+_file_name, _target_dir+_file_name);
                notify($"SPRITE {_json.name} MOVED");
            }
            
            _file_name = file_find_next();
        }
        
        file_find_close();
    }
}

function load_GBCOM()
{
    var _path = program_directory+"MAIN.GBCOM";
    
    if(!file_exists(_path))
    {
        return;
    }
    
    var _token_buff = buffer_load(_path);
    if(_token_buff == -1)
    {
        notify("LOAD: COULD NOT READ MAIN.GBCOM", true);
        return;
    }
    
    var _tokens = buffer_read(_token_buff, buffer_string);
    buffer_delete(_token_buff);
    
    objSystem.program = new SCRIPT();
    objSystem.program.tokens = json_parse(_tokens);
    objSystem.sprites = {};
    objSystem.sprite_info = {};
    
    var _sprite_dir = program_directory+"/assets/sprites/";
    if(directory_exists(_sprite_dir))
    {
        var _file_name = file_find_first(_sprite_dir+"*.json", fa_none);
        while (_file_name != "")
        {
            var _json_file = file_text_open_read(_sprite_dir+_file_name);
            var _json = json_parse(file_text_read_string(_json_file));
            file_text_close(_json_file);
            
            var _png_path = _sprite_dir+$"{_json.name}_{_json.frames}.png";
            var _sprite = sprite_add(_png_path, _json.frames, false, false, 0, 0);
            
            if(_sprite == -1)
            {
                notify($"SPRITE {_json.name} FAILED TO LOAD", true);
            }
            else
            {
                objSystem.sprites[$ _json.name] = _sprite;
                objSystem.sprite_info[$ _json.name] =
                {
                    name: _json.name,
                    source_path: _png_path,
                    frames: _json.frames
                };
                notify($"SPRITE {_json.name} LOADED");
            }
            
            _file_name = file_find_next();
        }
        
        file_find_close();
    }
}
