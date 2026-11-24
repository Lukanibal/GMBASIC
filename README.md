![GMBASIC Logo](options/main/template_icon.png)
# GMBASIC Language Reference
CURRENT LANGUAGE SPEC AS OF v26.11.24.0

A LIVE DEMO OF GMBASIC CAN BE FOUND ON ITCH.IO, YOU CAN ALSO DOWNLOAD A WINDOWS BUILD OF IT [HERE!](https://lukanspellweaver.itch.io/gmbasic)

## GMBASIC Syntax

```basic
LET X = 5
```
Assigns the value `5` to the variable `X`.

### Variable Name Rules  
Variable names must start with a letter and contain letters, digits, and underscores `_`.

```basic
PRINT "HELLO WORLD"
```
Prints `HELLO WORLD` to the console. `PRINT` also accepts variables and arrays.  
This will NOT print a NEWLINE at the end.

`IF` `THEN` `ELSE` are supported, but only accept `GOTO` for `THEN` and `ELSE`, so  
```basic
IF X = 1 THEN GOTO 100 ELSE GOTO 200
```
ELSE is optional. With no ELSE, a false condition falls through to the next line.  

`GOTO <LINE NUMBER>` is also supported for _BASIC_ loops, `<LINE NUMBER>` MUST be a literal number and not a variable!  

`END` Ends the program  
## Editor Commands  

The Editor itself has some useful commands that cannot be used in a BASIC program.  
|COMMAND | Description |
|---|---|
|`HELP` or `?`|Opens the manual in your default browser, you do need to be online!|
|`RUN`| Runs the program to its natural end, til an `END` statement is reached, or ad infinitum via a `GOTO` loop.|
|`SAVE`| Saves the current `PROJECT`|
|`LOAD`| Load a `PROJECT`, if no assets folder is found, then only `MAIN.BAS` will be loaded.|
|`COPY`| Copy the entire program into the clipboard|
|`COPY <LINENUMBER>`| Copy the line at `<LINENUMBER>` to the typing field and the clipboard.|
|`PASTE`| Paste a full program from your clipboard into the program register.|
|`SPRITE <NAME> [FRAMES]`| Opens the Windows File Dialog to load a .PNG file into the `PROJECT` as a `SPRITE`. The `SPRITE` can be referenced in drawing functions by `<NAME>` you can optionally tell the engine how many `FRAMES` there are and it will cut the image into that many horizontal slices with each slice being a `FRAME`, the `SPRITE`'s origin for drawing is always (0, 0), or it's TOP LEFT corner.|
|`TEXTCOLOR <COLORNAME>`| Set the IDE TEXT COLOR.|
|`BACKGROUND <COLORNAME>`| Set the IDE BACKGROUND COLOR.|
|`AUTO <NUMBER>`| Will fill from 10 to `<NUMBER>` with blank lines in `10` line increments.|

The `F5` key is a nifty `RUN` shortcut!   
`ESCAPE` will halt the runner, and `F5` or `RUN` will continue it.

## Constants and Reserved Words 
The following words cannot be used as variable names as they are reserved by the system, it will not stop you from trying to set them, but the reserved system value will always be returned.  
All FUNCTION names are also reserved.

|Constant | Description |
|---|---|
|`PI`| 3.14....|
|`TAU`| PI * 2(6.28....)|
|`EUL`| 2.718281828459045| 

`EUL` is usually expressed as `E` in settings like these, but stealing a letter of the alphabet from use as a variable name felt rude.

## Types
|Type | Description |
|---|---|
|`STRING`|"THIS IS A STRING"|
|`NUMBER`| `420`, `69.420`, and `-69` are all `NUMBERS`.|
|`ARRAY`| `A(9)` accesses the 10th position in the array assigned to `A`.|
|`SPRITE`| Loading images via the `SPRITE` command creates a `SPRITE`.|

Strings can have a NEWLINE character inserted via `\N`, you may also add numbers to strings, they will convert to a string automagically and be appended to the string accordingly.

## Arrays
The following is basic array syntax
```basic
LET X = 5
DIM A(9)
LET A(0) = X
```
Arrays have a limit of `1000000` or `ONE MILLION` entries currently.
Arrays can be maniuplated by the following functions:
| Function | Description |
|---|---|
|`ARRAY_PUSH(ARRAY, VALUE)`|Adds a new entry to the end of `ARRAY` and sets it to `VALUE`|  
|`ARRAY_POP(ARRAY)`|Returns the value at the end of `ARRAY` and removes it from `ARRAY`|  
|`ARRAY_SHIFT(ARRAY)`|Returns the value at the start of `ARRAY` and removes it from `ARRAY`|  
|`ARRAY_SHUFFLE(ARRAY)`|Shuffles the values of `ARRAY`|  

## Math
Simple expressions can be done via the `LET` command, for example
```basic
10 LET X = 10 + 2
```
Will make `X = 12` and so forth.  
Mixed with the math commands below, you can perform more complex calculations.

## Operators 
| OPERATOR | Description |
|---|---|
|`=`|Assigns in LET, compares everywhere else. Works on strings too!|
|`<>`|Not equal to. Gives `1` if the two values are different, otherwise `0`.|
|`<`|Less than. Gives `1` if the left value is smaller than the right, otherwise `0`.|
|`>`|Greater than. Gives `1` if the left value is larger than the right, otherwise `0`.|
|`<=`|Less than or equal to. Gives `1` if the left value is smaller than or equal to the right, otherwise `0`.|
|`>=`|Greater than or equal to. Gives `1` if the left value is larger than or equal to the right, otherwise `0`.|
|`+`|Adds `NUMBERS`. If either side is a `STRING`, joins the two sides together as text instead.|
|`-`|Subtract `NUMBERS` or unary negation.|
|`*`|Multiply `NUMBERS`.|
|`/`|Divide `NUMBERS`. Dividing by `0` shows an error.|

Operators are evaluated in this order, from first to last: `*` and `/`, then `+` and `-`, then the comparisons. Use parentheses to change the order.  
There is no `AND`, `OR` or `NOT` yet, so to test two conditions at once, use two `IF` lines.



>[!NOTE]
>Functions will work anywhere an expression does, such as `PRINT SQRT(16)`. 

| Function | Description |
|---|---|
| `SQR(X)` | Returns the square of `X`. |  
| `SQRT(X)` | Returns the square root of `X`. |  
| `ABS(X)` | Returns the absolute value of `X`. |  
| `SIN(X)` | Returns the sine of `X` (in radians). |  
| `COS(X)` | Returns the cosine of `X` (in radians). |  
| `TAN(X)` | Returns the tangent of `X` (in radians). |  
| `FLOOR(X)` | Returns the largest integer less than or equal to `X`. |  
| `CEIL(X)` | Returns the smallest integer greater than or equal to `X`. |  
| `ROUND(X)` | Returns `X` rounded to the nearest integer. |  
| `SIGN(X)` | Returns `-1` if `X` is negative, `0` if `X` is zero, and `1` if `X` is positive. |  
| `ARCTAN(X)` | Returns the arctangent of `X` (in radians). |  
| `ARCTAN2(Y, X)` | Returns the arctangent of `Y/X` (in radians). |  
| `POW(X, Y)` | Returns `X` raised to the power of `Y`. |  
| `LOG(X, Y)` | Returns the logarithm of `Y` with base `X`. |  
| `CLAMP(X, MIN, MAX)` | Clamps a value between a minimum and maximum range. |  
| `LERP(A, B, T)` | Linearly interpolates between `A` and `B` by `T`. |  
| `MOD(X, Y)` | Returns the remainder of `X` divided by `Y`. |  
| `DIV(X, Y)` | Returns the integer division of `X` by `Y`. |  
| `MIN(X, Y)` | Returns the minimum of X and Y. |  
| `MAX(X, Y)` | Returns the maximum of X and Y. |  
| `FRAC(X)`| Returns the fractional part of X. |  
| `RANDOM(X)`| Returns a random number from 0 to X|  
| `POINTDIR(X1, Y1, X2, Y2)` | Returns the direction from point `(X1, Y1)` to point `(X2, Y2)` in degrees. |  
| `POINTDIST(X1, Y1, X2, Y2)` | Returns the distance from point `(X1, Y1)` to point `(X2, Y2)` in pixels. |
| `POINTDIST3D(X1, Y1, Z1, X2, Y2, Z2)` | Returns the distance from point `(X1, Y1, Z1)` to point `(X2, Y2, Z2)` in pixels. |  
| `LENGTHDIRX(L, D)` | Returns the X component of a vector with length `L` and direction `D` (in degrees). |  
| `LENGTHDIRY(L, D)` | Returns the Y component of a vector with length `L` and direction `D` (in degrees). |  
| `LENGTHDIRZ(L, P)` | Returns the Z (vertical) component of a vector with length `L` and pitch `P`, in degrees. A pitch of 0 is level (returns 0), 90 is straight up (returns L), and -90 is straight down (returns -L). |  
| `RAD(X)`| Turns degrees to radians. |  
| `DEG(X)`| Turns radians to degrees. |  
> [!NOTE]
> `SIN`, `COS` and `TAN` use radians, but `LENGTHDIR*` and `POINTDIR` use degrees.

## Matrix
| Function | Description |
|---|---|
| `MATRIXSETWORLD(MATRIX)`| Sets the current world transformation matrix to `MATRIX`.|
| `MATRIXSETVIEW(MATRIX)` | Sets the current view transformation matrix to `MATRIX`.|
| `MATRIXSETPROJ(MATRIX)` | Sets the current projection transformation matrix to `MATRIX`.|
| `MATRIXBUILD(X, Y, Z, ROTX, ROTY, ROTZ, SCALEX, SCALEY, SCALEZ)` | Builds a transformation matrix with translation `(X, Y, Z)`, rotation `(ROTX, ROTY, ROTZ)` in degrees, and scaling `(SCALEX, SCALEY, SCALEZ)`.|
| `MATRIXBUILDID()` | Returns an identity matrix.|
| `MATRIXBUILDLOOKAT(XFROM, YFROM, ZFROM, XTO, YTO, ZTO, XUP, YUP, ZUP)`| Builds a look-at matrix for a camera positioned at `(XFROM, YFROM, ZFROM)`, looking at `(XTO, YTO, ZTO)`, with an up vector of `(XUP, YUP, ZUP)`.|
| `MATRIXBUILDPROJORTHO(WIDTH, HEIGHT, ZNEAR, ZFAR)` | Builds an orthographic projection matrix with the specified width, height, near plane, and far plane. |
| `MATRIXBUILDPROJPERS(WIDTH, HEIGHT, ZNEAR, ZFAR)` | Builds a perspective projection matrix with the specified view width, view height, near plane, and far plane. |
| `MATRIXBUILDPROJPERSFOV(FOVY, ASPECT, ZNEAR, ZFAR)` | Builds a perspective projection matrix with the specified field of view (in degrees), aspect ratio, near plane, and far plane. |

>[!NOTE] Matrix setters apply to everything drawn after them in the same frame, so call them after `CLS`.

Shows a spinning triangle and 3D logic:  
```basic
10 LET ASPECT = 4 / 3
20 LET P = MATRIXBUILDPROJPERSFOV(60, ASPECT, 1, 1000)
30 LET CAMZ = 0 - 200
40 LET V = MATRIXBUILDLOOKAT(0, 0, CAMZ, 0, 0, 0, 0, 1, 0)
50 LET L = 0 - 50
60 LET B = 0 - 40
70 LET ANGLE = 0
80 CLS
90 MATRIXSETPROJ(P)
100 MATRIXSETVIEW(V)
110 LET W = MATRIXBUILD(0, 0, 0, 0, ANGLE, 0, 1, 1, 1)
120 MATRIXSETWORLD(W)
130 SETDRAWCOLOR(ORANGE)
140 FTRI(L, B, 50, B, 0, 40)
150 LET ANGLE = MOD(ANGLE + 2, 360)
160 VSYNC
170 GOTO 80
```
> [!NOTE]
> In 3D mode with this camera setup, +Y is up and the camera looks toward +Z. This is the reverse of the 2D screen, where Y increases downward.

## Graphics
Graphics calls accept VARIABLES, ARRAYED VARIABLES `X(3)`, and EXPRESSIONS as arguments.  
The default draw color is `WHITE`, and the set draw color persists across `CLS` calls.  
The CANVAS is `800 X 600` pixels, the ORIGIN is the TOP LEFT corner which is `0, 0`  
The Y Vector INCREASES down the screen.  
| Function | Description |
|---|---|
| `SETDRAWCOLOR(COLOR)`| Sets the color for all subsequent graphics functions to `COLOR`, must be a `COLOR` constant, not a variable|
| `LINE(X1, Y1, X2, Y2)`| Draws a line from point `(X1, Y1)` to point `(X2, Y2)`|
| `RECT(X1, Y1, X2, Y2)`| Draws a rectangle outline from  top left point `(X1, Y1)` to bottom right point `(X2, Y2)`|
| `FRECT(X1, Y1, X2, Y2)`| Draws a filled rectangle from  top left point `(X1, Y1)` to bottom right point `(X2, Y2)`|
| `CIRC(X, Y, R)`| Draws a circle outline at `(X, Y)` with a radius of `R`|
| `FCIRC(X, Y, R)`| Draws a filled circle at `(X, Y)` with a radius of `R`|
| `TRI(X1, Y1, X2, Y2, X3, Y3)`| Draws a triangle outline with the points at `(X1, Y1)`, `(X2, Y2)`, and `(X3, Y3)` respectively|
| `FTRI(X1, Y1, X2, Y2, X3, Y3)`| Draws a filled triangle with the points at `(X1, Y1)`, `(X2, Y2)`, and `(X3, Y3)` respectively|
| `MAKECOLORRGB(R, G, B)`| Returns a color with the rbg values set to `RGB` respectivly.|

### Drawing Sprites  
The following functions can be used to display art loaded into GMBASIC via the `SPRITE` command:  
| Function | Description |
|---|---|
| `DRAWSPRITE(SPRITE, FRAME, X, Y)`| Draws frame `FRAME` of the `SPRITE` at `(X, Y)`. Frames start at `0`.|
| `DRAWSPRITE_EXT(SPRITE, FRAME, X, Y, XSCALE, YSCALE, ROTATION, COLOR, ALPHA) `| Draws frame `FRAME` of `SPRITE` at position `(X, Y)`. `XSCALE` and `YSCALE` control horizontal and vertical size multiplicatively; for example, `2` doubles the size. `ROTATION` starts at `0` and goes counter clockwise in degrees, the origin point is always `(X, Y)`. `COLOR` is the draw color to use for the image, this overrules the set draw color in the program. `ALPHA` is the transparency of the image. Frames start at `0`. |
| `DRAWSPRITE_POS(SPRITE, FRAME, X1, Y1, X2, Y2, X3, Y3, X4, Y4, ALPHA)`| Draws frame `FRAME` of the `SPRITE` distorted over `(X1, Y1)`, `(X2, Y2)`, `(X3, Y3)`, and `(X4, Y4)`. `ALPHA` is the transparency of the image. Frames start at `0`.|
| `DRAWSPRITE_STRETCHED(SPRITE, FRAME, X, Y, WIDTH, HEIGHT)`| Draws frame `FRAME` of the `SPRITE` at `(X, Y)` stretched to be `WIDTH` x `HEIGHT`. Frames start at `0`.|


## Colors
There are 16 colors that come packaged with **GMBASIC**
|Constant | Value | Color |
|---|---|---|
| `BLACK` |#000000|![](https://placehold.co/16x16/000000/000000.png)|
| `SILVER` |#C0C0C0|![](https://placehold.co/16x16/C0C0C0/C0C0C0.png)|
| `GRAY` |#808080|![](https://placehold.co/16x16/808080/808080.png)|
| `WHITE` |#FFFFFF|![](https://placehold.co/16x16/FFFFFF/FFFFFF.png)|
| `MAROON` |#800000|![](https://placehold.co/16x16/800000/800000.png)|
| `RED` |#FF0000|![](https://placehold.co/16x16/FF0000/FF0000.png)|
| `GREEN` |#008000|![](https://placehold.co/16x16/008000/008000.png)|
| `LIME` |#00FF00|![](https://placehold.co/16x16/00FF00/00FF00.png)|
| `TEAL` |#008080|![](https://placehold.co/16x16/008080/008080.png)|
| `BLUE` |#0000FF|![](https://placehold.co/16x16/0000FF/0000FF.png)|
| `AQUA` |#00FFFF|![](https://placehold.co/16x16/00FFFF/00FFFF.png)|
| `NAVY` |#000080|![](https://placehold.co/16x16/000080/000080.png)|
| `ORANGE` |#FFA040|![](https://placehold.co/16x16/FFA040/FFA040.png)|
| `YELLOW` |#FFFF00|![](https://placehold.co/16x16/FFFF00/FFFF00.png)|
| `PURPLE` |#800080|![](https://placehold.co/16x16/800080/800080.png)|
| `FUCHSIA` |#FF00FF|![](https://placehold.co/16x16/FF00FF/FF00FF.png)|

>[!NOTE]
>`MAKECOLORRGB` allows you to create custome colors at runtime!

## Input
You may collect basic input from the user in a few ways:  
```basic
20 INPUT NAME
```

This will halt the program's execution and prompt the user to input text and only resume running when ENTER is pressed.  
When ENTER is pressed, the input value will be stored in NAME(or whatever variable name you choose) and continue execution. This is useful for text based programs that need input from the user.
  
The other method is more useful for games, but only checks certain keys.  
Simply check one of the following CONSTANTS to get instant input feedback!  
| Constant| Description |
|---|---|
|`KLEFT`| The left arrow key's state, where 0 is not pressed and 1 is pressed.|
|`KRIGHT`| The right arrow key's state, where 0 is not pressed and 1 is pressed.|
|`KUP`| The up arrow key's state, where 0 is not pressed and 1 is pressed.|
|`KDOWN`| The down arrow key's state, where 0 is not pressed and 1 is pressed.|
|`KSPACE`| The down arrow key's state, where 0 is not pressed and 1 is pressed.|
|`MLEFT`| The left mouse button's state, where 0 is not pressed and 1 is pressed.|
|`MRIGHT`| The right mouse button's state, where 0 is not pressed and 1 is pressed.|
|`MX`|The mouse's current X value.|
|`MY`|The mouse's current Y value.|

An example of a simple way to check keys without using IF branches:  
```basic
10 LET Y = 300
20 LET X = 400
30 CLS
40 LET X = X + KRIGHT * 2 - KLEFT * 2
50 LET Y = Y + KDOWN * 2 - KUP * 2
60 LET X = CLAMP(X, 0, 800)
70 LET Y = CLAMP(Y, 0, 600)
80 FCIRC(X, Y, 10)
90 VSYNC
100 GOTO 30
```
For more general keys on the keyboards, currently these functions exist.

>[!NOTE]
>`KEY` may be a LETTER or DIGIT such as `"K"` or `"4"` in these functions!

| Function| Description |
|---|---|
|`KEYCHECK("KEY")`|Returns the `KEY`'s state, where 0 is up and 1 is down.|
|`KEYCHECK_PRESSED("KEY")`|Returns 1 if the `KEY` was pressed this frame, otherwise returns 0.|
|`KEYCHECK_RELEASED("KEY")`|Returns 1 if the `KEY` was released this frame, otherwise returns 0.|

## Timing  
The functions here are to help with program timing
| Function| Description |
|---|---|
|`GETTIMER`| Returns the time in microseconds since the BASIC MACHINE has started running|
|`VSYNC`|Ends the program’s slice for this frame and resumes next frame. Without it, the program runs up to the per-frame step limit and carries on next frame, so its timing isn’t controlled.|
|`CLS`| Publishes the frame built since the previous `CLS` and starts a new one. Anything drawn before the first `CLS` is discarded!|

## Buffers  
Buffers are a way to store and manipulate data FAST.  
Always remember to DELETE buffers when you're done with them, they are NOT garbage collected!  
  
Buffer Types are constants:  
| Constant| Description |
|---|---|
|`BUFF_GROW`| a buffer that grows past it's initial size|
|`BUFF_FIXED`| a buffer that will NOT grow beyond it's initial size.|
|`BUFF_WRAP`| a buffer that wraps around to the beginning when going past it's initial size|

Buffer Data Types are the following:  
| Constant| Description |
|---|---|
|`BUFF_U8`| an unsigned 8 bit integer, from `0` to `255`.|
|`BUFF_S8`| a signed 8 bit integer, from `-128` to `127`.|
|`BUFF_U16`| an unsigned 16 bit integer, from `0` to `65,535`.|
|`BUFF_S16`| a signed 16 bit integer, from `-32,768` to `32,767`.|
|`BUFF_U32`| an unsigned 32 bit integer, from `0` to `4,294,967,295`.|
|`BUFF_S32`| a signed 32 bit integer, from `-2,147,483,648` to `2,147,483,647`.|
|`BUFF_U64`| an unsigned 64 bit integer, from `0` to `18,446,744,073,709,551,615`.|
|`BUFF_F16`| a 16 bit float with a range of +/- 65504.|
|`BUFF_F32`| a 32 bit float with a range of +/- 16777216. |
|`BUFF_F64`| a 64 bit float with a range of approximately `±2.23 × 10⁻³⁰⁸` to `±1.80 × 10³⁰⁸`, with a precision of about 15 to 16 decimal digits.|
|`BUFF_TEXT`| a `STRING` of any size without the final null terminating character.|
|`BUFF_STRING`| a  `STRING` of any size with the final null terminating character.|
|`BUFF_BOOL`| can be `1` or `0` for `true` or `false`.|

BUFF_SEEK uses the following contstants:  
| Constant| Description |
|---|---|
|`BUFF_SEEK_START`| Sets the seek to the start of the buffer|
|`BUFF_SEEK_REL`| Sets the seek to a position relative to the current seek position|
|`BUFF_SEEK_END`| Sets the seek to the end of the buffer|
  
A simple example of `BUFFER`s in use:  
```basic
10 LET X = BUFF_CREATE(16, BUFF_FIXED, 1)
20 BUFF_WRITE(X, BUFF_STRING, "HELLO WORLD!")
30 LET Y = BUFF_PEEK(X, 0, BUFF_STRING)
40 PRINT Y
50 BUFF_DELETE(X)
```

>[!NOTE]
>For all signed buffer data types, `0` is considered a positive number!

| Function| Description |
|---|---|
|`BUFF_CREATE(SIZE, TYPE, ALIGNMENT)`| returns a new `BUFFER` of `TYPE`, with `SIZE` and `ALIGNMENT`.|
|`BUFF_SEEK(BUFFER,  BASE, OFFSET)`| returns the new seek position of the `BUFFER`.|
|`BUFF_PEEK(BUFFER,  OFFSET, TYPE)`| returns the value stored in the `BUFFER` at `OFFSET`, or `undefined` if it fails.|
|`BUFF_POKE(BUFFER,  OFFSET, TYPE, VALUE)`| poke `VALUE` of `TYPE` into the `BUFFER` at `OFFSET`.|
|`BUFF_TELLBUFFER)`| returns the seek position of `BUFFER`.|
|`BUFF_WRITE(BUFFER, TYPE, VALUE)`| writes `VALUE` of `TYPE` into `BUFFER`'s current seek position and moves the seek accordingly.|
|`BUFF_READ(BUFFER, TYPE)`| returns the value at `BUFFER`'s current seek position, be sure your `TYPE` is correct!|
|`BUFF_DELETE(BUFFER)`| Deletes `BUFFER` and frees that memory.|
|`BUFF_SAVE(BUFFER, FILENAME)`| Save the contents of `BUFFER` to `FILENAME`. |
|`BUFF_LOAD(FILENAME)`| Returns the contents of `FILENAME` as a buffer. |

## Files  
`GMBASIC` allows for you to access up to `10` files at a time!
Store a file handle in a variable like so:
```basic
10 LET X = FOPEN("FILE.TXT")
```
This stores the file handle in variable `X`, which can then be used by all of the file functions below!  
| Function| Description |
|---|---|
|`FOPEN(FILENAME, [MODE])`| Returns a file handle for `FILENAME`, optional `MODE` can be `"W"`, `"R"`, or `"A"` for `WRITE`, `READ`, or `APPEND` respectively. |
|`FREAD_LINE_STRING(FILEHANDLE)`| Returns the next line of the file and increases the read position for the next operation.|
|`FREAD_LINE_NUMBER(FILEHANDLE)`| Returns the next line of the file and increases the read position for the next operation.|
|`FWRITE_LINE_STRING(FILEHANDLE, VALUE)`| Writes `VALUE` to `FILEHANDLE` as a `STRING` and increases the write positiong for the next operation.|
|`FWRITE_LINE_NUMBER(FILEHANDLE, VALUE)`| Writes `VALUE` to `FILEHANDLE` as a `NUMBER` and increases the write positiong for the next operation.|
|`FCLOSE(FILEHANDLE)`| Closes the file handle `FILEHANDLE`, no further operations can be done after it's closed!(until it's reopened!)|
|`FEXISTS(FILENAME)`| Returns whether a file with `FILENAME` exists.|

