program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
  GRAVITY = 0.08;
  MAX_SPEED = 5;
  JUMP_RECOVERY_BOOST = 2;
  FOREGROUND_FOREROOF_POLE_SCROLL_SPEED = -2;

type
    PoleData = record
      UpPole: Sprite;
      DownPole: Sprite;
    end;

    Poles = array [0..3] of PoleData;

function GetRandomPoles(): PoleData;
begin
    result.UpPole := CreateSprite(BitmapNamed('UpPole'));
    result.DownPole := CreateSprite(BitmapNamed('DownPole'));
    SpriteSetX(result.UpPole, ScreenWidth());
    SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole) - RND(BitmapHeight(BitmapNamed('Foreground'))));
    SpriteSetX(result.DownPole, SpriteX(result.UpPole));
    SpriteSetY(result.DownPole, RND(BitmapHeight(BitmapNamed('Foreroof'))));
    SpriteSetDx(result.UpPole, 0);
    SpriteSetDx(result.DownPole, 0);
    result.ScoreLimiter := true;
end;

procedure ResetPoleData(var toReset: PoleData);
begin
  SpriteSetX(toReset.UpPole, ScreenWidth() + RND(1200));
  SpriteSetX(toReset.DownPole, SpriteX(toReset.UpPole));
  SpriteSetY(toReset.UpPole, ScreenHeight() - SpriteHeight(toReset.UpPole));
  SpriteSetY(toReset.DownPole, 0);
end;

procedure UpdatePoles(var poles: array of PoleData);
var
  i: Integer;
begin
  for i:= Low(Poles) to High(Poles) do
  begin
    UpdateSprite(Poles[i].UpPole);
    UpdateSprite(Poles[i].DownPole);

    if (SpriteOffscreen(Poles[i].UpPole)) and (SpriteOffscreen(Poles[i].DownPole))then
    begin
      ResetPoleData(Poles[i]);
    end;
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

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
end;

procedure HandleInput(var toUpdate: Sprite);
begin
  if KeyTyped(SpaceKey) then
  begin
    SpriteSetDy(toUpdate, SpriteDy(toUpdate)-JUMP_RECOVERY_BOOST);
  end;
end;

procedure UpdateVelocity(var toUpdate: Sprite);
begin
  SpriteSetDy(toUpdate, SpriteDy(toUpdate) + GRAVITY);
  if SpriteDy(toUpdate) > MAX_SPEED then
  begin
    SpriteSetDy(toUpdate, MAX_SPEED);
  end
  else if (SpriteDy(toUpdate) < -(MAX_SPEED)) then
  begin
     SpriteSetDy(toUpdate,  -(MAX_SPEED));
  end;
end;

procedure Main();
var
  player: Sprite;
  myPoles: Poles;
  i: Integer;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
  OpenAudio();
  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);

  for i:= Low(myPoles) to High(myPoles) do
  begin
    myPoles[i] := GetRandomPoles();
  end;

  player := GetNewPlayer();

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);

    UpdateVelocity(player);
    HandleInput(player);

    UpdateSprite(player);
    UpdatePoles(myPoles);

    DrawPoles(myPoles);
    DrawSprite(player);

    RefreshScreen();

  until WindowCloseRequested();
end;

begin
  Main();
end.
