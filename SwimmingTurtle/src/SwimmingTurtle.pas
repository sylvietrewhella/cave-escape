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
	LoadResources();
	backgroundData.fixedBackground := CreateSprite(BitmapNamed('bg_day'));
	backgroundData.scrollingBackGround := CreateSprite(BitmapNamed('scrolling_bg'));
	SpriteSetX(backgroundData.scrollingBackGround, 0);
 	SpriteSetY(backgroundData.scrollingBackGround, BitmapHeight(BitmapNamed('bg_day')) - BitmapHeight(BitmapNamed('scrolling_bg')));
 	SpriteSetX(backgroundData.fixedBackground, 0);
 	SpriteSetY(backgroundData.fixedBackground, 0);
end;

procedure DrawScrollingBackground(var bgSprite: Sprite);
begin
	SpriteSetX(bgSprite, SpriteX(bgSprite) - 1);
	DrawSprite(bgSprite);
	if (SpriteX(bgSprite) <= (SpriteWidth(bgSprite) / 2) * -1) then
	begin
		SpriteSetX(bgSprite, 0);
	end;
end;

procedure Main();
var
	bgData: BackgroundData;
begin
  OpenGraphicsWindow('Flappy Bird', 368, 653);
  SetUpGame(bgData);
  repeat // The game loop...
    ProcessEvents();
    
    ClearScreen(ColorWhite);

    DrawSprite(bgData.fixedBackground);

    DrawScrollingBackground(bgData.scrollingBackGround );
    DrawFramerate(0,0);
    
    RefreshScreen(60);
  until WindowCloseRequested();
end;

begin
  Main();
end.