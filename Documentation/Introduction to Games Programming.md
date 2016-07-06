# 1. Iteration One

In the first iteration of **Cave Escape**, you will implement the boiler plate code for a simple game. The boiler plater code includes the instructions to open a **Graphics Window** and a basic **Game Loop**, where all of the instructions that you implement will be called from.

#### What to Expect

Once you're finished working through and implementing **Iteration One**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_1.png)
Although it may not look very exciting, it's and excellent start and it's sets the foundations for moving forward to adding more functionality to your game.

#### Code

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
  2. The **Game Loop** is opened. The game loop will loop over and over, until the user closes the window, meaning all of the instruction will be continually executed for as long as the loop is running. Note that the condition of the loop is ```WindowCloseRequested()```.
     * The following instructions are executed within the **Game Loop**:
      1. ```ProcessEvents()``` is called. ```ProcessEvents()``` is used to listen for any user input made while the program is running.
      2. We then clear the screen with ```ClearScreen()``` before we draw anything to it (we're not drawing anything in this iteration, but that will come soon!).
      3. We then refresh the screen with ```RefreshScreen()``` so that we can see what we've drawn.

#### Have a Crack
Now it's time for you to have a go at implementing **Iteration One** on your own. You'll have to type the **Instructions** above into your **Text Editor**. **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.

# 2. Iteration Two

In the second iteration of **Cave Escape**, you will implement the functionality to have your game produce a graphical representation of the **Player**. The **Player** will be drawn to the centre of the **Graphics Window** and come complete with an animation!
![Iteration Two](Resources/Images/iteration_2.gif)
