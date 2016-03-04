program GameMain;
uses SwinGame, sgTypes, sgSprites;

type

	BackgroundData = record
		fixedBackground: Sprite;
		scrollingBackground: Sprite;
	end;

	TurtleData = record
		turtleSprite: Sprite;
	end;

	PlayerData = record
		turtleData: TurtleData;
		score: Integer;
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

procedure SetUpGame(var backgroundData: BackgroundData);
begin
	backgroundData := GetNewBackgroundData();
end;

procedure UpdateBackground(var backgroundData: BackgroundData);
begin
	SpriteSetX(backgroundData.scrollingBackground, SpriteX(backgroundData.scrollingBackground) - 1);
	if (SpriteX(backgroundData.scrollingBackground) <= (SpriteWidth(backgroundData.scrollingBackground) / 2) * -1) then
	begin
		SpriteSetX(backgroundData.scrollingBackground, 0);
	end;
end;

procedure DrawBackground(const fixedBackground, scrollingBackground: Sprite);
begin
	DrawSprite(fixedBackground);
	DrawSprite(scrollingBackground);
end;

procedure DrawGame(const backgroundData: BackgroundData);
begin
	DrawBackground(backgroundData.fixedBackground, backgroundData.scrollingBackground);
	DrawFramerate(0,0);
end;

procedure Main();
var
	bgData: BackgroundData;

begin
  OpenGraphicsWindow('Flappy Bird', 368, 653);
  LoadResources();
  SetUpGame(bgData);

  repeat // The game loop...
    ProcessEvents();

    ClearScreen(ColorWhite);
    UpdateBackground(bgData);
    DrawGame(bgData);


    RefreshScreen(60);
  until WindowCloseRequested();
end;

begin
  Main();
end.
