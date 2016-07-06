# 1. Iteration One
---

In the first iteration of **Cave Escape**, you will implement the boiler plate code for a simple game. The boiler plater code includes the instructions to open a **Graphics Window** and a basic **Game Loop**, where all of the instructions that you implement will be called from.

### Code

The code for **Iteration One** is as follows:

##### Pascal

```pascal
program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

procedure Main();
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);

  repeat // The game loop...
    ProcessEvents();

    ClearScreen(ColorWhite);
    RefreshScreen();

  until WindowCloseRequested();
end;

begin
  Main();
end.

```

##### C

```c
  #include <stdio.h>
  #include "SwinGame.h"

  int main()
  {
      open_graphics_window("Cave Escape", 432, 768);

      do // The game loop...
      {
        process_events();

        clear_screen(COLOR_WHITE);
        refresh_screen();

      } while(!window_close_requested());

      return 0;
}
```

#### How it's Working
The **Main** procedure, as demonstrated in the code above, is responsible for executing all of the instructions required for our game to run. The instructions are executed in **Sequence**, meaning that the code within the **Main** procedure will be executed in the exact order in which it is specified.

So, that being said, let's take a moment to analyse the *Main* procedure and the **Instructions** it is executing. The **Sequence** is as follows:

  1. Firstly, a call to ```OpenGraphicsWindow()``` is made, where we can see the title of the window being opened is *Cave Escape* and the *width* and *height* of the window is 432 by 768 pixels.
  2. The **Game Loop** is opened. The game loops will loop over and over, until the user closes the window.
     * The following instructions are executed within the **Game Loop**:
        1. ```ProcessEvents()``` is called. ```ProcessEvents()``` is used to listen for any user input made while the program is running.
        2. We then clear the screen with ```ClearScreen()``` before we draw anything to it (we're not drawing anything in this iteration, but that will come soon!).
        3. We then refresh the screen with ```RefreshScreen()``` so that we can see what we've drawn.