## Miscellany
Various Functions that don't have enough sister functions for their own section yet:
| Function| Description |
|---|---|
|`HTTP_GET(CALLBACK_VAR, URL)`| Sends a GET request to `URL` and stores the response in `CALLBACK_VAR` asynchronously. See below example for usage.|

An example of how to use `HTTP_GET`:
```basic
10 LET RESP = "WAITING"
20 LET ID = HTTP_GET("RESP", "http://example.com/")
30 VSYNC
40 IF RESP = "WAITING" THEN GOTO 30
50 PRINT "DONE!"
```

## Some Examples
I struggle writing BASIC, which I know is funny, but here are some examples of the things I struggle to retain the most, array usage and loops.  

A basic loop and draw call structure.  
Animates a red circle across the canvas:  
```basic
10 LET X = 0
20 CLS
30 SETDRAWCOLOR(RED)
40 FCIRC(X, 100, 20)
50 LET X = X + 2
60 IF X > 800 THEN GOTO 10
70 VSYNC
80 GOTO 20
```
>[!NOTE]
>`GOTO` can jump to LATER in the program as well, it is NOT just a jump BACK.  

A basic array assignment:  
```basic
10 DIM A(4)
20 LET I = 0
30 LET A(I) = I * I
40 LET I = I + 1
50 IF I <= 4 THEN GOTO 30
60 PRINT A(3)
```  
  

Using arrays and functions together to draw circles of different colors:
```basic
10 DIM COL(7)
20 LET COL(0) = RED
30 LET COL(1) = ORANGE
40 LET COL(2) = YELLOW
50 LET COL(3) = GREEN
60 LET COL(4) = BLUE
70 LET COL(5) = PURPLE
80 LET COL(6) = FUCHSIA
90 CLS
100 SETDRAWCOLOR(COL(RANDOM(6)))
110 FCIRC(400, 300, 25)
120 SETDRAWCOLOR(COL(RANDOM(6)))
130 CIRC(400, 300, 26)
140 VSYNC
150 GOTO 90
```
## Credit
Written By Lukan Spellweaver, adapted from the [GameMaker Documentation](https://manual.gamemaker.io)  
Adapted to HTML from my Markdown by Claude  
Font in HTML version is [CQ Mono, by Chequered Ink](https://www.dafont.com/cq-mono.font), same font the project itself uses
