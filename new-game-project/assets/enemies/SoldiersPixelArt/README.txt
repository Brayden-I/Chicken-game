TOP-DOWN SOLDIERS - PIXEL ART PACK
v0.9

Thanks for downloading. Everything here is ready to drop into a game engine.


-------------------------------------------------------------------
WHAT'S INSIDE
-------------------------------------------------------------------

3 characters, 8 directions each, 3 animation states.

  Vanguard          64x64   idle / walk / fire   all 8 directions
  ArmoredSoldier    64x64   idle / walk / fire   all 8 directions
  RifleSoldier      64x64   idle / walk / fire   all 8 directions

  Ground            32x32 grass/dirt tileset + sample terrain
  SoldiersSimple    the original v0.8 soldier (kept for compatibility)

Every character is on the same 64x64 grid, so one import setting works
for the whole pack.

Directions are named in full: North, NorthEast, East, SouthEast,
South, SouthWest, West, NorthWest.

Every animation ships twice:
  .png   horizontal sprite sheet - this is what you import
  .gif   looping preview - for looking at, not for importing


-------------------------------------------------------------------
FRAME COUNTS AND TIMING
-------------------------------------------------------------------

  Idle    4 frames   190 ms per frame   loops
  Walk    8 frames   100 ms per frame   loops
  Fire    4 frames    80 ms per frame   play once, then return to idle

Sheets are laid out left to right in one row, so sheet width is
(frames x cell size) and height is one cell.

  Walk sheet:  512x64
  Idle/fire:   256x64


-------------------------------------------------------------------
IMPORTING (Unity)
-------------------------------------------------------------------

Texture Type ......... Sprite (2D and UI)
Sprite Mode .......... Multiple
Pixels Per Unit ...... 64
Mesh Type ............ Full Rect
Filter Mode .......... Point (no filter)
Compression .......... None
Generate Mip Maps .... off
Wrap Mode ............ Clamp

Then Sprite Editor -> Slice -> Grid By Cell Size, 64 x 64,
Pivot: Bottom Center.

IMPORTANT: use Grid By Cell Size, not Automatic. Automatic slicing
trims each sprite to its content, and content bounds shift slightly
between frames (the muzzle flash extends the bounds during fire).
With a fixed cell that doesn't matter. With trimming it becomes
visible jitter.

Godot / GameMaker: same idea - slice on a fixed grid, disable texture
filtering, and anchor to the bottom centre of the cell.


-------------------------------------------------------------------
WHY THE CHARACTER WON'T JUMP BETWEEN STATES
-------------------------------------------------------------------

Within each character and direction, the ground line sits on the same
row in idle, walk and fire. Feet stay planted - a foot that is bearing
weight never moves, in any frame of any animation. So switching
animation state mid-game won't make the sprite pop up or down.


-------------------------------------------------------------------
TILES
-------------------------------------------------------------------

Ground/GrassDirtTileset32.png   128x128 sheet, sixteen 32x32 tiles

  Layout (columns 0-3 left to right, rows 0-3 top to bottom):

    row 0:  grass base | dirt base  |  -  | inner corner
    row 1:  corner TL  | edge top   | corner TR | inner corner
    row 2:  edge left  | dirt fill  | edge right| inner corner
    row 3:  corner BL  | edge bottom| corner BR | inner corner

  Rows 1-3, columns 0-2 form the standard 3x3 block for laying dirt
  patches and paths into grass. Column 3 holds the four inner corners
  for concave joins. Both base tiles wrap seamlessly on their own.

Ground/GrassTile32.png          the grass base on its own
Ground/DirtTile32.png           the dirt base on its own
Ground/tilesetground.png        256x180 sample terrain, kept as a
                                reference image - it is a picture, not
                                a grid tileset. Use the tileset above.


-------------------------------------------------------------------
LICENCE
-------------------------------------------------------------------

✅ Commercial use allowed — use these assets in free or paid games and other projects.
✅ You may modify the assets to fit your project.
✅ Credit is appreciated, but not required.
❌ Do not redistribute, share, or resell the assets themselves, including modified versions, as standalone files, asset packs, or templates.
You may distribute the assets as part of your finished game or project.

-------------------------------------------------------------------
FEEDBACK
-------------------------------------------------------------------

This is an early release and comments genuinely shape the next one.
If something is missing, broken, or awkward to use, please say so on
the itch.io page.

If you build something with these, I'd love to see it.

Made with Pixelorama.
