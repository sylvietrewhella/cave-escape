program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
	GRAVITY = 0.08;
	JUMP_RECOVERY_BOOST = 2;
	MAX_SPEED = 5;
	MAX_ROTATION_ANGLE = 90;
	SPRITE_FRAME_DURATION = 150;
	NUM_FRAMES = 4;

type

	PoleData = record
		Direction: Boolean;
		Pole: Bitmap;
	end;

	BackgroundData = record
		fixedBackground: Sprite;
		scrollingBackground: Sprite;
	end;

	Animatable = record
		updateFequency: Integer;
		spriteFrameTimer: Timer;
		currentSpriteFrame: Integer;
		sprites: array [0..3] of Sprite;
	end;

	PlayerRepresentation = record
		animatable: Animatable;
		dead: Boolean;
		verticalSpeed: Double;
		score: Integer;
	end;

	GameData = record
		poles: array [0..4] of PoleData;
		bgData: BackgroundData;
		playerData: PlayerRepresentation;
	end;

procedure LoadResources();
begin
	LoadBitmapNamed('player_frame_1', 'playerFrame1.png');
	LoadBitmapNamed('player_frame_2', 'playerFrame2.png');
	LoadBitmapNamed('player_frame_3', 'playerFrame3.png');
	LoadBitmapNamed('player_frame_4', 'playerFrame4.png');

	LoadBitmapNamed('upward_pole_1', 'UpwardPole1.png');
	LoadBitmapNamed('upward_pole_2', 'UpwardPole2.png');

	LoadBitmapNamed('fixed_bg', 'background.png');
	LoadBitmapNamed('scrolling_bg', 'scrollingBackground.png');
	LoadFontNamed('game font', 'arial.ttf', 48);
end;

function GetNewAnimatable(spriteName: String; numFrames, updateFequency: Integer): Animatable;
var
	i: Integer;
begin
	for i := 0 to numFrames - 1 do
	begin
		result.sprites[i] := CreateSprite(BitmapNamed(spriteName + IntToStr(i + 1)));
		SpriteSetX(result.sprites[i], (ScreenWidth() / 2 - SpriteWidth(result.sprites[i])));
		SpriteSetY(result.sprites[i], (ScreenHeight() / 2));
	end;
	result.updateFequency := updateFequency;
	result.spriteFrameTimer := CreateTimer();
	result.currentSpriteFrame := 0;
end;

function GetRandomPole(): PoleData;
var
	i: Integer;
begin
	i := Rnd(4);
	case i  of
			 0 :
			 begin
				 result.Pole := BitmapNamed(upward_pole_1);
				 result.Direction := true;
			 end;
			 1 :
			 begin
			 	result.Pole := upward_pole_1;
			 	result.Direction := true;
			 end;
			 2 :
			 begin
				 result.Pole := upward_pole_1;
				 result.Direction := true;
			 end;
			 3 :
			 begin
				 result.Pole := upward_pole_1;
				 result.Direction := true;
			 end;
		end;
end;

function GetNewPlayer(): PlayerRepresentation;
begin
	result.animatable := GetNewAnimatable('player_frame_', NUM_FRAMES, SPRITE_FRAME_DURATION);
	StartTimer(result.animatable.spriteFrameTimer);
	result.dead := false;
	result.verticalSpeed := 0;
	result.score := 0;
end;

function GetNewBackgroundData(): BackgroundData;
begin
	result.fixedBackground := CreateSprite(BitmapNamed('fixed_bg'));
	result.scrollingBackGround := CreateSprite(BitmapNamed('scrolling_bg'));

	SpriteSetX(result.scrollingBackGround, 0);
 	SpriteSetY(result.scrollingBackGround, SpriteHeight(result.fixedBackground) - SpriteHeight(result.scrollingBackGround));
 	SpriteSetX(result.fixedBackground, 0);
 	SpriteSetY(result.fixedBackground, 0);
end;

procedure SetUpGame(var gData: GameData);
var
	i: Integer;
begin
	for i:= Low(gData.poles) to High(gData.poles) do
		begin
			gData.poles[i] := GetRandomPole();
		end;
	gData.playerData := GetNewPlayer();
	gData.bgData := GetNewBackgroundData();
