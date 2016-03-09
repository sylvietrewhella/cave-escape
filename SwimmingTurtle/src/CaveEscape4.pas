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

procedure LoadResources();
begin
  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);
  LoadBitmapNamed('background', 'background.png');
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
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
	OpenAudio();
  LoadResources();

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
