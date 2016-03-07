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

	SCREEN_WIDTH = 432;
	SCREEN_HEIGHT = 768;

type
	PoleData = record
		ScoreLimiter: Boolean;
		Pole: Sprite;
	end;

	Poles = array [0..3] of PoleData;

	// Animation = record
	// 	XPos: Double;
	// 	YPos: Double;
	// 	VerticalSpeed: Double;
	// 	HorizontalSpeed: Double;
	// 	UpdateFequency: Integer;
	// 	BitmapFrameTimer: Timer;
	// 	CurrentBitmapFrame: Integer;
	// 	Bitmaps: array of Bitmap;
	// end;

	GameData = record
		Player: Sprite;
		foreground: Sprite;
		background: Sprite;
		isDead: Boolean;
		Score: Integer;
		Poles: Poles;
	end;

procedure LoadResources();
begin

	LoadResourceBundleNamed('player, playeranimations.txt', false);

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

function GetNewAnimation(bitmapName: String; numFrames, updateFequency: Integer; position: Point2D; speed: Vector): Animation;
var
	i: Integer;
begin
	SetLength(result.Bitmaps, numFrames);
	for i := Low(result.Bitmaps) to High(result.Bitmaps) do
	begin
		if not (numFrames = 1) then
		begin
			result.Bitmaps[i] := CreateSprite(BitmapNamed(bitmapName + IntToStr(i + 1)));
		end
		else
		begin
			result.Bitmaps[i] := CreateSprite(BitmapNamed(bitmapName));
		end;
		result.XPos := position.x;
		result.YPos := position.y;
	end;
	if not (numFrames = 1) then
	begin
		result.BitmapFrameTimer := CreateTimer();
		StartTimer(result.BitmapFrameTimer);
	end;
	result.HorizontalSpeed := speed.x;
	result.VerticalSpeed := speed.y;
	result.UpdateFequency := updateFequency;
	result.CurrentBitmapFrame := 0;
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

function GetNewPlayer(): Sprite;
var
	i: Integer;
	playerStartPostion: Point2D;
	playerSpeed: Vector;
begin
	result := CreateSprite(BitmapNamed('player'), AnimationScriptNamed('playeranimations'))
	SpriteSetX(result, ScreenWidth() / 2 - BitmapWidth(BitmapNamed('player_frame_1')));
	SpriteSetY(result, ScreenHeight() / 2);
	SpriteSetSpeed(result, 0.5);
end;

function GetNewBackgroundData(): BackgroundData;
var
	i: Integer;
	foregroundPostion, backgroundPosition: Point2D;
	foregroundSpeed, backgroundSpeed: Vector;
begin
	foregroundPostion.x := 0;
	foregroundPostion.y := BitmapHeight(BitmapNamed('background')) - BitmapHeight(BitmapNamed('foreground_1'));
	backgroundPosition.x := 0;
	backgroundPosition.y := 0;
	foregroundSpeed.x := FOREGROUND_SCROLL_SPEED;
	foregroundSpeed.y := 0;
	backgroundSpeed.x := BACKGROUND_SCROLL_SPEED;
	backgroundSpeed.y := 0;
	result.Background := GetNewAnimation('background', 1, 0, backgroundPosition, backgroundSpeed);
	result.ForeGround := GetNewAnimation('foreground_', 3, 200, foregroundPostion, foregroundSpeed);
end;

procedure SetUpGame(var gData: GameData);
var
	i: Integer;
begin
	for i:= Low(gData.Poles) to High(gData.Poles) do
	begin
		gData.Poles[i] := GetRandomPole();
	end;
	gData.player := GetNewPlayer();
	gData.bgData := GetNewBackgroundData();
	gData.Score := 0;
	gDate.isDead := false;
end;

procedure UpdateRotation(var toRotate: Sprite);
var
	rotationPercentage: Double;
begin
	rotationPercentage := toRotate.Animation.VerticalSpeed / MAX_SPEED;
	SpriteSetRotation(toRotate, rotationPercentage * MAX_ROTATION_ANGLE);
end;

procedure UpdateVelocity(var toUpdate: Sprite);
var
	i: Integer;
