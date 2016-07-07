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
```GetNewPlayer()``` **Function**, as demonstrated in the code above, is used to generate the data associated with the **Player** entity that we'll be using in our game. It's important to note that **Functions** use a special **Variable** called ```result``` to store the value in that they calculate. So, in short, the **Function** is creating a **Sprite** for the **Player**, setting the **Sprite's** location to the centre of the screen and setting an animation for the **Sprite**. Once the **Function** finishes, it returns the **Sprite** it creates.

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
Take a close look at the **Complete Code** above and review the ```Main()``` **Procedure**. A few things have changed in order to cater for our new ```GetNewPlayer()``` **Function** as well as drawing our **Player** to the screen. The **Sprite** that the **Function** ```GetNewPlayer()``` returns is assigned to a variable called ```player``` and then within the **Game Loop**, the **Player** **Sprite** is updated and drawn.

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

In the fourth iteration of **Cave Escape**, we will actually implement the ability to have you control the way the **Player** flies. Instead of the **Player** just falling into the abyss, as it was in **Iteration Three**, **Iteration Four** sees the inclusion of the logic required to keep the **Player** on the screen by using keyboard input. In particular, we're going to make it so that every time the **Space Bar** is pressed, the **Player** is going to fly a little higher, and further away from the bottom of the screen.

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
In order to be able to control the **Player's** velocity with user input, we've had to add a new **Constant** value called ```JUMP_RECOVERY_BOOST```. The reason for this will become more clear when we talk about the new **Procedure** ```HandleInput()```, which is exactly what we're going to do now. The new **Procedure** ```HandleInput()``` is implemented to listen for user input while the **Game** is running. Specifically, the input it's listening for is when the **Space Bar** is pressed. Every time the **Space Bar** is pressed, the ```HandleInput()``` **Procedure** will decrement the value of the **Constant** ```JUMP_RECOVERY_BOOST``` from the **Player's** current velocity, meaning, the each time the **Space Bar** is pressed, the **Player** will fall a little slower, but only briefly. The aim is to have the user continually press the **Space Bar** to keep the **Player** on the screen and give it the affect of flying!

##### - Complete Code
The complete code for **Iteration Four** is as follows:

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

---
# 5. Iteration Five

In the fifth iteration of **Cave Escape**, we add quite a bit of functionality, more so than in the previous iterations. We're up for a big step with this one. We're going to add an obstacle. We'll refer to the obstacle as **Poles**. It's the aim of the game to avoid the **Poles**, but we'll worry about that later. For now, let's just worry about getting the **Poles** onto the screen. So, this iteration concerns the generation of a single set of **Poles** as well as the way the **Poles** behave.

### What to Expect

Once you're finished working through and implementing **Iteration Five**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_5.png)
While **Iteration Five** is quite a bit involved, in terms of new code required, it adds loads of functionality to our game and now, more than ever, it's looking more and more like a game.

### Code

##### - New Code
The new code in **Iteration Five** is as follows:

Addition one
```pascal
POLE_SCROLL_SPEED = -2;
```

Addition two
```pascal    
type
    PoleData = record
      UpPole: Sprite;
      DownPole: Sprite;
    end;
```

Addition three
```pascal    
function GetRandomPoles(): PoleData;
begin
  result.UpPole := CreateSprite(BitmapNamed('UpPole'));
  result.DownPole := CreateSprite(BitmapNamed('DownPole'));
  SpriteSetX(result.UpPole, ScreenWidth() + RND(1200));
  SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole));
  SpriteSetX(result.DownPole, SpriteX(result.UpPole));
  SpriteSetY(result.DownPole, 0);
  SpriteSetDx(result.UpPole, POLE_SCROLL_SPEED);
  SpriteSetDx(result.DownPole, POLE_SCROLL_SPEED);
end;
```

Addition four
```pascal    
procedure UpdatePole(var poles: PoleData);
begin
  UpdateSprite(poles.UpPole);
  UpdateSprite(poles.DownPole);
end;
```

Addition five
```pascal    
procedure DrawPoles(const poles: PoleData);
begin
  DrawSprite(poles.UpPole);
  DrawSprite(poles.DownPole);
end;
```

