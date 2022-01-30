<img src="https://i.imgur.com/ta6gv1i.png?1"  alt="logo"/>

---

# Hint

This Kata is an extension of the earlier ones in this series. Completing those first will make this task easier.

# Background

My TV remote control has arrow buttons and an `OK` button.

I can use these to move a "cursor" on a logical screen keyboard to type words...

# Keyboard

The screen "keyboard" layouts look like this


<table>

<tr>
<th>Keypad Mode 1 = alpha-numeric (lowercase)
<th>Keypad Mode 3 = symbols
</tr>

<tr>
<td>
<table id = "tvkb">
<tr><td>a<td>b<td>c<td>d<td>e<td>1<td>2<td>3</tr>
<tr><td>f<td>g<td>h<td>i<td>j<td>4<td>5<td>6</tr>
<tr><td>k<td>l<td>m<td>n<td>o<td>7<td>8<td>9</tr>
<tr><td>p<td>q<td>r<td>s<td>t<td>.<td>@<td>0</tr>
<tr><td>u<td>v<td>w<td>x<td>y<td>z<td>&#x005f;<td>/</tr>
<tr><td>aA#<td>SP<td style="background-color: orange"><td style="background-color: orange"><td style="background-color: orange"><td style="background-color: orange"><td style="background-color: orange"><td style="background-color: orange"></tr>
</table>
</td>

<td>
<table id = "tvkb">
<tr><td>^<td>~<td>?<td>!<td>'<td>"<td>(<td>)</tr>
<tr><td>-<td>:<td>;<td>+<td>&<td>%<td>*<td>=</tr>
<tr><td><<td>><td>&#x20ac;<td>&#x00a3;<td>$<td>&#x00a5;<td>&#x00a4;<td>\</tr>
<tr><td>[<td>]<td>{<td>}<td>,<td>.<td>@<td>&#x00a7;</tr>
<tr><td>#<td>&#x00bf;<td>&#x00a1;<td style="background-color:orange;"><td style="background-color:orange;"><td style="background-color:orange;"><td>&#x005f;<td>/</tr>
<tr><td>aA#<td>SP<td style="background-color: orange"><td style="background-color: orange"><td style="background-color: orange"><td style="background-color: orange"><td style="background-color: orange"><td style="background-color: orange"></tr>
</table>
</td>
</tr>
</table>

* `aA#` is the SHIFT key. Pressing this key cycles through <span style="color:red">THREE keypad modes.</span>
* <span style="color:red">**Mode 1**</span> = alpha-numeric keypad with lowercase alpha (as depicted above)
* <span style="color:red">**Mode 2**</span> = alpha-numeric keypad with UPPERCASE alpha
* <span style="color:red">**Mode 3**</span> = symbolic keypad (as depicted above)


* `SP` is the space character
* The other (solid fill) keys in the bottom row have no function

## Special Symbols

For your convenience, here are Unicode values for the less obvious symbols of the **Mode 3** keypad

<table id="legend">
<tr><td>&#x00a1; = U-00A1<td>&#x00a3; = U-00A3<td>&#x00a4; = U-00A4<td>&#x00a5; = U-00A5</tr>
<tr><td>&#x00a7; = U-00A7<td>&#x00bf; = U-00BF<td>&#x20ac; = U-20AC<td></tr>
</table>

# Kata task

How many button presses on my remote are required to type the given `words`?

## Notes

* The cursor always starts on the letter `a` (top left)
* The initial keypad layout is **Mode 1**
* Remember to also press `OK` to "accept" each letter
* Take the shortest route from one letter to the next
* The cursor wraps, so as it moves off one edge it will reappear on the opposite edge
* Although the blank keys have no function, you may navigate through them if you want to
* Spaces may occur anywhere in the `words` string
* Do not press the SHIFT key until you need to. For example, with the word `e.Z`, the SHIFT change happens **after** the `.` is pressed (not before). In other words, do not try to
  optimize total key presses by pressing SHIFT early.

# Example

words = `Too Easy?`

* T => `a`-`aA#`-OK-`U`-`V`-`W`-`X`-`Y`-`T`-OK = 9
* o => `T`-`Y`-`X`-`W`-`V`-`U`-`aA#`-OK-OK-`a`-`b`-`c`-`d`-`e`-`j`-`o`-OK = 16
* o => `o`-OK = 1
* space => `o`-`n`-`m`-`l`-`q`-`v`-`SP`-OK = 7
* E => `SP`-`aA#`-OK-`A`-`3`-`2`-`1`-`-E`-OK = 8
* a => `E`-`1`-`2`-`3`-`A`-`aA`-OK-OK-`a`-OK = 9
* s => `a`-`b`-`c`-`d`-`i`-`n`-`s`-OK = 7
* y => `s`-`x`-`y`-OK = 3
* ? => `y`-`x`-`w`-`v`-`u`-`aA#`-OK-OK-`^`-`~`-`?`-OK = 11

Answer = 9 + 16 + 1 + 7 + 8 + 9 + 7 + 3 + 11 = 71

<hr style="background-color:orange;height:2px;width:75%;margin-top:30px;margin-bottom:30px;"/>

Series

* <a href=https://www.codewars.com/kata/tv-remote>TV Remote</a>
* <a href=https://www.codewars.com/kata/tv-remote-shift-and-space>TV Remote (shift and space)</a>
* <a href=https://www.codewars.com/kata/tv-remote-wrap>TV Remote (wrap)</a>
* TV Remote (symbols)