end;

procedure UpdateRotation(var toRotate: PlayerRepresentation);
var
	i: Integer;
	rotationPercentage: Double;
begin
	rotationPercentage := (toRotate.verticalSpeed / MAX_SPEED);
	for i := Low(toRotate.animatable.sprites) to High(toRotate.animatable.sprites) do
	begin
		SpriteSetRotation(toRotate.animatable.sprites[i], rotationPercentage * MAX_ROTATION_ANGLE);
	end;
end;

procedure UpdateVelocity(var toUpdate: PlayerRepresentation);
var
	i: Integer;
begin
	toUpdate.verticalSpeed := toUpdate.verticalSpeed + GRAVITY;
	if toUpdate.verticalSpeed > MAX_SPEED then
	begin
		toUpdate.verticalSpeed := MAX_SPEED;
	end
	else if (toUpdate.verticalSpeed < MAX_SPEED * -1) then
	begin
		toUpdate.verticalSpeed := MAX_SPEED * -1;
	end;
	for i := Low(toUpdate.animatable.sprites) to High(toUpdate.animatable.sprites) do
	begin
		SpriteSetY(toUpdate.animatable.sprites[i], (SpriteY(toUpdate.animatable.sprites[i]) + toUpdate.verticalSpeed));
	end;
end;

procedure UpdateBackground(var gData: GameData);
begin
	SpriteSetX(gData.bgData.scrollingBackground, SpriteX(gData.bgData.scrollingBackground) - 1);
	if (SpriteX(gData.bgData.scrollingBackground) <= (SpriteWidth(gData.bgData.fixedBackground) - SpriteWidth(gData.bgData.scrollingBackground))) then
	begin
		SpriteSetX(gData.bgData.scrollingBackground, 0);
	end;
end;

procedure UpdateAnimatable(var toUpdate: Animatable);
begin
	if (TimerTicks(toUpdate.spriteFrameTimer) >= toUpdate.updateFequency) then
	begin
		if (toUpdate.currentSpriteFrame = Length(toUpdate.sprites) - 1) then
		begin
			toUpdate.currentSpriteFrame := 0;
		end
		else
		begin
			toUpdate.currentSpriteFrame += 1;
		end;
		ResetTimer(toUpdate.spriteFrameTimer);
	end;
end;

procedure CheckForCollisions(var toUpdate: GameData);
begin
	if (SpriteCollision(toUpdate.playerData.animatable.sprites[toUpdate.playerData.animatable.currentSpriteFrame], toUpdate.bgData.scrollingBackground))
		or (SpriteY(toUpdate.playerData.animatable.sprites[toUpdate.playerData.animatable.currentSpriteFrame]) < ScreenHeight() - ScreenHeight()) then
	begin
		toUpdate.playerData.dead := true;
	end;
end;

procedure UpdatePlayerSprite(var toUpdate: PlayerRepresentation);
begin
	UpdateRotation(toUpdate);
	UpdateAnimatable(toUpdate.animatable);
end;

procedure UpdatePlayer(var toUpdate: PlayerRepresentation);
begin
	UpdateVelocity(toUpdate);
	UpdatePlayerSprite(toUpdate);
end;

procedure HandleInput(var toUpdate: PlayerRepresentation);
begin
	if MouseClicked(LeftButton) then
	begin
		toUpdate.verticalSpeed += JUMP_RECOVERY_BOOST * -1;
	end;
end;

procedure UpdateGame(var gData: GameData);
begin
	if not (gData.playerData.dead) then
	begin
		CheckForCollisions(gData);
		HandleInput(gData.playerData);
		UpdateBackground(gdata);
		UpdatePlayer(gData.playerData);
	end
	else
	begin
		SetUpGame(gData);
	end;
end;

procedure DrawPlayer(const playerData: PlayerRepresentation);
begin
	DrawSprite(playerData.animatable.sprites[playerData.animatable.currentSpriteFrame]);
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
  OpenGraphicsWindow('Flappy Bird', 288, 512);
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
