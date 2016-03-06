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
		ScoreLimiter: Boolean;
		Pole: Sprite;
	end;
	Poles = array [0..3] of PoleData;

	Animatable = record
		updateFequency: Integer;
		spriteFrameTimer: Timer;
		currentSpriteFrame: Integer;
		sprites: array of Sprite;
	end;

	BackgroundData = record
		ForeGround: Animatable;
		Background: Sprite;
	end;

	PlayerRepresentation = record
		animatable: Animatable;
		dead: Boolean;
		verticalSpeed: Double;
		score: Integer;
	end;

	GameData = record
		Score: Integer;
		GamePoles: Poles;
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
	LoadBitmapNamed('downward_pole_1', 'DownwardPole1.png');
	LoadBitmapNamed('downward_pole_2', 'DownwardPole2.png');

	LoadBitmapNamed('foreground_1', 'foreground1.png');
	LoadBitmapNamed('foreground_2', 'foreground2.png');
	LoadBitmapNamed('foreground_3', 'foreground3.png');
	LoadBitmapNamed('background', 'background.png');
	LoadFontNamed('game font', 'GoodDog.otf', 48);

	LoadMusic('MagicalNight.ogg');
end;

function GetNewAnimatable(spriteName: String; numFrames, updateFequency: Integer; position: Point2D): Animatable;
var
	i: Integer;
begin
	SetLength(result.sprites, numFrames);
	for i := 0 to numFrames - 1 do
	begin
		result.sprites[i] := CreateSprite(BitmapNamed(spriteName + IntToStr(i + 1)));
		SpriteSetPosition(result.sprites[i], position)
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
				 result.Pole := CreateSprite(BitmapNamed('upward_pole_1'));
				 SpriteSetY(result.Pole, ScreenHeight() - SpriteHeight(result.pole));
				 result.ScoreLimiter := true;
			 end;
			 1 :
			 begin
			 	result.Pole := CreateSprite(BitmapNamed('upward_pole_2'));
				SpriteSetY(result.Pole, ScreenHeight() - SpriteHeight(result.pole));
			 	result.ScoreLimiter := true;
			 end;
			 2 :
			 begin
				 result.Pole := CreateSprite(BitmapNamed('downward_pole_1'));
				 SpriteSetY(result.Pole, 0);
				 result.ScoreLimiter := true;
			 end;
			 3 :
			 begin
				 result.Pole := CreateSprite(BitmapNamed('downward_pole_2'));
				 SpriteSetY(result.Pole, 0);
				 result.ScoreLimiter := true;
			 end;
		end;
		SpriteSetX(result.Pole, ScreenWidth() + RND(800));
		SpriteSetDx(result.Pole, -2);
		SpriteSetDy(result.Pole, 0);
end;

function GetNewPlayer(): PlayerRepresentation;
var
	playerStartPostion: Point2D;
begin
	playerStartPostion.x := ScreenWidth() / 2 - BitmapWidth(BitmapNamed('player_frame_1'));
	playerStartPostion.y := ScreenHeight() / 2;
	result.animatable := GetNewAnimatable('player_frame_', NUM_FRAMES, SPRITE_FRAME_DURATION, playerStartPostion);
	StartTimer(result.animatable.spriteFrameTimer);
	result.dead := false;
	result.verticalSpeed := 0;
	result.score := 0;
end;

function GetNewBackgroundData(): BackgroundData;
var
	i: Integer;
	foregroundPostion: Point2D;
begin
	result.Background := CreateSprite(BitmapNamed('background'));
	SpriteSetX(result.Background, 0);
	SpriteSetY(result.Background, 0);
	SpriteSetDy(result.Background, 0);
	SpriteSetDx(result.Background, -1);
	foregroundPostion.x := 0;
	foregroundPostion.y := SpriteHeight(result.Background) - BitmapHeight(BitmapNamed('foreground_1'));
	result.ForeGround := GetNewAnimatable('foreground_', 3, 200, foregroundPostion);
	for i := Low(result.ForeGround.sprites) to High(result.ForeGround.sprites) do
	begin
		SpriteSetDy(result.ForeGround.sprites[i], 0);
		SpriteSetDx(result.ForeGround.sprites[i], -2);
	end;
	StartTimer(result.ForeGround.spriteFrameTimer);
