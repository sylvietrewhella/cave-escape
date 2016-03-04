program GameMain;
uses SwinGame, sgTypes, sgSprites;

type

	BackgroundData = record
		fixedBackground: Sprite;
		scrollingBackground: Sprite;
	end;

procedure LoadResources();
begin
	LoadBitmapNamed('bg_day', 'bg_day.png');
	LoadBitmapNamed('scrolling_bg', 'scrolling_bg.png');
	LoadFontNamed('game font', 'arial.ttf', 48);
end;

procedure SetUpGame(var backgroundData: BackgroundData);
begin
	backgroundData.fixedBackground := CreateSprite(BitmapNamed('bg_day'));
	backgroundData.scrollingBackGround := CreateSprite(BitmapNamed('scrolling_bg'));
	SpriteSetX(backgroundData.scrollingBackGround, 0);
 	SpriteSetY(backgroundData.scrollingBackGround, BitmapHeight(BitmapNamed('bg_day')) - BitmapHeight(BitmapNamed('scrolling_bg')));
 	SpriteSetX(backgroundData.fixedBackground, 0);
 	SpriteSetY(backgroundData.fixedBackground, 0);
end;

procedure UpdateBackground(var backgroundData: BackgroundData);
begin
	SpriteSetX(backgroundData.scrollingBackground, SpriteX(backgroundData.scrollingBackground) - 1);
	if (SpriteX(backgroundData.scrollingBackground) <= (SpriteWidth(backgroundData.scrollingBackground) / 2) * -1) then
	begin
		SpriteSetX(backgroundData.scrollingBackground, 0);
	end;
end;

procedure DrawBackground(const backgroundData: BackgroundData);
begin
	DrawSprite(backgroundData.fixedBackground);
	DrawSprite(backgroundData.scrollingBackground);
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
    DrawBackground(bgData);
    DrawFramerate(0,0);
    
    RefreshScreen(60);
  until WindowCloseRequested();
end;

begin
  Main();
end.