##### - What's the New Code Doing?
The **Poles** that we're adding to the game will move horizontally across the screen, from left to right. In order to cater for this, we've added another **Constant** called ```POLE_SCROLL_SPEED``` in order to keep track of the speed at which the **Poles** travel across the screen. In order to be able to keep track of the data required to add the **Poles** to the **Game**, we've added a **Record** called ```PoleData```. If you take a look at the ```PoleData``` **Record**, you'll notice that it has two **Fields** as **Sprites**. ```PoleData``` needs two **Sprites** because one **Pole** will come down from the top of the screen and the other will come up from the bottom.

Now, we need some logic in order to be able to add the **Poles** to the **Game** so that we can see them. Firstly, we've got a new **Function** called ```GetRandomPoles()```, which is responsible for generating the data associated with the **Poles**. This **Function** behaves similarly to the **Function** ```GetNewPlayer()```, as discussed in **Iteration Two**. ```GetRandomPoles()``` assigns the top and bottom **Poles** their own **Sprites**, sets their x location to a random location off the far right of the screen (this is intentional because we want to see the **Poles** scroll onto the screen from the right) and sets their y locations so that they appear to be coming down from the top and up from the bottom of the screen. Finally, the **Function** assigns their **Delta X**, or horizontal movement speed to that of the value of the **Constant** ```POLE_SCROLL_SPEED```. A **Procedure** called ```UpdatePoles()``` has been added to update the **Poles** and another **Procedure** called ```DrawPoles()``` to draw the **Poles** to the screen.

##### - Complete Code
The complete code for **Iteration Five** is as follows:

```pascal
program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;
  POLE_SCROLL_SPEED = -2;

type
    PoleData = record
      UpPole: Sprite;
      DownPole: Sprite;
    end;

function GetRandomPoles(): PoleData;
begin
  result.UpPole := CreateSprite(BitmapNamed('UpPole'));
  result.DownPole := CreateSprite(BitmapNamed('DownPole'));
  SpriteSetX(result.UpPole, ScreenWidth() + RND(1200));
  SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole));
  SpriteSetX(result.DownPole, SpriteX(result.UpPole));
  SpriteSetY(result.DownPole, 0);
  SpriteSetDx(result.UpPole, POLE_SCROLL_SPEED);
  SpriteSetDx(result.DownPole, POLE_SCROLL_SPEED);
end;

procedure UpdatePoles(var poles: PoleData);
begin
  UpdateSprite(poles.UpPole);
  UpdateSprite(poles.DownPole);
end;

procedure DrawPoles(const poles: PoleData);
begin
  DrawSprite(poles.UpPole);
  DrawSprite(poles.DownPole);
end;

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
  gamePoles: PoleData;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);

  player := GetNewPlayer();

  gamePoles := GetRandomPoles();

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    UpdateVelocity(player);
    HandleInput(player);
    UpdateSprite(player);
    DrawSprite(player);
    UpdatePoles(gamePoles);
    DrawPoles(gamePoles);
    RefreshScreen();
  until WindowCloseRequested();
end;

begin
  Main();
end.
```

#### - More Changes to Main
The ```Main``` **Procedure** has now changed. Notice that we're now using our new **Function** ```GetRandomPoles()``` and assigning the value it returns to a **Variable** called ```gamePoles```. In order to move the **Poles** across the screen and draw them, we've added the calls to the **Procedures** ```UpdatePoles()``` and ```DrawPoles()``` within the **GameLoop**

### Have a Crack
Now it's time for you to have a go at implementing **Iteration Three** on your own. As before, you'll have to type the **Instructions** above into your **Text Editor**. Continue to **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.

---
# 6. Iteration Six

In the sixth iteration of **Cave Escape**, we're going to make a few additions to ensure that once the **Poles** move off the far left of the screen, they get moved back to off the right of the screen. This will ensure that the **Poles** can be reused as obstacles.

### What to Expect

Once you're finished working through and implementing **Iteration Six**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_6.png)
The **Poles** are much better when they wrap around the game screen!.

### Code

##### - New Code
The new code in **Iteration Six** is as follows:

Addition one
```pascal
procedure ResetPoleData(var poles: PoleData);
begin
  FreeSprite(poles.UpPole);
  FreeSprite(poles.DownPole);
  poles := GetRandomPoles();
end;
```

