vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_colour();
vertex_format_add_texcoord();
global.default_vertex_format = vertex_format_end();

show_debug_message($"NO CULL:{cull_noculling}//CLOCKWISE CULL:{cull_clockwise}//COUNTERCLOCKWISE CULL:{cull_counterclockwise}");
clipboard_set_text($"NO CULL:{cull_noculling}//CLOCKWISE CULL:{cull_clockwise}//COUNTERCLOCKWISE CULL:{cull_counterclockwise}");