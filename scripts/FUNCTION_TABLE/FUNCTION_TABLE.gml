global.function_names = [];

///MATH LIBRARY
array_push(global.function_names, "SQRT");
array_push(global.function_names, "ABS");
array_push(global.function_names, "COS");
array_push(global.function_names, "SIN");
array_push(global.function_names, "TAN");
array_push(global.function_names, "MAX");
array_push(global.function_names, "MIN");
array_push(global.function_names, "FLOOR");
array_push(global.function_names, "CEIL");
array_push(global.function_names, "ROUND");
array_push(global.function_names, "SIGN");
array_push(global.function_names, "ARCTAN");
array_push(global.function_names, "ARCTAN2");
array_push(global.function_names, "SQR");
array_push(global.function_names, "RANDOM");
array_push(global.function_names, "POW");
array_push(global.function_names, "LOG");
array_push(global.function_names, "CLAMP");
array_push(global.function_names, "LERP");
array_push(global.function_names, "LENGTHDIRX");
array_push(global.function_names, "LENGTHDIRY");
array_push(global.function_names, "LENGTHDIRZ");
array_push(global.function_names, "POINTDIR");
array_push(global.function_names, "POINTDIST");
array_push(global.function_names, "POINTDIST3D");
array_push(global.function_names, "MOD");
array_push(global.function_names, "DIV");
array_push(global.function_names, "FRAC");
array_push(global.function_names, "RAD");
array_push(global.function_names, "DEG");


///MATRIX LIBRARY
array_push(global.function_names, "MATRIXSETWORLD");
array_push(global.function_names, "MATRIXSETVIEW");
array_push(global.function_names, "MATRIXSETPROJ");

array_push(global.function_names, "MATRIXBUILD");
array_push(global.function_names, "MATRIXBUILDID");
array_push(global.function_names, "MATRIXBUILDLOOKAT");
array_push(global.function_names, "MATRIXBUILDPROJORTHO");
array_push(global.function_names, "MATRIXBUILDPROJPERS");
array_push(global.function_names, "MATRIXBUILDPROJPERSFOV");

///GRAPHICS LIBRARY (finally porting to new language paradigm)
array_push(global.function_names, "LINE");
array_push(global.function_names, "TRI");
array_push(global.function_names, "RECT");
array_push(global.function_names, "CIRC");
array_push(global.function_names, "FTRI");
array_push(global.function_names, "FRECT");
array_push(global.function_names, "FCIRC");
array_push(global.function_names, "DRAWSPRITE");
array_push(global.function_names, "SETDRAWCOLOR");
array_push(global.function_names, "MAKECOLORRGB");

///TIME AND TIMERS
array_push(global.function_names, "GETTIMER");

//INPUT
array_push(global.function_names, "KEYCHECK");
array_push(global.function_names, "KEYCHECK_PRESSED");
array_push(global.function_names, "KEYCHECK_RELEASED");


///BUFFERS
array_push(global.function_names, "BUFF_CREATE");
array_push(global.function_names, "BUFF_SEEK");
array_push(global.function_names, "BUFF_PEEK");
array_push(global.function_names, "BUFF_READ");
array_push(global.function_names, "BUFF_WRITE");
array_push(global.function_names, "BUFF_POKE");



            
            /*//OLD PARSER! DO NOT UPDATE!
            
*/

