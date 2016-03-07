program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
	GRAVITY = 0.08;
	JUMP_RECOVERY_BOOST = 2;
	MAX_SPEED = 5;
	MAX_ROTATION_ANGLE = 90;
	SPRITE_FRAME_DURATION = 150;
	NUM_FRAMES = 4;

	SCREEN_WIDTH = 432;
	SCREEN_HEIGHT = 768;

type
	PoleData = record
		ScoreLimiter: Boolean;
		Pole: Sprite;
	end;
	Poles = array [0..3] of PoleData;

	Animation = record
		updateFequency: Integer;
		spriteFrameTimer: Timer;
		currentSpriteFrame: Integer;
		sprites: array of Sprite;
	end;

	BackgroundData = record
		ForeGround: Animation;
		Background: Sprite;
	end;

	PlayerRepresentation = record
		Animation: Animation;
		dead: Boolean;
		verticalSpeed: Double;
	end;

	GameData = record
		Score: Integer;
		Poles: Poles;
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

function GetNewAnimation(spriteName: String; numFrames, updateFequency: Integer; position: Point2D): Animation;
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
				 SpriteSetY(result.Pole, SCREEN_HEIGHT - SpriteHeight(result.pole));
				 result.ScoreLimiter := true;
			 end;
			 1 :
			 begin
			 	result.Pole := CreateSprite(BitmapNamed('upward_pole_2'));
				SpriteSetY(result.Pole, SCREEN_HEIGHT - SpriteHeight(result.pole));
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
		SpriteSetX(result.Pole, SCREEN_WIDTH + RND(1200));
		SpriteSetDx(result.Pole, -2);
		SpriteSetDy(result.Pole, 0);
end;

function GetNewPlayer(): PlayerRepresentation;
var
	playerStartPostion: Point2D;
begin
	playerStartPostion.x := SCREEN_WIDTH / 2 - BitmapWidth(BitmapNamed('player_frame_1'));
	playerStartPostion.y := SCREEN_HEIGHT / 2;
	result.Animation := GetNewAnimation('player_frame_', NUM_FRAMES, SPRITE_FRAME_DURATION, playerStartPostion);
	StartTimer(result.Animation.spriteFrameTimer);
	result.dead := false;
	result.verticalSpeed := 0;
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
	result.ForeGround := GetNewAnimation('foreground_', 3, 200, foregroundPostion);
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
	for i:= Low(gData.Poles) to High(gData.Poles) do
	begin
		gData.Poles[i] := GetRandomPole();
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
	for i := Low(toRotate.Animation.sprites) to High(toRotate.Animation.sprites) do
	begin
		SpriteSetRotation(toRotate.Animation.sprites[i], rotationPercentage * MAX_ROTATION_ANGLE);
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
	for i := Low(toUpdate.Animation.sprites) to High(toUpdate.Animation.sprites) do
	begin
		SpriteSetY(toUpdate.Animation.sprites[i], (SpriteY(toUpdate.Animation.sprites[i]) + toUpdate.verticalSpeed));
	end;
end;

procedure UpdateAnimation(var toUpdate: Animation);
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
	UpdateAnimation(gdata.bgData.ForeGround);
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
	if (SpriteCollision
				(toUpdate.playerData.Animation.sprites[toUpdate.playerData.Animation.currentSpriteFrame],
				toUpdate.bgData.ForeGround.sprites[toUpdate.bgData.ForeGround.currentSpriteFrame]))

		or (SpriteY(toUpdate.playerData.Animation.sprites[toUpdate.playerData.Animation.currentSpriteFrame]) < 0) then
	begin
		toUpdate.playerData.dead := true;
	end;
	for i := Low(toUpdate.Poles) to High(toUpdate.Poles) do
	begin
		if SpriteCollision(toUpdate.playerData.Animation.sprites[toUpdate.playerData.Animation.currentSpriteFrame], toUpdate.Poles[i].Pole) then
		begin
			toUpdate.playerData.dead := true;
		end;
	end;
end;

procedure UpdatePlayerSprite(var toUpdate: PlayerRepresentation);
begin
	UpdateRotation(toUpdate);
	UpdateAnimation(toUpdate.Animation);
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
	for i:= Low(myGame.Poles) to High(myGame.Poles) do
	begin
		UpdateSprite(myGame.Poles[i].Pole);

		if SpriteX (myGame.Poles[i].Pole) < (SpriteX(myGame.playerData.Animation.sprites[myGame.playerData.Animation.currentSpriteFrame])) then
		begin
			if (myGame.Poles[i].ScoreLimiter) then
			begin
				myGame.Poles[i].ScoreLimiter := false;
				myGame.Score += 1;
			end;
		end;

		if (SpriteOffscreen(myGame.Poles[i].Pole)) then
		begin
			myGame.Poles[i] := GetRandomPole();
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
	else //The player has died :(
	begin
		SetUpGame(gData);
	end;
end;

procedure DrawPlayer(const playerData: PlayerRepresentation);
begin
	DrawSprite(playerData.Animation.sprites[playerData.Animation.currentSpriteFrame]);
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
	DrawPoles(gData.Poles);
	DrawSprite(gData.bgData.ForeGround.sprites[gData.bgData.ForeGround.currentSpriteFrame]);
	DrawPlayer(gData.playerData);
	DrawText(IntToStr(gData.score), ColorWhite, 'game font', 10, 0);
end;

procedure Main();
var
	gData: GameData;
begin
  OpenGraphicsWindow('Cave Escape', SCREEN_WIDTH, SCNREEN_HEIGHT);
	OpenAudio();
  LoadResources();
  SetUpGame(gData);

	FadeMusicIn('MagicalNight.ogg', -1, 15000);

  repeat // The game loop...
    ProcessEvents();

    ClearScreen(ColorWhite);
    UpdateGame(gData);
    DrawGame(gData);

    RefreshScreen();
  until WindowCloseRequested();
end;

begin
  Main();
end.