Addition two (Note: ```UpdatePoles()``` has had code added to it)
```pascal    
procedure UpdatePoles(var poles: PoleData);
begin
  UpdateSprite(poles.UpPole);
  UpdateSprite(poles.DownPole);

  if ((SpriteX(poles.UpPole) + SpriteWidth(poles.UpPole)) < 0) and ((SpriteX(poles.DownPole) + SpriteWidth(poles.DownPole)) < 0) then
  begin
    ResetPoleData(poles);
  end;
end;
```

##### - What's the New Code Doing?
We've added a new **Procedure** called ```ResetPoleData()``` that is going to reset the **Poles** once they move off the screen. Notice that it calls the **Function** ```GetRandomPoles()``` that we implemented before. It makes sense to reuse code where you can, and the **Poles** that the **Function** ```GetRandomPoles()``` returns are exactly what we need when we have to reset them. We've modified ```UpdatePoles()``` to check to see if the **Poles** have moved off the screen and ```if``` they have, we simply reset them.

##### - Complete Code
The complete code for **Iteration Six** is as follows:

```pascal
program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;
  POLE_SCROLL_SPEED = -2;

type
    PoleData = record
      UpPole: Sprite;
      DownPole: Sprite;
    end;

function GetRandomPoles(): PoleData;
begin
  result.UpPole := CreateSprite(BitmapNamed('UpPole'));
  result.DownPole := CreateSprite(BitmapNamed('DownPole'));
  SpriteSetX(result.UpPole, ScreenWidth() + RND(1200));
  SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole));
  SpriteSetX(result.DownPole, SpriteX(result.UpPole));
  SpriteSetY(result.DownPole, 0);
  SpriteSetDx(result.UpPole, POLE_SCROLL_SPEED);
  SpriteSetDx(result.DownPole, POLE_SCROLL_SPEED);
end;

procedure ResetPoleData(var poles: PoleData);
begin
  FreeSprite(poles.UpPole);
  FreeSprite(poles.DownPole);
  poles := GetRandomPoles();
end;

procedure UpdatePoles(var poles: PoleData);
begin
  UpdateSprite(poles.UpPole);
  UpdateSprite(poles.DownPole);

  if ((SpriteX(poles.UpPole) + SpriteWidth(poles.UpPole)) < 0) and ((SpriteX(poles.DownPole) + SpriteWidth(poles.DownPole)) < 0) then
  begin
    ResetPoleData(poles);
  end;
end;

procedure DrawPoles(const poles: PoleData);
begin
  DrawSprite(poles.UpPole);
  DrawSprite(poles.DownPole);
end;

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
  gamePoles: PoleData;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);

  player := GetNewPlayer();

  gamePoles := GetRandomPoles();

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    UpdateVelocity(player);
    HandleInput(player);
    UpdateSprite(player);
    DrawSprite(player);
    UpdatePoles(gamePoles);
    DrawPoles(gamePoles);
    RefreshScreen();
  until WindowCloseRequested();
end;

begin
  Main();
end.
```

### Have a Crack
Now it's time for you to have a go at implementing **Iteration Three** on your own. As before, you'll have to type the **Instructions** above into your **Text Editor**. Continue to **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.

---
# 7. Iteration Seven

In **Iteration Seven** of **Cave Escape**, we're going to implement the logic to have more than one set of **Poles**. One set of **Poles** is simply not challenging enough, and the overall change in logic to suit such functionality is quite minor.

### What to Expect

Once you're finished working through and implementing **Iteration Seven**, you should have something that looks just like this:
![Iteration One](Resources/Images/iteration_7.png)
Now we have lots of **Poles**.

### Code

##### - New Code
The new code in **Iteration Seven** is as follows:

Addition one
```pascal
NUM_POLES = 4;
```

Addition two
```pascal    
Poles = array [0..NUM_POLES - 1] of PoleData;
```

Addition three (Note: ```UpdatePoles()``` has had code added to it)
```pascal    
procedure UpdatePoles(var poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    UpdateSprite(poles[i].UpPole);
    UpdateSprite(poles[i].DownPole);

    if ((SpriteX(poles[i].UpPole) + SpriteWidth(poles[i].UpPole)) < 0) and ((SpriteX(poles[i].DownPole) + SpriteWidth(poles[i].DownPole)) < 0) then
    begin
      ResetPoleData(poles[i]);
    end;
  end;
end;
```

