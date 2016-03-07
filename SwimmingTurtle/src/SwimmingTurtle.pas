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
	PoleData = record
		ScoreLimiter: Boolean;
		Pole: Sprite;
	end;

	Poles = array [0..3] of PoleData;

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
	LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);

	LoadBitmapNamed('upward_pole_1', 'UpwardPole1.png');
	LoadBitmapNamed('upward_pole_2', 'UpwardPole2.png');
	LoadBitmapNamed('downward_pole_1', 'DownwardPole1.png');
	LoadBitmapNamed('downward_pole_2', 'DownwardPole2.png');
	LoadBitmapNamed('background', 'background.png');
	LoadFontNamed('game font', 'GoodDog.otf', 48);

	LoadMusic('MagicalNight.ogg');
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
		SpriteSetX(result.Pole, ScreenWidth() + RND(1200));
		SpriteSetDx(result.Pole, -2);
		SpriteSetDy(result.Pole, 0);
end;

function GetNewPlayer(): Sprite;
begin
	result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
	SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
	SpriteSetY(result, ScreenHeight() / 2);
	SpriteSetSpeed(result, 0.5);
	SpriteStartAnimation(result, 'fly');
end;

procedure SetUpParallaxBackground(var background, foreground: Sprite);
begin
	background := CreateSprite(BitmapNamed('background'));
	SpriteSetX(background, 0);
	SpriteSetY(background, 0);
	SpriteSetDx(background, -1);

	foreground := CreateSprite(BitmapNamed('Foreground'), AnimationScriptNamed('ForegroundAminations'));
	SpriteSetX(foreground, 0);
	SpriteSetY(foreground, ScreenHeight() - SpriteHeight(foreground));
	SpriteSetDx(foreground, -2);
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
	gData.Score := 0;
	gData.isDead := false;
	SetUpParallaxBackground(gData.background, gData.foreground);

	SpriteStartAnimation(gData.foreground, 'fire');
end;

procedure UpdateRotation(var toRotate: Sprite);
var
	rotationPercentage: Double;
begin
	rotationPercentage := SpriteSpeed(toRotate)/MAX_SPEED;
	SpriteSetRotation(toRotate, rotationPercentage * MAX_ROTATION_ANGLE);
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

procedure UpdateBackground(var gData: GameData);
begin
	UpdateSprite(gData.foreGround);
	updateSprite(gData.background);
	if (SpriteX(gdata.foreground) <= SpriteWidth(gData.ForeGround) / 2 * -1) then
	begin
		SpriteSetX(gData.foreground, 0);
	end;


	if (SpriteX(gdata.background) <= SpriteWidth(gData.background) / 2 * -1) then
	begin
		SpriteSetX(gData.background, 0);
	end;
end;

procedure CheckForCollisions(var toUpdate: GameData);
var
	i: Integer;
begin
	if (SpriteCollision(toUpdate.player, toUpdate.foreground)) or (SpriteY(toUpdate.player) < 0) then
	begin
		toUpdate.isDead := true;
		exit;
	end;

	for i := Low(toUpdate.Poles) to High(toUpdate.Poles) do
	begin
		if SpriteCollision(toUpdate.player, toUpdate.Poles[i].Pole) then
		begin
			toUpdate.isDead := true;
			exit;
		end;
	end;
end;

procedure UpdatePlayer(var toUpdate: Sprite);
begin
	UpdateRotation(toUpdate);
	UpdateVelocity(toUpdate);
end;

procedure HandleInput(var toUpdate: Sprite);
begin
	if MouseClicked(LeftButton) then
	begin
		SpriteSetDy(toUpdate, SpriteDy(toUpdate) + (JUMP_RECOVERY_BOOST * -1));
	end;
end;

procedure UpdatePoles(var myGame: GameData);
var
	i: Integer;
begin
	for i:= Low(myGame.Poles) to High(myGame.Poles) do
	begin
		UpdateSprite(myGame.Poles[i].Pole);

		if SpriteX (myGame.Poles[i].Pole) < (SpriteX(myGame.player)) then
		begin
			if (myGame.Poles[i].ScoreLimiter = true) then
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
	if not (gData.isDead) then
	begin
		CheckForCollisions(gData);
		HandleInput(gData.player);
		UpdateBackground(gdata);
		UpdatePlayer(gData.player);
		UpdatePoles(gData);
	end
	else //The player has died :(
	begin
		SetUpGame(gData);
	end;
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
	DrawSprite(gData.Background);
	DrawPoles(gData.Poles);
	DrawSprite(gData.ForeGround);
	DrawSprite(gData.player);
	DrawText(IntToStr(gData.score), ColorWhite, 'game font', 10, 0);
end;

procedure Main();
var
	gData: GameData;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
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
