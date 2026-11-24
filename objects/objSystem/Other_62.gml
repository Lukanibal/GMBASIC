var _id = async_load[? "id"];
var _status = async_load[? "status"];

var _len = array_length(async_callbacks);
for(var _i = 0; _i < _len; _i ++)
{
    if(async_callbacks[_i].id != _id)
    {
        continue;
    }
    
    if(_status == 0)
    {
        objSystem.program.variables[$ async_callbacks[_i].name] = async_load[? "result"];
        array_delete(async_callbacks, _i, 1);
    }
    else if(_status < 0)
    {
        notify("HTTP_GET ERROR");
        array_delete(async_callbacks, _i, 1);
    }
    
    break;
}