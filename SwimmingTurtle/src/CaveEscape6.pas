program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
  GRAVITY = 0.08;
  JUMP_RECOVERY_BOOST = 2;
  MAX_SPEED = 5;
  MAX_ROTATION_ANGLE = 90;
  FOREGROUND_SCROLL_SPEED = 2;
  BACKGROUND_SCROLL_SPEED = 1;
  SPRITE_FRAME_DURATION = 150;

type
    Poles = array [0..3] of Sprite;

procedure LoadResources();
begin
  LoadBitmapNamed('upward_pole_1', 'UpwardPole1.png');
	LoadBitmapNamed('upward_pole_2', 'UpwardPole2.png');
	LoadBitmapNamed('downward_pole_1', 'DownwardPole1.png');
	LoadBitmapNamed('downward_pole_2', 'DownwardPole2.png');

  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);
  LoadBitmapNamed('background', 'background.png');
end;

function GetRandomPole(): Sprite;
var
	i: Integer;
begin
	i := Rnd(4);
	case i  of
			 0 :
			 begin
				 result := CreateSprite(BitmapNamed('upward_pole_1'));
				 SpriteSetY(result, ScreenHeight() - SpriteHeight(result));
			 end;
			 1 :
			 begin
			 	result := CreateSprite(BitmapNamed('upward_pole_2'));
				SpriteSetY(result, ScreenHeight() - SpriteHeight(result));
			 end;
			 2 :
			 begin
				 result := CreateSprite(BitmapNamed('downward_pole_1'));
				 SpriteSetY(result, 0);
			 end;
			 3 :
			 begin
				 result := CreateSprite(BitmapNamed('downward_pole_2'));
				 SpriteSetY(result, 0);
			 end;
		end;
		SpriteSetX(result, ScreenWidth() + RND(1200));
		SpriteSetDx(result, -2);
		SpriteSetDy(result, 0);
end;

procedure UpdatePoles(var myPoles: Poles);
var
	i: Integer;
begin
	for i:= Low(myPoles) to High(myPoles) do
	begin
		UpdateSprite(myPoles[i]);

		if (SpriteOffscreen(myPoles[i])) then
		begin
			myPoles[i] := GetRandomPole();
		end;
	end;
end;

procedure DrawPoles(const myPoles: Poles);
var
	i: Integer;
begin
	for i:= Low(myPoles) to High(myPoles) do
	begin
		DrawSprite(myPoles[i]);
	end;
end;

function GetNewPlayer(): Sprite;
begin
	result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
	SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
	SpriteSetY(result, ScreenHeight() / 2);
	SpriteStartAnimation(result, 'fly');
end;

procedure HandleInput(var toUpdate: Sprite);
begin
	if MouseClicked(LeftButton) then
	begin
		SpriteSetDy(toUpdate, SpriteDy(toUpdate) + (JUMP_RECOVERY_BOOST * -1));
	end;
end;

procedure UpdateVelocity(var toUpdate: Sprite);
begin
	SpriteSetDy(toUpdate, SpriteDy(toUpdate) + GRAVITY);

	if SpriteDy(toUpdate) > MAX_SPEED then
	begin
		SpriteSetDy(toUpdate, MAX_SPEED);
	end
	else if (SpriteDy(toUpdate) < MAX_SPEED * -1) then
	begin
	SpriteSetDy(toUpdate,  MAX_SPEED * -1);
	end;
end;

procedure Main();
var
  player: Sprite;
  myPoles: Poles;
  i: Integer;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
	OpenAudio();
  LoadResources();

  for i:= Low(myPoles) to High(myPoles) do
	begin
		myPoles[i] := GetRandomPole();
	end;

  player := GetNewPlayer();

  repeat // The game loop...
    ProcessEvents();
		ClearScreen(ColorWhite);

    UpdateVelocity(player);
    HandleInput(player);

    UpdateSprite(player);
    UpdatePoles(myPoles);

    DrawPoles(myPoles);
    DrawSprite(player);

    RefreshScreen();

  until WindowCloseRequested();
end;

begin
  Main();
end.