end;

procedure SetUpGame(var gData: GameData);
var
	i: Integer;
begin
	for i:= Low(gData.GamePoles) to High(gData.GamePoles) do
	begin
		gData.GamePoles[i] := GetRandomPole();
	end;
	gData.playerData := GetNewPlayer();
	gData.bgData := GetNewBackgroundData();
	gData.Score := 0;
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

procedure UpdateBackground(var gData: GameData);
var
	i: Integer;
begin
	UpdateAnimatable(gdata.bgData.ForeGround);
	for i := Low(gdata.bgData.ForeGround.sprites) to High(gdata.bgData.ForeGround.sprites) do
	begin
		UpdateSprite(gData.bgData.ForeGround.sprites[i]);
		if (SpriteX(gData.bgData.ForeGround.sprites[i]) <= SpriteWidth(gData.bgData.ForeGround.sprites[i]) / 2 * -1) then
		begin
			SpriteSetX(gData.bgData.ForeGround.sprites[i], 0);
		end;
	end;
	if (SpriteX(gData.bgData.Background) <= SpriteWidth(gData.bgData.Background) / 2 * -1) then
	begin
		SpriteSetX(gData.bgData.Background, 0);
	end;
	UpdateSprite(gData.bgData.Background);
end;

procedure CheckForCollisions(var toUpdate: GameData);
var
	i: Integer;
begin
	if (SpriteCollision(toUpdate.playerData.animatable.sprites[toUpdate.playerData.animatable.currentSpriteFrame], toUpdate.bgData.ForeGround.sprites[toUpdate.bgData.ForeGround.currentSpriteFrame]))
		or (SpriteY(toUpdate.playerData.animatable.sprites[toUpdate.playerData.animatable.currentSpriteFrame]) < ScreenHeight() - ScreenHeight()) then
	begin
		toUpdate.playerData.dead := true;
	end;
	for i := Low(toUpdate.GamePoles) to High(toUpdate.GamePoles) do
	begin
		if SpriteCollision(toUpdate.playerData.animatable.sprites[toUpdate.playerData.animatable.currentSpriteFrame], toUpdate.GamePoles[i].Pole) then
		begin
			toUpdate.playerData.dead := true;
		end;
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

procedure UpdatePoles(var myGame: GameData);
var
	i: Integer;
begin
	for i:= Low(myGame.gamePoles) to High(myGame.gamePoles) do
	begin
		UpdateSprite(myGame.GamePoles[i].Pole);

		if SpriteX (myGame.GamePoles[i].Pole) < (SpriteX(myGame.playerData.animatable.sprites[myGame.playerData.animatable.currentSpriteFrame])) then
		begin
			if (myGame.GamePoles[i].ScoreLimiter) then
			begin
				myGame.GamePoles[i].ScoreLimiter := false;
				myGame.Score += 1;
			end;
		end;

		if (SpriteOffscreen(myGame.gamePoles[i].Pole)) then
		begin
			myGame.gamePoles[i] := GetRandomPole();
		end;
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
		UpdatePoles(gData);
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

procedure DrawPoles(const myPoles: Poles);
var
	i: Integer;
begin
	for i:= Low(myPoles) to High(myPoles) do
	begin
		DrawSprite(myPoles[i].Pole);
	end;
end;

procedure DrawGame(const gData: GameData);
begin
	DrawSprite(gData.bgData.Background);
	DrawPoles(gData.GamePoles);
	DrawSprite(gData.bgData.ForeGround.sprites[gData.bgData.ForeGround.currentSpriteFrame]);
	DrawPlayer(gData.playerData);
	DrawText(IntToStr(gData.score), ColorWhite, 'game font', (ScreenWidth() - TextWidth(FontNamed('game font'), IntToStr(gData.playerData.score))), 0);
end;

procedure Main();
var
	gData: GameData;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
	ClearScreen();
	OpenAudio();
  LoadResources();
  SetUpGame(gData);

	FadeMusicIn('MagicalNight.ogg', -1, 10000);

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
