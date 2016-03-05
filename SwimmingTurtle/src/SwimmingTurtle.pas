program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
	GRAVITY = 0.08;
	MAX_RECOVERY_SPEED = 3.5;
	JUMP_RECOVERY_BOOST = 2;
	TERMINAL_VELOCITY = 5;
	SPRITE_FRAME_DURATION = 300;

type

	BackgroundData = record
		fixedBackground: Sprite;
		scrollingBackground: Sprite;
	end;

	TurtleData = record
		spriteFrameTimer: Timer;
		currentSpriteFrame: Integer;
		sprites: array [0..2] of Sprite;
		verticalSpeed: Double;
	end;

	PlayerData = record
		turtleData: TurtleData;
		score: Integer;
	end;

	GameData = record
		bgData: BackgroundData;
		playerData: PlayerData;
	end;

procedure LoadResources();
begin
	LoadBitmapNamed('turtle_frame_1', 'turtleFrame1.png');
	LoadBitmapNamed('turtle_frame_2', 'turtleFrame2.png');
	LoadBitmapNamed('turtle_frame_3', 'turtleFrame3.png');
	LoadBitmapNamed('bg_day', 'background.png');
	LoadBitmapNamed('scrolling_bg', 'scrollingBackground.png');
	LoadFontNamed('game font', 'arial.ttf', 48);
end;

function GetNewPlayerData(): PlayerData;
var
	i: Integer;
begin
	for i := Low(result.turtleData.sprites) to High(result.turtleData.sprites) do
	begin
		result.turtleData.sprites[i] := CreateSprite(BitmapNamed('turtle_frame_' + IntToStr(i + 1)));
		SpriteSetX(result.turtleData.sprites[i], (ScreenWidth() / 2 - SpriteWidth(result.turtleData.sprites[i])));
		SpriteSetY(result.turtleData.sprites[i], (ScreenHeight() / 2));
	end;
	result.turtleData.spriteFrameTimer := CreateTimer();
	StartTimer(result.turtleData.spriteFrameTimer);
	result.turtleData.currentSpriteFrame := 0;
	result.turtleData.verticalSpeed := 0;
	result.score := 0;
end;

function GetNewBackgroundData(): BackgroundData;
begin
	result.fixedBackground := CreateSprite(BitmapNamed('bg_day'));
	result.scrollingBackGround := CreateSprite(BitmapNamed('scrolling_bg'));
	SpriteSetX(result.scrollingBackGround, 0);
 	SpriteSetY(result.scrollingBackGround, SpriteHeight(result.fixedBackground) - SpriteHeight(result.scrollingBackGround));
 	SpriteSetX(result.fixedBackground, 0);
 	SpriteSetY(result.fixedBackground, 0);
end;

procedure SetUpGame(var gData: GameData);
begin
	gData.playerData := GetNewPlayerData();
	gData.bgData := GetNewBackgroundData();
end;

procedure UpdateBirdVelocity(var turtleData: TurtleData);
var
	i: Integer;
begin
	turtleData.verticalSpeed := turtleData.verticalSpeed + GRAVITY;
	if turtleData.verticalSpeed > TERMINAL_VELOCITY then
	begin
		turtleData.verticalSpeed := TERMINAL_VELOCITY;
	end
	else if (turtleData.verticalSpeed < MAX_RECOVERY_SPEED * -1) then
	begin
		turtleData.verticalSpeed := MAX_RECOVERY_SPEED * -1;
	end;
	for i := Low(turtleData.sprites) to High(turtleData.sprites) do
	begin
		SpriteSetY(turtleData.sprites[i], (SpriteY(turtleData.sprites[i]) + turtleData.verticalSpeed));
	end;
end;

procedure UpdateBackground(var gData: GameData);
begin
	SpriteSetX(gData.bgData.scrollingBackground, SpriteX(gData.bgData.scrollingBackground) - 1);
	if (SpriteX(gData.bgData.scrollingBackground) <= (SpriteWidth(gData.bgData.scrollingBackground) / 2) * -1) then
	begin
		SpriteSetX(gData.bgData.scrollingBackground, 0);
	end;
end;

procedure UpdateBirdSprite(var turtleData: TurtleData);
begin
	if (TimerTicks(turtleData.spriteFrameTimer) >= SPRITE_FRAME_DURATION) then
	begin
		if (turtleData.currentSpriteFrame = Length(turtleData.sprites) - 1) then
		begin
			turtleData.currentSpriteFrame := 0;
		end
		else
		begin
			turtleData.currentSpriteFrame += 1;
		end;
		ResetTimer(turtleData.spriteFrameTimer);
	end;
end;

procedure UpdateBird(var turtleData: TurtleData);
begin
	UpdateBirdVelocity(turtleData);
	UpdateBirdSprite(turtleData);
end;

procedure HandleInput(var turtle: TurtleData);
begin
	if MouseClicked(LeftButton) then
	begin
		turtle.verticalSpeed += JUMP_RECOVERY_BOOST * -1;
	end;
end;

procedure UpdateGame(var gData: GameData);
begin
	HandleInput(gData.playerData.turtleData);
	UpdateBackground(gdata);
	UpdateBird(gData.playerData.turtleData);
end;

procedure DrawPlayer(const playerData: PlayerData);
begin
	DrawSprite(playerData.turtleData.sprites[playerData.turtleData.currentSpriteFrame]);
end;

procedure DrawBackground(const fixedBackground, scrollingBackground: Sprite);
begin
	DrawSprite(fixedBackground);
	DrawSprite(scrollingBackground);
end;

procedure DrawGame(const gData: GameData);
begin
	DrawBackground(gData.bgData.fixedBackground, gData.bgData.scrollingBackground);
	DrawPlayer(gData.playerData);
	DrawFramerate(0,0);
end;

procedure Main();
var
	gData: GameData;

begin
  OpenGraphicsWindow('Flappy Bird', 368, 653);
  LoadResources();
  SetUpGame(gData);

  repeat // The game loop...
    ProcessEvents();

    ClearScreen(ColorWhite);
    UpdateGame(gData);
    DrawGame(gData);

    RefreshScreen(60);
  until WindowCloseRequested();
end;

begin
  Main();
end.