Addition four (Note: ```DrawPoles()``` has had code added to it)
```pascal    
procedure DrawPoles(const poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    DrawSprite(poles[i].UpPole);
    DrawSprite(poles[i].DownPole);
  end;
end;
```

##### - What's the New Code Doing?
We've added a **Constant** called ```NUM_POLES``` to store the number of sets of **Poles** we want in the **Game**. The code provided has ```NUM_POLES``` being equal to the value of four, so this means there will be exactly four sets of **Poles** in the **Game**. The second addition is an **Array** of ```PoleData``` called ```Poles```. This **Array** is where our four sets of **Poles** will be stored. You can see the **Array** is declared as such ```Poles = array [0..NUM_POLES - 1] of PoleData;```. It's important to understand the logic in the square bracers ```[0..NUM_POLES - 1]```. Now, ```NUM_POLES``` is four, so ```NUM_POLES - 1``` is equal to three, so the logic equates to ```[0..3]```. Computers are zero based, meaning that our first set of **Poles** is actually denoted the numerical value of zero, the second set is denoted one, the third set two and the fourth set three! Moving on.

```UpdatePoles()``` has only changed to work with our new **Array** of **Poles** instead of just working with a single set of **Poles** and the same applies to ```DrawPoles()```. Notice that both **Procedures** are using a ```for``` **Loop** to make sure every set of **Poles** in the **Array** is updated and drawn.

##### - Complete Code
The complete code for **Iteration Seven** is as follows:

```pascal
program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;
  POLE_SCROLL_SPEED = -2;
  NUM_POLES = 4;

type
    PoleData = record
      UpPole: Sprite;
      DownPole: Sprite;
    end;

    Poles = array [0..NUM_POLES] of PoleData;

function GetRandomPoles(): PoleData;
begin
  result.UpPole := CreateSprite(BitmapNamed('UpPole'));
  result.DownPole := CreateSprite(BitmapNamed('DownPole'));
  SpriteSetX(result.UpPole, ScreenWidth() + RND(1200));
  SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole));
  SpriteSetX(result.DownPole, SpriteX(result.UpPole));
  SpriteSetY(result.DownPole, 0);
  SpriteSetDx(result.UpPole, POLE_SCROLL_SPEED);
  SpriteSetDx(result.DownPole, POLE_SCROLL_SPEED);
end;

procedure ResetPoleData(var pole: PoleData);
begin
  FreeSprite(pole.UpPole);
  FreeSprite(pole.DownPole);
  pole := GetRandomPoles();
end;

procedure UpdatePoles(var poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    UpdateSprite(poles[i].UpPole);
    UpdateSprite(poles[i].DownPole);

    if ((SpriteX(poles[i].UpPole) + SpriteWidth(poles[i].UpPole)) < 0) and ((SpriteX(poles[i].DownPole) + SpriteWidth(poles[i].DownPole)) < 0) then
    begin
      ResetPoleData(poles[i]);
    end;
  end;
end;

procedure DrawPoles(const poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    DrawSprite(poles[i].UpPole);
    DrawSprite(poles[i].DownPole);
  end;
end;

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
  gamePoles: Poles;
  i: Integer;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);

  player := GetNewPlayer();

  for i:= Low(gamePoles) to High(gamePoles) do
  begin
    gamePoles[i] := GetRandomPoles();
  end;

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    UpdateVelocity(player);
    HandleInput(player);
    UpdateSprite(player);
    DrawSprite(player);
    UpdatePoles(gamePoles);
    DrawPoles(gamePoles);
    RefreshScreen();
  until WindowCloseRequested();
end;

begin
  Main();
end.
```

### Have a Crack
Now it's time for you to have a go at implementing **Iteration Three** on your own. As before, you'll have to type the **Instructions** above into your **Text Editor**. Continue to **Try and resist the urge to Copy and Paste** code if it arrises, as typing it out helps build your understanding in regards to what the code is doing. When you're done, you'll need to **Build** and **Run** your code to see if it is all working. If you encounter any **Build Errors**, you'll have to resolve those and **Build** and **Run** again.
