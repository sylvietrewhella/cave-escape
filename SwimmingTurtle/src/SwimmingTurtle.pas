program GameMain;
uses SwinGame, sgTypes, sgSprites;

const
	GRAVITY = 0.1;
	TERMINAL_VELOCITY = 300;

type

	BackgroundData = record
		fixedBackground: Sprite;
		scrollingBackground: Sprite;
	end;

	TurtleData = record
		turtleSprite: Sprite;
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
	LoadBitmapNamed('turtle', 'turtle.png');
	LoadBitmapNamed('bg_day', 'background.png');
	LoadBitmapNamed('scrolling_bg', 'scrollingBackground.png');
	LoadFontNamed('game font', 'arial.ttf', 48);
end;

function GetNewPlayerData(): PlayerData;
begin
	result.turtleData.turtleSprite := CreateSprite(BitmapNamed('turtle'));
	result.turtleData.verticalSpeed := 0;
	SpriteSetX(result.turtleData.turtleSprite, (ScreenWidth() / 2 - SpriteWidth(result.turtleData.turtleSprite)));
	SpriteSetY(result.turtleData.turtleSprite, (ScreenHeight() / 2));
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

procedure Fall(var turtleData: TurtleData);
begin
	turtleData.verticalSpeed := turtleData.verticalSpeed + GRAVITY;
	WriteLn(turtleData.verticalSpeed:4:2);
	if turtleData.verticalSpeed > TERMINAL_VELOCITY then
	begin
		turtleData.verticalSpeed := TERMINAL_VELOCITY;
	end;
	SpriteSetY(turtleData.turtleSprite, (SpriteY(turtleData.turtleSprite) + turtleData.verticalSpeed));
end;

procedure UpdateBackground(var gData: GameData);
begin
	SpriteSetX(gData.bgData.scrollingBackground, SpriteX(gData.bgData.scrollingBackground) - 1);
	if (SpriteX(gData.bgData.scrollingBackground) <= (SpriteWidth(gData.bgData.scrollingBackground) / 2) * -1) then
	begin
		SpriteSetX(gData.bgData.scrollingBackground, 0);
	end;
end;

procedure UpdateBird(var turtle: TurtleData);
begin
	Fall(turtle);
end;

procedure UpdateGame(var gData: GameData);
begin
	UpdateBackground(gdata);
	UpdateBird(gData.playerData.turtleData);
end;

procedure DrawPlayer(const playerData: PlayerData);
begin
	DrawSprite(playerData.turtleData.turtleSprite);
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
