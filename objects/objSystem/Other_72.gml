var _id = async_load[? "id"];
var _status = async_load[? "status"];

var _len = array_length(zip_async_callbacks);
for(var _i = 0; _i < _len; _i ++)
{
    if(zip_async_callbacks[_i].id != _id)
    {
        continue;
    }
    
    if(_status == 0)
    {
        objSystem.program.variables[$ zip_async_callbacks[_i].name] = async_load[? "result"];
        array_delete(zip_async_callbacks, _i, 1);
    }
    else if(_status < 0)
    {
        notify("ZIP ERROR");
        array_delete(zip_async_callbacks, _i, 1);
    }
    
    break;
}