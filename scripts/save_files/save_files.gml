///This is the project file system, be carefule messing around in here!
/// 

function PROJECT(_name = "NEW PROJECT", _filepath = "") constructor
{
    directory_create(_filepath);
    directory_create(_filepath+"/assets");
    directory_create(_filepath+"/assets/sprites");
    name = _name;
    filepath = _filepath;
    version = 1.0;
    objSystem.program = new SCRIPT();
    objSystem.program.add_line("10 PRINT \"HELLO WORLD!\"");
    objSystem.program.add_line("20 GOTO 10");
    objSystem.sprites = {};
    objSystem.sprite_info = {};
    
    
    to_file = function()
    {
        var _file = file_text_open_write(filepath+"/MAIN.BAS");
        var _len = array_length(objSystem.program.lines);
        var _i = 0;
        while(_i < _len)
        {
            file_text_write_string(_file, objSystem.program.lines[_i]);
            file_text_writeln(_file);
            _i ++;
        }
        file_text_close(_file);
        
        _file = file_text_open_write(filepath+$"/{name}.GMBP");
        file_text_write_string(_file, json_stringify(self));
        file_text_writeln(_file);
        file_text_close(_file);
    }
     
    to_file(); 
    
}