function old_parser()
{
    if (_func == "SQRT")
            {
                
            }
            if (_func == "SQR")
            {
                array_push(_values, sqr(_argument));
            }
            if (_func == "ABS")
            {
                
            }
            if (_func == "SIGN")
            {
                array_push(_values, sign(_argument));
            }
            if (_func == "COS")
            {
                array_push(_values, cos(_argument));
            }
            if (_func == "TAN")
            {
                array_push(_values, tan(_argument));
            }
            if (_func == "SIN")
            {
                array_push(_values, sin(_argument));
            }
            if (_func == "FLOOR")
            {
                array_push(_values, floor(_argument));
            }
            if (_func == "CEIL")
            {
                array_push(_values, ceil(_argument));
            }
            if (_func == "ROUND")
            {
                array_push(_values, round(_argument));
            }
            if (_func == "ARCTAN")
            {
                array_push(_values, arctan(_argument));
            }
            if(_func == "ARCTAN2")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: ARCTAN2 EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, arctan2(_argument, _args[1]));
            }
            if (_func == "RANDOM")
            {
                array_push(_values, irandom(_argument));
            }
            if (_func == "FRAC")
            {
                array_push(_values, frac(_argument));
            }
            if(_func == "POW")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: POW EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, power(_argument, _args[1]));
            }
            if(_func == "LOG")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: LOG EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, logn(_argument, _args[1]));
            }
            if(_func == "MIN")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: MIN EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, min(_argument, _args[1]));
            }
            if(_func == "MAX")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: MAX EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, max(_argument, _args[1]));
            }
            if(_func == "CLAMP")
            {
                if(_arg_count != 3)
                {
                    notify("FUNCTION: CLAMP EXPECTS 3 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, clamp(_argument, _args[1], _args[2]));
            }
            if(_func == "MOD")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: MOD EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, _argument mod _args[1]);
            }
            if(_func == "DIV")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: DIV EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, _argument div _args[1]);
            }
            if(_func == "LERP")
            {
                if(_arg_count != 3)
                {
                    notify("FUNCTION: LERP EXPECTS 3 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, lerp(_argument, _args[1], _args[2]));
            }
            if(_func == "RAD")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: RAD EXPECTS 1 ARGUMENT", true);
                    return 0;
                }
                
                array_push(_values, degtorad(_argument));
            }
            if(_func == "DEG")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: DEG EXPECTS 1 ARGUMENT", true);
                    return 0;
                }
                
                array_push(_values, radtodeg(_argument));
            }
            if(_func == "LENGTHDIRX")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: LENGTHDIRX EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, lengthdir_x(_argument, _args[1]));
            }
            if(_func == "LENGTHDIRY")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: LENGTHDIRY EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, lengthdir_y(_argument, _args[1]));
            }
            if(_func == "LENGTHDIRZ")
            {
                if(_arg_count != 2)
                {
                    notify("FUNCTION: LENGTHDIRZ EXPECTS 2 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, lengthdir_z(_argument, _args[1]));
            }
            if(_func == "POINTDIR")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: PONTDIR EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, point_direction(_argument, _args[1], _args[2], _args[3]));
            }
            if(_func == "POINTDIST")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: PONTDIST EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, point_distance(_argument, _args[1], _args[2], _args[3]));
            }
            if(_func == "POINTDIST3D")
            {
                if(_arg_count != 6)
                {
                    notify("FUNCTION: PONTDIST3D EXPECTS 6 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, point_distance_3d(_argument, _args[1], _args[2], _args[3], _args[4], _args[5]));
            }
            if(_func == "MATRIXSETWORLD")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: MATRIXSETWORLD EXPECTS 1 ARGUMENT", true);
                    return 0;
                }
                show_debug_message("MATRIX SET WORLD!")
                array_push(objSystem.program.graphics_build, {kind: "MATRIXSETWORLD", matrix: _argument });
                array_push(_values, 0);
                //matrix_set(matrix_world, _argument);
            }
            if(_func == "MATRIXSETVIEW")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: MATRIXSETVIEW EXPECTS 1 ARGUMENT", true);
                    return 0;
                }
                array_push(objSystem.program.graphics_build, {kind: "MATRIXSETVIEW", matrix: _argument });
                array_push(_values, 0);
                //matrix_set(matrix_view, _argument);
            }
            if(_func == "MATRIXSETPROJ")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: MATRIXSETPROJ EXPECTS 1 ARGUMENT", true);
                    return 0;
                }
                array_push(objSystem.program.graphics_build, {kind: "MATRIXSETPROJ", matrix: _argument });
                array_push(_values, 0);
                
                //matrix_set(matrix_projection, _argument);
            }
            if(_func == "MATRIXBUILD")
            {
                if(_arg_count != 9)
                {
                    notify("FUNCTION: MATRIXBUILD EXPECTS 9 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, matrix_build(_argument, _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8]));
            }
            if(_func == "MATRIXBUILDID")
            {
                if(_arg_count != 0)
                {
                    notify("FUNCTION: MATRIXBUILDID EXPECTS NO ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, matrix_build_identity());
            }
            if(_func == "MATRIXBUILDLOOKAT")
            {
                if(_arg_count != 9)
                {
                    notify("FUNCTION: MATRIXBUILDLOOKAT EXPECTS 9 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, matrix_build_lookat(_argument, _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8]));
            }
            if(_func == "MATRIXBUILDPROJPERS")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: MATRIXBUILDPROJPERS EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, matrix_build_projection_perspective(_argument, _args[1], _args[2], _args[3]));
            }
            if(_func == "MATRIXBUILDPROJORTHO")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: MATRIXBUILDPROJORTHO EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, matrix_build_projection_ortho(_argument, _args[1], _args[2], _args[3]));
            }
            if(_func == "MATRIXBUILDPROJPERSFOV")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: MATRIXBUILDPROJPERS EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, matrix_build_projection_perspective_fov(_argument, _args[1], _args[2], _args[3]));
            }
            ///GRAPHICS
            if(_func == "LINE")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: LINE EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "LINE", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3]});
                array_push(_values, 0);
            }
            if(_func == "TRI")
            {
                if(_arg_count != 6)
                {
                    notify("FUNCTION: TRI EXPECTS 6 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "TRI", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3], x3:_args[4], y3:_args[5]});
                array_push(_values, 0);
            }
            if(_func == "FTRI")
            {
                if(_arg_count != 6)
                {
                    notify("FUNCTION: FTRI EXPECTS 6 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "FTRI", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3], x3:_args[4], y3:_args[5]});
                array_push(_values, 0);
            }
            if(_func == "RECT")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: RECT EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "RECT", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3]});
                array_push(_values, 0);
            }
            if(_func == "FRECT")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: RECT EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "FRECT", x1:_args[0], y1:_args[1], x2:_args[2], y2:_args[3]});
                array_push(_values, 0);
            }
            if(_func == "CIRC")
            {
                if(_arg_count != 3)
                {
                    notify("FUNCTION: RECT EXPECTS 3 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "CIRC", x1:_args[0], y1:_args[1], x2:_args[2]});
                array_push(_values, 0);
            }
            if(_func == "FCIRC")
            {
                if(_arg_count != 3)
                {
                    notify("FUNCTION: RECT EXPECTS 3 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "FCIRC", x1:_args[0], y1:_args[1], x2:_args[2]});
                array_push(_values, 0);
            }
            if(_func == "SETDRAWCOLOR")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: SETDRAWCOLOR EXPECTS 1 COLOR ARGUMENT", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "SETDRAWCOLOR", col:_args[0]});
                array_push(_values, 0);
            }
            if(_func == "DRAWSPRITE")
            {
                if(_arg_count != 4)
                {
                    notify("FUNCTION: DRAWSPRITE EXPECTS 4 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(objSystem.program.graphics_build, {kind: "DRAWSPRITE", sprite:_args[0], frame:_args[1], x:_args[2], y:_args[3]});
                array_push(_values, 0);
            }
            if(_func == "MAKECOLORRGB")
            {
                if(_arg_count != 3)
                {
                    notify("FUNCTION: MAKECOLORRGB EXPECTS 3 ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, make_colour_rgb(_args[0], _args[1], _args[2]));
            }
            if(_func == "GETTIMER")
            {
                if(_arg_count != 0)
                {
                    notify("FUNCTION: GETTIMER EXPECTS NO ARGUMENTS", true);
                    return 0;
                }
                
                array_push(_values, get_timer());
            }
            if(_func == "KEYCHECK")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: KEYCHECK EXPECTS 1 ARGUMENT", true);
                    return 0;
                }
                
                if(is_letter(_argument) || is_digit(_argument))
                array_push(_values, keyboard_check(ord(_argument)));
            }
            else
            if(_func == "KEYCHECK_PRESSED")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: KEYCHECK_PRESSED EXPECTS 1 ARGUMENT", true);
                    return 0;
                }
                
                if(is_letter(_argument) || is_digit(_argument))
                array_push(_values, keyboard_check_pressed(ord(_argument)));
            }
            else
            if(_func == "KEYCHECK_RELEASED")
            {
                if(_arg_count != 1)
                {
                    notify("FUNCTION: KEYCHECK_RELEASED EXPECTS 1 ARGUMENT", true);
                    return 0;
                }
                
                if(is_letter(_argument) || is_digit(_argument))
                array_push(_values, keyboard_check_released(ord(_argument)));
            } 
            else
            ///BUFFERS
            if(_func == "BUFF_CREATE")
            {
                if(_arg_count != 3)
                {
                    notify("FUNCTION: BUFF_CREATE EXPECTS 3 ARGUMENTS", true);
                    return 0;
                }
                
                
                array_push(_values, buffer_create(_args[0], _args[1], _args[2]));
            }
            else
            if(_func == "BUFF_CREATE")
            {
                if(_arg_count != 3)
                {
                    notify("FUNCTION: BUFF_CREATE EXPECTS 3 ARGUMENTS", true);
                    return 0;
                }
                
                
                array_push(_values, buffer_create(_args[0], _args[1], _args[2]));
            
            
        }
}



