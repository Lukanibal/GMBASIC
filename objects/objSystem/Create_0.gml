typed_text = "";
program_text = "";
running = false;
viewing = false;
position = 1;
cursor = "_";
on = true;

project = -1;

program_scroll_y = 0;
program_scroll_speed = 36;

variables_scroll_y = 0;
variables_scroll_speed = 36;

errors_scroll_y = 0;
errors_scroll_speed = 36;

///graphics api
graphics_color = c_white;

sprites = {};
sprite_info = {};

can_delete = true;
can_move = true;

last_highlight_line = 0;
show_highlight = true;


global.COLORS = [c_black, c_white, c_maroon, c_red, c_green, c_lime, c_blue, c_aqua, c_orange, c_yellow, c_purple, c_fuchsia, c_silver, c_gray, c_navy, c_teal];
///RESERVED SYSTEM VARIABLES
/// 
function SPECIAL() constructor 
{
    WORDS = 
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
        "PI" : pi,
        "TAU" : pi * 2,
        "EUL" : 2.718281828459045,
        "BLACK": c_black,
        "WHITE": c_white,
        "MAROON": c_maroon,
        "RED": c_red,
        "GREEN": c_green,
        "LIME": c_lime,
        "BLUE": c_blue,
        "AQUA": c_aqua,
        "ORANGE": c_orange,
        "YELLOW": c_yellow,
        "PURPLE": c_purple,
        "FUCHSIA": c_fuchsia,
        "SILVER": c_silver,
        "GRAY" : c_gray,
        "NAVY" : c_navy,
        "TEAL" : c_teal,
        "BUFF_FIXED": buffer_fixed,
        "BUFF_GROW" : buffer_grow,
        "BUFF_WRAP" : buffer_wrap,
        "BUFF_FAST" : buffer_fast
    }
}

RESERVED = new SPECIAL();

call_later(0.5, time_source_units_seconds, function()
{
    on = !on;
}, true);

tasks = [];
program = new SCRIPT();
program.add_line("10 TYPE NEW TO BEGIN A NEW BASIC PROGRAM");
program.add_line("20 TYPE RUN OR HIT F5 TO RUN THE PROGRAM\nAND HIT ESCAPE TO GO BACK TO EDIT MODE");
back_task = -1;

row_length = 0;
var _row = "";
repeat(80)
{
    _row += "_";
}
row_length = string_width(_row);
ini_open("prefs.ini");

text_color = ini_read_real("SETTINGS", "TEXT", c_white);
back_color = ini_read_real("SETTINGS", "BACK", c_blue);

ini_close();

game_surface = surface_create(800, 600);
back_buffer = surface_create(800, 600);

if(room == rmRunnerOnly && program.lines[0] == "10 TYPE NEW TO BEGIN A NEW BASIC PROGRAM")
{
    load_project(true);
}