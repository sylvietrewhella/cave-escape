# 1. Iteration One

In the first iteration of **Cave Escape**, you will implement the boiler plate code for a simple game. The boiler plater code includes the instructions to open a **Graphics Window** and a basic **Game Loop**, where all of the instructions that you implement will be called from.

#### What to Expect

Once you're finished working through and implementing **Iteration One**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_1.png)
That's it! Just a blank **Graphics Window**, but we'll work on that blank canvas in future iterations.

#### Code

  * ##### Complete Code
  The complete code for **Iteration One** is as follows:

    * ##### Pascal
      ```pascal
      program GameMain;
      uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

      procedure Main();
      begin
        OpenGraphicsWindow('Cave Escape', 432, 768);

        repeat // The game loop...
          ProcessEvÂents();

          ClearScreen(ColorWhite);
          RefreshScreen();

        until WindowCloseRequested();
      end;

      begin
        Main();
      end.
      ```

    * ##### C
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

  * #### How it's Working
  The ```Main()``` procedure, as demonstrated in the code above, is responsible for executing all of the instructions required for our game to run. The instructions are executed in **Sequence**, meaning that the code within the ```Main()``` **Procedure** will be executed in the exact order in which it is specified.

  So, that being said, let's take a moment to analyse the ```Main()``` **Procedure** and the **Instructions** it is executing. The **Sequence** is as follows:

    1. Firstly, a call to ```OpenGraphicsWindow()``` is made, where we can see the title of the window being opened is *Cave Escape* and the *width* and *height* of the window is 432 by 768 pixels.
    2. The **Game Loop** is opened. The game loop will loop over and over, until the user closes the window, meaning all of the instruction will be continually executed for as long as the loop is running. Note that the condition of the loop is ```WindowCloseRequested()```.
       * The following instructions are executed within the **Game Loop**:
        1. ```ProcessEvents()``` is called. ```ProcessEvents()``` is used to listen for any user input made while the program is running.
        2. We then clear the screen with ```ClearScreen()``` before we draw anything to it (we're not drawing anything in this iteration, but that will come soon!).
        3. We then refresh the screen with ```RefreshScreen()``` so that we can see what we've drawn.

#### Have a Crack
Now it's time for you to have a go at implementing **Iteration One** on your own. You'll have to type the **Instructions** above into your **Text Editor**. **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.

---
# 2. Iteration Two

In the second iteration of **Cave Escape**, you will implement the functionality to have your game produce a graphical representation of the **Player**. The **Player** will be drawn to the centre of the **Graphics Window** and come complete with an animation!

#### What to Expect

Once you're finished working through and implementing **Iteration Two**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_2.png)
What's different from **Iteration One**? We've got a graphical representation of the game's **Player**! Now let's take a look at how this is implemented.

#### Code

  * ##### New Code
  The new code in **Iteration Two** is as follows:

    * ##### Pascal
      ```pascal    
      function GetNewPlayer(): Sprite;
        begin
          result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
          SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
          SpriteSetY(result, ScreenHeight() / 2);
          SpriteStartAnimation(result, 'Fly');
        end;
        ```

    * ##### C
      ```c    
      sprite get_new_player()
      {
        sprite result;
        result = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
        sprite_set_x(result, screen_width() / 2 - sprite_width(result));
        sprite_set_y(result, screen_height() / 2);
        sprite_start_animation(result, "Fly");

        return result;
      }
      ```

  * ##### What's the New Code Doing?
  ```GetNewPlayer()``` **Function**, as demonstrated in the code above, is used to generate the data associated with the **Player** entity that we'll be using in our game. It's important to note that **Functions** use a special **Variable** called ```result``` to store the value in that they calculate.

  So, let's take a look at the **Instructions** the ```GetNewPlayer()``` **Function** implements in order to achieve the end goal of generating a new **Player**. The **Sequence** is as follows:

    1. By Looking at the **Function** declaration, we can see that the type of value the ```GetNewPlayer()`` **Function** will return is a **Sprite**.
    2. The **Function's** ```result``` **Variable** is **Assigned** the value of the game's **Player** graphics and is given the data required to animate the **Player** **Sprite**.
    3. The **Sprite's** X location on the screen is set to be in the middle, horizontally.
    4. The **Sprite's** Y location on the screen is set to be in the middle , horizontally. Now that both the X and Y position of the **Sprite** are centered, the **Sprite** is positioned in the middle of the screen.
    5. The animation for the **Sprite** is started and the **Function** comes to an end, returning the value stored within it's ```result``` **Variable**.

  * ##### Complete Code
  The complete code for **Iteration One** is as follows:

    * ##### Pascal
      ```pascal
      program GameMain;
      uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

      function GetNewPlayer(): Sprite;
      begin
        result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
        SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
        SpriteSetY(result, ScreenHeight() / 2);
        SpriteStartAnimation(result, 'Fly');
      end;

      procedure Main();
      var
        player: Sprite;
      begin
        OpenGraphicsWindow('Cave Escape', 432, 768);
        LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);

        player := GetNewPlayer();

        repeat // The game loop...
          ProcessEvents();
          ClearScreen(ColorWhite);

          UpdateSprite(player);
          DrawSprite(player);

          RefreshScreen();

        until WindowCloseRequested();
      end;

      begin
        Main();
      end.
      ```

    * ##### C
      ```c    
      #include <stdio.h>
      #include "SwinGame.h"

      sprite get_new_player()
      {
        sprite result;
        result = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
        sprite_set_x(result, screen_width() / 2 - sprite_width(result));
        sprite_set_y(result, screen_height() / 2);
        sprite_start_animation(result, "Fly");

        return result;
      }

      int main()
      {
          sprite player;

          open_graphics_window("Cave Escape", 432, 768);
          load_resource_bundle_named("CaveEscape", "CaveEscape.txt", false);

          player = get_new_player();

          do // The game loop...
          {
            process_events();
            clear_screen(COLOR_WHITE);

            update_sprite(player);
            draw_sprite(player);

            refresh_screen();

          } while(!window_close_requested());

          return 0;
      }
      ```

  * #### You've Changed, Main
  Take a close look at the **Complete Code** above and review the ```Main()``` **Procedure**. A few things have changed in order to cater for our new ```GetNewPlayer()``` **Function** as well as drawing our **Player** to the screen. Let's talk about those changes:

    1. There is now a **Variable** called ```player```, which is used to store the value that the ```GetNewPlayer()``` **Function** returns.
    2. There's a call to a **Procedure** called ```LoadResouceBundleNamed()```. This procedure is loading all of the assets that the game needs. Assets include graphics, such as the graphics for the **Player**, fonts and sounds.
    3. The ```player``` **Variable** is assigned the value returned by calling the **Function** ```GetNewPlayer()```.
    4. The **Game Loop** has changed a little, too. There's now a call to two new **Procedures**, ```UpdateSprite()``` and ```DrawSprite()```. These two **Procedures** are handling the updating of the **Player** and the drawing of the **Player**.


#### Have a Crack
Now it's time for you to have a go at implementing **Iteration Two** on your own. As before, you'll have to type the **Instructions** above into your **Text Editor**. Continue to **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.
