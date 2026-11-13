typed_text = "";
program_text = "";
running = false;
viewing = false;
position = 1;
cursor = "_";
on = true;

call_later(1, time_source_units_seconds, function()
{
    on = !on;
}, true);

tasks = [];
program = new SCRIPT();
program.add_line("10 TYPE NEW TO BEGIN A NEW BASIC PROGRAM");
program.add_line("20 TYPE RUN TO RUN THE PROGRAM AND HIT ESCAPE TO GO BACK TO EDIT MODE");
back_task = -1;