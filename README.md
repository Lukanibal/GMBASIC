# GMBASIC Language Reference

## GMBASIC Syntax

```basic
LET X = 5
```
Assigns the value `5` to the variable `X`.

```basic
PRINT "HELLO WORLD"
```
Prints `HELLO WORLD` to the console. `PRINT` also accepts variables and arrays.

`CLS` clears the console and frame buffer, then publishes a new frame.

`VSYNC` yields the current frame time to the runner.

All functions that return a value must be assigned with `LET`. For example, `LET X = SQR(16)` assigns `4` to `X`.

`IF` `THEN` `ELSE` are supported, but only accept `GOTO` for `THEN` and `ELSE`, so
```basic
IF X = 1 THEN GOTO 100 ELSE GOTO 200
```
Is the only accepted syntax
`GOTO <LINE NUMBER>` is also supported for _BASIC_ loops 

RESERVED WORDS
The following words cannot be used as variable names as they are reserved by the system, it will not stop you from trying to set them, but the reserved system value will always be returned.  
All FUNCTION names are also reserved.
|Constant | Description |
|---|---|
|`PI`| 3.14|
|`TAU`| PI * 2(6.18)|
|`EUL`| 2.718281828459045| 

`EUL` is usually expressed as `E` in settings like these, but stealing a letter of the alphabet from use as a variable name felt rude.


## Math
Simple expressions can be done via the `LET` command, for example
```basic
10 LET X = 10 + 2
```
Will make `X = 12` and so forth.  
Mixed with the math comands below, you can perform more complex calculations.

| Function | Description |
|---|---|
| `SQR(X)` | Returns the square root of `X`. |
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
| `LOG(X, Y)` | Returns the logarithm of `X` with base `Y`. |
| `CLAMP(X, MIN, MAX)` | Clamps a value between a minimum and maximum range. |
| `LERP(A, B, T)` | Linearly interpolates between `A` and `B` by `T`. |
| `MOD(X, Y)` | Returns the remainder of `X` divided by `Y`. |
| `DIV(X, Y)` | Returns the integer division of `X` by `Y`. |
| `POINTDIR(X1, Y1, X2, Y2)` | Returns the direction from point `(X1, Y1)` to point `(X2, Y2)` in degrees. |
| `LENGTHDIRX(L, D)` | Returns the X component of a vector with length `L` and direction `D` (in degrees). |
| `LENGTHDIRY(L, D)` | Returns the Y component of a vector with length `L` and direction `D` (in degrees). |

## Matrix
| Function | Description |
|---|---|
| `MATRIXSETWORLD(MATRIX)`| Sets the current world transformation matrix to `MATRIX`.|
| `MATRIXSETVIEW(MATRIX)` | Sets the current view transformation matrix to `MATRIX`.|
| `MATRIXSETPROJ(MATRIX)` | Sets the current projection transformation matrix to `MATRIX`.|
| `MATRIXBUILD(X, Y, Z, ROTX, ROTY, ROTZ, SCALEX, SCALEY, SCALEZ)` | Builds a transformation matrix with translation `(X, Y, Z)`, rotation `(ROTX, ROTY, ROTZ)` in degrees, and scaling `(SCALEX, SCALEY, SCALEZ)`.|
| `MATRIXBUILDID()` | Returns an identity matrix.|
| `MATRIXBUILDLOOKAT(XFROM, YFROM, ZFROM, XTO, YTO, ZTO, XUP, YUP, ZUP)`| Builds a look-at matrix for a camera positioned at `(XFROM, YFROM, ZFROM)`, looking at `(XTO, YTO, ZTO)`, with an up vector of `(XUP, YUP, ZUP)`.|
| `MATRIXBUILDORTHO(WIDTH, HEIGHT, ZNEAR, ZFAR)` | Builds an orthographic projection matrix with the specified width, height, near plane, and far plane.|
| `MATRIXBUILDPROJ(FOVY, ASPECT, ZNEAR, ZFAR)` | Builds a perspective projection matrix with the specified field of view (in degrees), aspect ratio, near plane, and far plane.|

## Graphics
The graphics calls do not currently use parentesis as they are from an earlier version of the FUNCTION handler, they will be updated eventually, but until then please leave them without PARENTHESIS or the runner will crash :( 
These older functions also only allow variables or numbers as arguments! So you cannot put expressions in or they crash the runner :((
| Function | Description |
|---|---|
|`SETDRAWCOLOR COLOR`| Sets the color for all subsequent graphics functions to COLOR, must be a COLOR constant.|
| `LINE X1, Y1, X2, Y2`| Draws a line from point X1, Y1 to point X2, Y2|
| `RECT X1, Y1, X2, Y2`| Draws a rectangle outline from  top left point X1, Y1 to bottom right point X2, Y2|
| `FRECT X1, Y1, X2, Y2`| Draws a filled rectangle from  top left point X1, Y1 to bottom right point X2, Y2|
| `CIRC X, Y, R`| Draws a circle outline at X, Y with a radius of R|
| `FCIRC X, Y, R`| Draws a filled circle at X, Y with a radius of R|
| `TRI X1, Y1, X2, Y2, X3, Y3`| Draws a triangle outline with the points at X1, Y1 X2, Y2, and X3, Y3 respectively|
| `FTRI X1, Y1, X2, Y2, X3, Y3`| Draws a filled triangle with the points at X1, Y1 X2, Y2, and X3, Y3 respectively|

## Colors
There are a finite set of colors allowed in GMBASIC currently  
These are their HEX codes, but Markdown doesn't let me display the actual colors nicely :(
| Constant | Value |
|---|---|
|`BLACK`|#000000|
|`WHITE`|#FFFFFF|
|`MAROON`|#800000|
|`RED`|#FF0000|
|`GREEN`|#008000|
|`LIME`|#00FF00|
|`BLUE`|#0000FF|
|`AQUA`|#00FFFF|
|`ORANGE`|#FFA040|
|`YELLOW`|#FFFF00|
|`PURPLE`|#800080|
|`FUCHSIA`|#FF00FF|

## Input
You may collect basic input from the user in 2 ways:
```basic
20 INPUT NAME
```  
This will halt the program's execution and prompt the user to input text and only resume running when ENTER is pressed.  
When ENTER is pressed, the input value will be stored in NAME(or whatever variable name you choose).

The other method is more useful for games, but only checks certain keys.  
Simply check one of the following CONSTANTS to get instant input feedback!
| Constant| Description |
|---|---|
|`KLEFT`| The left arrow key's state, where 0 is not pressed and 1 is pressed|
|`KRIGHT`| The right arrow key's state, where 0 is not pressed and 1 is pressed|
|`KUP`| The up arrow key's state, where 0 is not pressed and 1 is pressed|
|`KDOWN`| The down arrow key's state, where 0 is not pressed and 1 is pressed|
|`MLEFT`| The left mouse button's state, where 0 is not pressed and 1 is pressed|
|`MRIGHT`| The right mouse button's state, where 0 is not pressed and 1 is pressed|
|`MX`|The mouse's current X value|
|`MY`|The mouse's current X value|
