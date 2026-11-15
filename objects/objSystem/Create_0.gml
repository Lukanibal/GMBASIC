typed_text = "";
program_text = "";
running = false;
viewing = false;
position = 1;
cursor = "_";
on = true;

program_scroll_y = 0;
program_scroll_speed = 36;

variables_scroll_y = 0;
variables_scroll_speed = 36;

///graphics api
graphics_color = c_white;


///RESERVED SYSTEM VARIABLES
RESERVED = 
{
    "KLEFT" : keyboard_check(vk_left),
    "KRIGHT" : keyboard_check(vk_right),
    "KUP" : keyboard_check(vk_up),
    "KDOWN" : keyboard_check(vk_down),
    "KSPACE" : keyboard_check(vk_space),
    "MX" : mouse_x - 10,
    "MY" : mouse_y - 10,
    "MLEFT" : mouse_check_button(mb_left),
    "MRIGHT" : mouse_check_button(mb_right),
}

call_later(0.5, time_source_units_seconds, function()
{
    on = !on;
}, true);

tasks = [];
program = new SCRIPT();
program.add_line("10 TYPE NEW TO BEGIN A NEW BASIC PROGRAM");
program.add_line("20 TYPE RUN TO RUN THE PROGRAM AND HIT ESCAPE TO GO BACK TO EDIT MODE");
back_task = -1;

row_length = 0;
var _row = "";
repeat(80)
{
    _row += "_";
}
row_length = string_width(_row);
ini_open("prefs.ini");

text_color = ini_read_real("SETTINGS", "TEXT", c_lime);
back_color = ini_read_real("SETTINGS", "BACK", c_black);

ini_close();

game_surface = surface_create(800, 600);
back_buffer = surface_create(800, 600);