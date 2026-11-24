///This is the project file system, be carefule messing around in here!
/// 
function PROJECT(_name = "NEW PROJECT", _filepath = "", _exists = false) constructor
{
    name = _name;
    filepath = _filepath;
    version = 1.0;
    
    to_file = function()
    {
        var _file = file_text_open_write(filepath + "/MAIN.BAS");
        if (_file == -1)
        {
            notify("PROJECT: COULD NOT WRITE " + filepath + "/MAIN.BAS", true);
            return;
        }
        
        var _len = array_length(objSystem.program.lines);
        var _i = 0;
        while(_i < _len)
        {
            file_text_write_string(_file, objSystem.program.lines[_i]);
            file_text_writeln(_file);
            _i ++;
        }
        file_text_close(_file);
        
        _file = file_text_open_write(filepath + "/MAIN.GMBP");
        if (_file == -1)
        {
            notify("PROJECT: COULD NOT WRITE " + filepath + "/MAIN.GMBP", true);
            return;
        }
        
        file_text_write_string(_file, json_stringify({name: name, filepath: filepath, version: version}));
        file_text_writeln(_file);
        file_text_close(_file);
    }
    
    if(_exists)
    {
        return;
    }
    
    if (filepath == "")
    {
        notify("PROJECT: NO FILEPATH GIVEN", true);
        return;
    }
    
    directory_create(filepath);
    directory_create(filepath + "/assets");
    directory_create(filepath + "/assets/sprites");
    
    if (!directory_exists(filepath))
    {
        notify("PROJECT: COULD NOT CREATE " + filepath, true);
        return;
    }
    
    objSystem.program = new SCRIPT();
    objSystem.sprites = {};
    objSystem.sprite_info = {};
    
    
    to_file();
}