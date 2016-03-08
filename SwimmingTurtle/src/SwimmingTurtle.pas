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
		UpPole: Sprite;
		DownPole: Sprite;
	end;

	Poles = array [0..3] of PoleData;

	GameData = record
		Player: Sprite;
		foreroof: Sprite;
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
	LoadBitmapNamed('foreroof', 'foreroof.png');
	LoadFontNamed('game font', 'GoodDog.otf', 48);

	LoadMusic('MagicalNight.ogg');
end;

function GetRandomPoles(): PoleData;
var
	i: Integer;
begin
	i := Rnd(3);
	case i  of
			 0 :
			 begin
				 result.UpPole := CreateSprite(BitmapNamed('upward_pole_1'));
				 SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole));
				 result.DownPole := CreateSprite(BitmapNamed('downward_pole_2'));
				 SpriteSetY(result.DownPole, 0);
				 result.ScoreLimiter := true;
			 end;
			 1 :
			 begin
				 result.UpPole := CreateSprite(BitmapNamed('upward_pole_2'));
 				SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole) - RND(BitmapHeight(BitmapNamed('Foreground'))));
 				result.DownPole := CreateSprite(BitmapNamed('downward_pole_2'));
 				SpriteSetY(result.DownPole, 0 + RND(BitmapHeight(BitmapNamed('foreroof'))));
 				result.ScoreLimiter := true;
			 end;
			 2 :
			 begin
				 result.UpPole := CreateSprite(BitmapNamed('upward_pole_1'));
				 SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole) - RND(BitmapHeight(BitmapNamed('Foreground'))));
				 result.DownPole := CreateSprite(BitmapNamed('downward_pole_1'));
				 SpriteSetY(result.DownPole, 0 + RND(BitmapHeight(BitmapNamed('foreroof'))));
				 result.ScoreLimiter := true;
			 end;
		end;
		SpriteSetX(result.UpPole, ScreenWidth() + RND(1200));
		SpriteSetDx(result.UpPole, -2);
		SpriteSetDy(result.UpPole, 0);
		SpriteSetX(result.DownPole, SpriteX(result.UpPole));
		SpriteSetDx(result.DownPole, -2);
		SpriteSetDy(result.DownPole, 0);
end;

function GetNewPlayer(): Sprite;
begin
	result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
	SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
	SpriteSetY(result, ScreenHeight() / 2);
	SpriteSetSpeed(result, 0.5);
	SpriteStartAnimation(result, 'Fly');
	SpriteAddValue(result, 'VerticalVelocity', 0);
end;

procedure SetUpParallaxBackground(var background, foreground, foreroof: Sprite);
begin
	background := CreateSprite(BitmapNamed('background'));
	SpriteSetX(background, 0);
	SpriteSetY(background, 0);
	SpriteSetDx(background, -1);

	foreground := CreateSprite(BitmapNamed('Foreground'), AnimationScriptNamed('ForegroundAminations'));
	SpriteSetX(foreground, 0);
	SpriteSetY(foreground, ScreenHeight() - SpriteHeight(foreground));
	SpriteSetDx(foreground, -2);
	foreroof := CreateSprite(BitmapNamed('foreroof'));
	SpriteSetX(foreroof, 0);
	SpriteSetY(foreroof, -5);
	SpriteSetDx(foreroof, -2);
end;

procedure SetUpGame(var gData: GameData);
var
	i: Integer;
begin
	for i:= Low(gData.Poles) to High(gData.Poles) do
	begin
		gData.Poles[i] := GetRandomPoles();
	end;
	gData.player := GetNewPlayer();
	gData.Score := 0;
	gData.isDead := false;
	SetUpParallaxBackground(gData.background, gData.foreground, gData.foreroof);

	SpriteStartAnimation(gData.foreground, 'Fire');
end;

procedure UpdateRotation(var toRotate: Sprite);
var
	rotationPercentage: Double;
begin
	rotationPercentage := SpriteValue(toRotate, 'VerticalVelocity')/MAX_SPEED;
	SpriteSetRotation(toRotate, rotationPercentage * MAX_ROTATION_ANGLE);
end;

