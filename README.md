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

## Math

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
| `MATRIXSETWORLD(MATRIX)`|Sets the current world transformation matrix to `MATRIX`.|
| `MATRIXSETVIEW(MATRIX)` |Sets the current view transformation matrix to `MATRIX`.|
| `MATRIXSETPROJ(MATRIX)` |Sets the current projection transformation matrix to `MATRIX`.|
| `MATRIXBUILD(X, Y, Z, ROTX, ROTY, ROTZ, SCALEX, SCALEY, SCALEZ)` |Builds a transformation matrix with translation `(X, Y, Z)`, rotation `(ROTX, ROTY, ROTZ)` in degrees, and scaling `(SCALEX, SCALEY, SCALEZ)`.|
| `MATRIXBUILDID()` |Returns an identity matrix.|
| `MATRIXBUILDLOOKAT(XFROM, YFROM, ZFROM, XTO, YTO, ZTO, XUP, YUP, ZUP)`|Builds a look-at matrix for a camera positioned at `(XFROM, YFROM, ZFROM)`, looking at `(XTO, YTO, ZTO)`, with an up vector of `(XUP, YUP, ZUP)`.|
| `MATRIXBUILDORTHO(WIDTH, HEIGHT, ZNEAR, ZFAR)` |Builds an orthographic projection matrix with the specified width, height, near plane, and far plane.|
| `MATRIXBUILDPROJ(FOVY, ASPECT, ZNEAR, ZFAR)` | Builds a perspective projection matrix with the specified field of view (in degrees), aspect ratio, near plane, and far plane.|
