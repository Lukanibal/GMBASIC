///Thie is the project file system, be carefule messing around in here!
/// 

function PROJECT(_name = "NEW PROJECT") constructor
{
    directory_create(_name);
    directory_create(_name+"/assets");
    directory_create(_name+"/assets/sprites");
    name = _name;
    version = 1.0;
    objSystem.program = new SCRIPT();
    objSystem.program.add_line("10 PRINT \"HELLO WORLD!\"");
    objSystem.program.add_line("20 GOTO 10");
    objSystem.sprites = {};
    objSystem.sprite_info = {};
    
    
    to_file = function()
    {
        var _file = file_text_open_write(name+"/MAIN.BAS");
        var _len = array_length(objSystem.program.lines);
        var _i = 0;
        while(_i < _len)
        {
            file_text_write_string(_file, objSystem.program.lines[_i]);
            file_text_writeln(_file);
            _i ++;
        }
        file_text_close(_file);
    }
     
    to_file(); 
    
}