procedure UpdateVelocity(var toUpdate: Sprite);
begin
	SpriteSetValue(toUpdate, 'VerticalVelocity', SpriteValue(toUpdate, 'VerticalVelocity') + GRAVITY);

	if SpriteValue(toUpdate, 'VerticalVelocity') > MAX_SPEED then
	begin
		SpriteSetValue(toUpdate, 'VerticalVelocity', MAX_SPEED);
	end
	else if (SpriteValue(toUpdate, 'VerticalVelocity') < MAX_SPEED * -1) then
	begin
		SpriteSetValue(toUpdate, 'VerticalVelocity', MAX_SPEED * -1);
	end;
	SpriteSetY(toUpdate, SpriteY(toUpdate) + SpriteValue(toUpdate, 'VerticalVelocity'));
end;

procedure UpdateBackground(var gData: GameData);
begin
	UpdateSprite(gData.foreGround);
	UpdateSprite(gData.foreroof);
	updateSprite(gData.background);
	if (SpriteX(gdata.foreground) <= SpriteWidth(gData.ForeGround) / 2 * -1) then
	begin
		SpriteSetX(gData.foreground, 0);
		SpriteSetX(gData.foreroof, 0);
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
		if SpriteCollision(toUpdate.player, toUpdate.Poles[i].UpPole) or SpriteCollision(toUpdate.player, toUpdate.Poles[i].DownPole)then
		begin
			toUpdate.isDead := true;
			exit;
		end;
	end;
end;

procedure UpdatePlayer(var toUpdate: Sprite);
begin
	// UpdateRotation(toUpdate);
	UpdateVelocity(toUpdate);
	UpdateSprite(toUpdate);
end;

procedure HandleInput(var toUpdate: Sprite);
begin
	if MouseClicked(LeftButton) then
	begin
		SpriteSetValue(toUpdate, 'VerticalVelocity', SpriteValue(toUpdate, 'VerticalVelocity') + -(JUMP_RECOVERY_BOOST));
	end;
end;

procedure UpdatePoles(var myGame: GameData);
var
	i: Integer;
begin
	for i:= Low(myGame.Poles) to High(myGame.Poles) do
	begin
		UpdateSprite(myGame.Poles[i].UpPole);
		UpdateSprite(myGame.Poles[i].DownPole);

		if SpriteX (myGame.Poles[i].UpPole) < (SpriteX(myGame.player)) then
		begin
			if (myGame.Poles[i].ScoreLimiter = true) then
			begin
				myGame.Poles[i].ScoreLimiter := false;
				myGame.Score += 1;
			end;
		end;

		if (SpriteOffscreen(myGame.Poles[i].UpPole)) and (SpriteOffscreen(myGame.Poles[i].DownPole))then
		begin
			SpriteSetX(myGame.Poles[i].UpPole, ScreenWidth() + RND(1200));
			SpriteSetX(myGame.Poles[i].DownPole, SpriteX(myGame.Poles[i].UpPole));
			SpriteSetY(myGame.Poles[i].UpPole, ScreenHeight() - SpriteHeight(myGame.Poles[i].UpPole) - RND(BitmapHeight(BitmapNamed('Foreground'))));
			SpriteSetY(myGame.Poles[i].DownPole, 0 + RND(BitmapHeight(BitmapNamed('foreroof'))));
		end;
	end;
end;

procedure ResetGame(var gData: GameData);
var
	i: Integer;
begin
	gData.Player := GetNewPlayer();
	for i:= Low(gData.Poles) to High(gData.Poles) do
	begin
		SpriteSetX(gData.Poles[i].UpPole, ScreenWidth() + RND(1200));
		SpriteSetX(gData.Poles[i].DownPole, SpriteX(gData.Poles[i].UpPole));
		SpriteSetY(gData.Poles[i].UpPole, ScreenHeight() - SpriteHeight(gData.Poles[i].UpPole) - RND(BitmapHeight(BitmapNamed('Foreground'))));
	end;
	gData.isDead := false;
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
		ResetGame(gData);
	end;
end;

procedure DrawPoles(const myPoles: Poles);
var
	i: Integer;
begin
	for i:= Low(myPoles) to High(myPoles) do
	begin
		DrawSprite(myPoles[i].UpPole);
		DrawSprite(myPoles[i].DownPole);
	end;
end;

procedure DrawGame(const gData: GameData);
begin
	DrawSprite(gData.Background);
	DrawPoles(gData.Poles);
	DrawSprite(gData.foreroof);
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
