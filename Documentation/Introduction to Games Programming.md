# 1. Iteration One

In the first iteration of **Cave Escape**, you will implement the boiler plate code for a simple game. The boiler plater code includes the instructions to open a **Graphics Window** and a basic **Game Loop**, where all of the instructions that you implement will be called from.

### What to Expect

Once you're finished working through and implementing **Iteration One**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_1.png)
That's it! Just a blank **Graphics Window**, but we'll work on that blank canvas in future iterations.

### Code

##### - Complete Code
The complete code for **Iteration One** is as follows:

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

##### - How it's Working
The ```Main()``` procedure, as demonstrated in the code above, is responsible for executing all of the instructions required for our game to run. The instructions are executed in **Sequence**, meaning that the code within the ```Main()``` **Procedure** will be executed in the exact order in which it is specified.

So, that being said, let's take a moment to analyse the ```Main()``` **Procedure** and the **Instructions** it is executing. The **Sequence** is as follows:

  1. Firstly, a call to ```OpenGraphicsWindow()``` is made, where we can see the title of the window being opened is *Cave Escape* and the *width* and *height* of the window is 432 by 768 pixels.
  2. The **Game Loop** is opened. The game loop will loop over and over, until the user closes the window, meaning all of the instruction will be continually executed for as long as the loop is running. Note that the condition of the loop is ```WindowCloseRequested()```.
     * The following instructions are executed within the **Game Loop**:
      1. ```ProcessEvents()``` is called. ```ProcessEvents()``` is used to listen for any user input made while the program is running.
      2. We then clear the screen with ```ClearScreen()``` before we draw anything to it (we're not drawing anything in this iteration, but that will come soon!).
      3. We then refresh the screen with ```RefreshScreen()``` so that we can see what we've drawn.

### Have a Crack
Now it's time for you to have a go at implementing **Iteration One** on your own. You'll have to type the **Instructions** above into your **Text Editor**. **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.

---
# 2. Iteration Two

In the second iteration of **Cave Escape**, you will implement the functionality to have your game produce a graphical representation of the **Player**. The **Player** will be drawn to the centre of the **Graphics Window** and come complete with an animation!

### What to Expect

Once you're finished working through and implementing **Iteration Two**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_2.png)
What's different from **Iteration One**? We've got a graphical representation of the game's **Player**! Now let's take a look at how this is implemented.

### Code

##### - New Code
The new code in **Iteration Two** is as follows:

```pascal    
function GetNewPlayer(): Sprite;
  begin
    result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
    SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
    SpriteSetY(result, ScreenHeight() / 2);
    SpriteStartAnimation(result, 'Fly');
  end;
```

##### - What's the New Code Doing?
```GetNewPlayer()``` **Function**, as demonstrated in the code above, is used to generate the data associated with the **Player** entity that we'll be using in our game. It's important to note that **Functions** use a special **Variable** called ```result``` to store the value in that they calculate.

So, let's take a look at the **Instructions** the ```GetNewPlayer()``` **Function** implements in order to achieve the end goal of generating a new **Player**. The **Sequence** is as follows:

  1. By Looking at the **Function** declaration, we can see that the type of value the ```GetNewPlayer()`` **Function** will return is a **Sprite**.
  2. The **Function's** ```result``` **Variable** is **Assigned** the value of the game's **Player** graphics and is given the data required to animate the **Player** **Sprite**.
  3. The **Sprite's** X location on the screen is set to be in the middle, horizontally.
  4. The **Sprite's** Y location on the screen is set to be in the middle , horizontally. Now that both the X and Y position of the **Sprite** are centered, the **Sprite** is positioned in the middle of the screen.
  5. The animation for the **Sprite** is started and the **Function** comes to an end, returning the value stored within it's ```result``` **Variable**.

##### - Complete Code
The complete code for **Iteration Two** is as follows:

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

#### - You've Changed, Main
Take a close look at the **Complete Code** above and review the ```Main()``` **Procedure**. A few things have changed in order to cater for our new ```GetNewPlayer()``` **Function** as well as drawing our **Player** to the screen. Let's talk about those changes:

  1. There is now a **Variable** called ```player```, which is used to store the value that the ```GetNewPlayer()``` **Function** returns.
  2. There's a call to a **Procedure** called ```LoadResouceBundleNamed()```. This procedure is loading all of the assets that the game needs. Assets include graphics, such as the graphics for the **Player**, fonts and sounds.
  3. The ```player``` **Variable** is assigned the value returned by calling the **Function** ```GetNewPlayer()```.
  4. The **Game Loop** has changed a little, too. There's now a call to two new **Procedures**, ```UpdateSprite()``` and ```DrawSprite()```. These two **Procedures** are handling the updating of the **Player** and the drawing of the **Player**.


### Have a Crack
Now it's time for you to have a go at implementing **Iteration Two** on your own. As before, you'll have to type the **Instructions** above into your **Text Editor**. Continue to **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.

---
# 3. Iteration Three

In the third iteration of **Cave Escape**, you will implement the functionality to give your **Player** the ability to fly! Well, almost. You're going to add some velocity to the **Player** so that it's not just stuck in the middle of the screen, instead, when you're finished, the **Player** will fall right off the screen!

### What to Expect

Once you're finished working through and implementing **Iteration Three**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_3.png)
So with some velocity, the game is a little more dynamic than it previously was in **Iteration Two**.

### Code

##### - New Code
The new code in **Iteration Three** is as follows:

Addition one
```pascal
const
  GRAVITY = 0.08;
  MAX_SPEED = 5;```

Addition two
```pascal    
procedure UpdateVelocity(player: Sprite);
begin
  SpriteSetDy(player, SpriteDy(player) + GRAVITY);

  if SpriteDy(player) > MAX_SPEED then
  begin
    SpriteSetDy(player, MAX_SPEED);
  end
  else if SpriteDy(player) < -(MAX_SPEED) then
  begin
    SpriteSetDy(player, -(MAX_SPEED));
  end;
end;
```

##### - What's the New Code Doing?
We've taken the time to add some **Constant** values that are going to be used in the calculation of the **Player's** velocity. Those values represent an imposed ```GRAVITY``` and a ```MAX_SPEED``` in regards to what we want to impose as the maximum velocity the **Player** can move, or fall at. The ```UpdateVelocity()``` **Procedure**, as demonstrated in the code above, uses these two new **Constant** values to determine what the **Player's** speed will be by using **Conditional** **Statements**. The **Conditional** **Statements** ensure that ```if``` the **Player** is not already falling at the ```MAX_SPEED```, increase it's velocity, ```else```, if the **Player** is already falling at the ```MAX_SPEED```, ensure that if stays falling at the ```MAX_SPEED``` rather than speeding up.

##### - Complete Code
The complete code for **Iteration Three** is as follows:

```pascal
program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
end;

procedure UpdateVelocity(player: Sprite);
begin
  SpriteSetDy(player, SpriteDy(player) + GRAVITY);

  if SpriteDy(player) > MAX_SPEED then
  begin
    SpriteSetDy(player, MAX_SPEED);
  end
  else if SpriteDy(player) < -(MAX_SPEED) then
  begin
    SpriteSetDy(player, -(MAX_SPEED));
  end;
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

    UpdateVelocity(player);
    UpdateSprite(player);
    DrawSprite(player);

    RefreshScreen();

  until WindowCloseRequested();
end;

begin
  Main();
end.
```

#### - Take a Look at Main
The ```Main``` **Procedure** has now changed. Notice that in the **Game Loop**, there's now a call to the new **Procedure** ```UpdateVelocity()```. This ensures that for each time the **Game Loop** executes, we're ensuring that we're updating the **Player's** velocity accordingly.


### Have a Crack
Now it's time for you to have a go at implementing **Iteration Three** on your own. As before, you'll have to type the **Instructions** above into your **Text Editor**. Continue to **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.

---
# 4. Iteration Four

In the fourth iteration of **Cave Escape**, we will actually implement the ability to have you control the way the **Player** flies. Instead of the **Player** just falling into the abyss, as it was in **Iteration Three**, **Iteration Four** sees the inclusion of the logic required to keep the **Player** on the screen by using keyboard input. In particular, we're going to make it so that every time the **Space Bar** is pressed, the **Player** is going to fly a little higher, and further away from the bottom of the screen..

### What to Expect

Once you're finished working through and implementing **Iteration Four**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_4.png)
Look at that! Control over the **Players** velocity!

### Code

##### - New Code
The new code in **Iteration Four** is as follows:

Addition one
```pascal
JUMP_RECOVERY_BOOST = 2;
```

Addition two
```pascal    
procedure HandleInput(player: Sprite);
begin
  if KeyTyped(SpaceKey) then
  begin
    SpriteSetDy(player, SpriteDy(player) - JUMP_RECOVERY_BOOST);
  end;
end;
```

##### - What's the New Code Doing?
In order to be able to control the **Player's** velocity with user input, we've had to a new **Constant** value called ```JUMP_RECOVERY_BOOST```. The reason for this will become more clear when we talk about the new **Procedure** ```HandleInput()```, which is exactly what we're going to do now. The new **Procedure** ```HandleInput()``` is implemented to listen for user input while the **Game** is running. Specifically, the input it's listening for is when the **Space Bar** is pressed. Every time the **Space Bar** is pressed, the ```HandleInput()``` **Procedure** will decrement the value of the **Constant** ```JUMP_RECOVERY_BOOST``` from the **Player's** current velocity, meaning, the each time the **Space Bar** is pressed, the **Player** will fall a little slower, but only briefly. The aim is to have the user continually press the **Space Bar** to keep the **Player** on the screen and give it the affect of flying!

##### - Complete Code
The complete code for **Iteration Three** is as follows:

```pascal
const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
end;

procedure HandleInput(player: Sprite);
begin
  if KeyTyped(SpaceKey) then
  begin
    SpriteSetDy(player, SpriteDy(player) - JUMP_RECOVERY_BOOST);
  end;
end;

procedure UpdateVelocity(player: Sprite);
begin
  SpriteSetDy(player, SpriteDy(player) + GRAVITY);

  if SpriteDy(player) > MAX_SPEED then
  begin
    SpriteSetDy(player, MAX_SPEED);
  end
  else if SpriteDy(player) < -(MAX_SPEED) then
  begin
    SpriteSetDy(player, -(MAX_SPEED));
  end;
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

    UpdateVelocity(player);
    HandleInput(player);
    UpdateSprite(player);
    DrawSprite(player);

    RefreshScreen();

  until WindowCloseRequested();
end;

begin
  Main();
end.
```

#### - Main has Changed, Again
The ```Main``` **Procedure** has now changed. Notice that in the **Game Loop**, there's now a call to the new **Procedure** ```HandleInput()```. This ensures that for each time the **Game Loop** executes, we're ensuring that we're listening for any user input, specifically, if the **Space Bar** has been pressed. Now we have a more functional game where the user finally has some control over the way the game behaves.


### Have a Crack
Now it's time for you to have a go at implementing **Iteration Three** on your own. As before, you'll have to type the **Instructions** above into your **Text Editor**. Continue to **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.