begin
	SpriteSetDy(toUpdate, SpriteDy(toUpdate) + GRAVITY ;

	if SpriteDy(toUpdate) > MAX_SPEED then
	begin
		SpriteSetDy(toUpdate, MAX_SPEED);
	end
	else if (SpriteDy(toUpdate) < MAX_SPEED * -1) then
	begin
	SpriteSetDy(toUpdate,  MAX_SPEED * -1);
	end;
end;

procedure UpdateAnimation(var toUpdate: Animation);
begin
	if not (Length(toUpdate.Bitmaps) = 1) then
	begin
		if (TimerTicks(toUpdate.BitmapFrameTimer) >= toUpdate.UpdateFequency) then
		begin
			if (toUpdate.CurrentBitmapFrame = Length(toUpdate.Bitmaps) - 1) then
			begin
				toUpdate.CurrentBitmapFrame := Low(toUpdate.Bitmaps);
			end
			else
			begin
				toUpdate.CurrentBitmapFrame += 1;
			end;
			ResetTimer(toUpdate.BitmapFrameTimer);
		end;
	end;
end;

procedure UpdateBackground(var gData: GameData);
var
	i: Integer;
begin
	UpdateAnimation(gdata.bgData.ForeGround);
	gdata.bgData.ForeGround.XPos := gdata.bgData.ForeGround.XPos - FOREGROUND_SCROLL_SPEED;
	gdata.bgData.Background.XPos := gdata.bgData.Background.XPos - BACKGROUND_SCROLL_SPEED;

	if (gdata.bgData.ForeGround.XPos <= SpriteWidth(gData.bgData.ForeGround.Bitmaps[gData.bgData.ForeGround.CurrentBitmapFrame]) / 2 * -1) then
	begin
		gdata.bgData.ForeGround.XPos := 0;
	end;
	if (gdata.bgData.Background.XPos <= SpriteWidth(gData.bgData.Background.Bitmaps[gData.bgData.Background.CurrentBitmapFrame]) / 2 * -1) then
	begin
		gdata.bgData.Background.XPos := 0;
	end;
end;

procedure CheckForCollisions(var toUpdate: GameData);
var
	i: Integer;
begin
	if (SpriteCollision (toUpdate.playerData.Animation.Bitmaps[toUpdate.playerData.Animation.CurrentBitmapFrame], toUpdate.bgData.ForeGround.Bitmaps[toUpdate.bgData.ForeGround.CurrentBitmapFrame]))
		or (SpriteY(toUpdate.playerData.Animation.Bitmaps[toUpdate.playerData.Animation.CurrentBitmapFrame]) < 0) then
	begin
		toUpdate.playerData.dead := true;
	end;
	for i := Low(toUpdate.Poles) to High(toUpdate.Poles) do
	begin
		if SpriteCollision(toUpdate.playerData.Animation.Bitmaps[toUpdate.playerData.Animation.CurrentBitmapFrame], toUpdate.Poles[i].Pole) then
		begin
			toUpdate.playerData.dead := true;
		end;
	end;
end;

procedure UpdatePlayer(var toUpdate: Sprite);
begin
	UpdateRotation(toUpdate);
	UpdateVelocity(toUpdate);
	UpdateAnimation(toUpdate.Animation);
end;

procedure HandleInput(var toUpdate: PlayerRepresentation);
begin
	if MouseClicked(LeftButton) then
	begin
		toUpdate.Animation.VerticalSpeed += JUMP_RECOVERY_BOOST * -1;
	end;
end;

procedure UpdatePoles(var myGame: GameData);
var
	i: Integer;
begin
	for i:= Low(myGame.Poles) to High(myGame.Poles) do
	begin
		UpdateSprite(myGame.Poles[i].Pole);

		if SpriteX (myGame.Poles[i].Pole) < (SpriteX(myGame.playerData.Animation.Bitmaps[myGame.playerData.Animation.CurrentBitmapFrame])) then
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
		UpdatePlayer(gData.player);
		UpdatePoles(gData);
	end
	else //The player has died :(
	begin
		SetUpGame(gData);
	end;
end;

procedure DrawPlayer(const playerData: PlayerRepresentation);
begin
	DrawSprite(playerData.Animation.Bitmaps[playerData.Animation.CurrentBitmapFrame], Round(playerData.Animation.XPos), Round(playerData.Animation.YPos));
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
	DrawSprite(gData.bgData.Background.Bitmaps[gData.bgData.Background.CurrentBitmapFrame], Round(gData.bgData.Background.XPos), Round(gData.bgData.Background.YPos));
	DrawPoles(gData.Poles);
	DrawSprite(gData.bgData.ForeGround.Bitmaps[gData.bgData.ForeGround.CurrentBitmapFrame], Round(gData.bgData.ForeGround.XPos), Round(gData.bgData.ForeGround.YPos));
	DrawPlayer(gData.playerData);
	DrawText(IntToStr(gData.score), ColorWhite, 'game font', 10, 0);
end;

procedure Main();
var
	gData: GameData;
begin
  OpenGraphicsWindow('Cave Escape', SCREEN_WIDTH, SCREEN_HEIGHT);
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
