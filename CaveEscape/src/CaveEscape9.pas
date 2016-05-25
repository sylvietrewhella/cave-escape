program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
  GRAVITY = 0.08;
  JUMP_RECOVERY_BOOST = 2;
  MAX_SPEED = 5;
  FOREGROUND_FOREROOF_POLE_SCROLL_SPEED = -2;
  BACKGROUND_SCROLL_SPEED = -1;

type
  PoleData = record
    ScoreLimiter: Boolean;
    UpPole: Sprite;
    DownPole: Sprite;
  end;

  GameState = (Menu, Play);

  Poles = array [0..3] of PoleData;

  GameData = record
    Player: Sprite;
    Foreroof: Sprite;
    Foreground: Sprite;
    Background: Sprite;
    IsDead: Boolean;
    Score: Integer;
    Poles: Poles;
    State: GameState;
  end;

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

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
end;

procedure SetUpBackground(var Background, Foreground, Foreroof: Sprite);
begin
  Background := CreateSprite(BitmapNamed('Background'));
  SpriteSetX(Background, 0);
  SpriteSetY(Background, 0);
  SpriteSetDx(Background, BACKGROUND_SCROLL_SPEED);

  Foreground := CreateSprite(BitmapNamed('Foreground'), AnimationScriptNamed('ForegroundAminations'));
  SpriteSetX(Foreground, 0);
  SpriteSetY(Foreground, ScreenHeight() - SpriteHeight(Foreground));
  SpriteSetDx(Foreground, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  Foreroof := CreateSprite(BitmapNamed('Foreroof'));
  SpriteSetX(Foreroof, 0);
  SpriteSetY(Foreroof, 0);
  SpriteSetDx(Foreroof, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
end;

procedure SetUpGame(var gData: GameData);
var
  i: Integer;
begin
  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);

  for i:= Low(gData.Poles) to High(gData.Poles) do
  begin
    gData.Poles[i] := GetRandomPoles();
  end;
  gData.player := GetNewPlayer();
  gData.Score := 0;
  gData.IsDead := false;
  gData.State := Menu;
  SetUpBackground(gData.Background, gData.Foreground, gData.Foreroof);

  SpriteStartAnimation(gData.Foreground, 'Fire');
end;

procedure UpdateVelocity(var toUpdate: Sprite);
begin
  SpriteSetDy(toUpdate, SpriteDy(toUpdate) + GRAVITY);

  if SpriteDy(toUpdate) > MAX_SPEED then
  begin
    SpriteSetDy(toUpdate, MAX_SPEED);
  end
  else if SpriteDy(toUpdate) < -(MAX_SPEED) then
  begin
    SpriteSetDy(toUpdate, -(MAX_SPEED));
  end;
end;

procedure UpdateBackground(var gData: GameData);
begin
  UpdateSprite(gData.foreGround);
  UpdateSprite(gData.Foreroof);
  updateSprite(gData.Background);
  if (SpriteX(gdata.Foreground) <= -(SpriteWidth(gData.ForeGround) / 2)) then
  begin
    SpriteSetX(gData.Foreground, 0);
    SpriteSetX(gData.Foreroof, 0);
  end;
  if (SpriteX(gdata.Background) <= -(SpriteWidth(gData.Background) / 2)) then
  begin
    SpriteSetX(gData.Background, 0);
  end;
end;

procedure CheckForCollisions(var toUpdate: GameData);
var
  i: Integer;
begin
  if (SpriteCollision(toUpdate.player, toUpdate.Foreground)) or (SpriteCollision(toUpdate.player, toUpdate.Foreroof)) then
  begin
    toUpdate.IsDead := true;
    exit;
  end;

  for i := Low(toUpdate.Poles) to High(toUpdate.Poles) do
  begin
    if SpriteCollision(toUpdate.player, toUpdate.Poles[i].UpPole) or SpriteCollision(toUpdate.player, toUpdate.Poles[i].DownPole)then
    begin
      toUpdate.IsDead := true;
      exit;
    end;
  end;
end;

procedure UpdatePlayer(var toUpdate: Sprite; state: GameState);
begin
  if (state = Play) then
  begin
    UpdateVelocity(toUpdate);
  end;
  UpdateSprite(toUpdate);
end;

procedure HandleInput(var toUpdate: Sprite; var state: GameState);
begin
  if KeyTyped(SpaceKey) and (state = Play) then
  begin
    SpriteSetDy(toUpdate, SpriteDy(toUpdate) + -(JUMP_RECOVERY_BOOST));
  end
  else if KeyTyped(SpaceKey) then
  begin
    state := Play;
  end;
end;

procedure ResetPoleData(var toReset: PoleData);
begin
  FreeSprite(toReset.UpPole);
  FreeSprite(toReset.DownPole);
  toReset := GetRandomPoles();
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

    if (SpriteOffscreen(myGame.Poles[i].UpPole)) and (SpriteOffscreen(myGame.Poles[i].DownPole) and (myGame.Poles[i].ScoreLimiter = false))then
    begin
      ResetPoleData(myGame.Poles[i]);
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
    ResetPoleData(gData.Poles[i]);
  end;
  gData.IsDead := false;
  gData.Score := 0;
end;

procedure MarkPoleForMovement(var poles: Poles);
var
  i: Integer;
  releaseDistance: Double;
begin
  releaseDistance := RND(SpriteWidth(poles[0].UpPole)) + SpriteWidth(poles[0].UpPole);
  for i := Low(poles) to High(poles) do
  begin
    if SpriteX(poles[i].UpPole) = ScreenWidth() then
    begin
      if (i > 0) and ((SpriteX(poles[i].UpPole) - SpriteX(poles[i - 1].UpPole)) > releaseDistance) then
      begin
        SpriteSetDx(poles[i].UpPole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
        SpriteSetDx(poles[i].DownPole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
        break;
      end
      else if (i = 0) then
      begin
        SpriteSetDx(poles[i].UpPole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
        SpriteSetDx(poles[i].DownPole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
        break;
      end;
    end;
  end;
end;

procedure UpdateGame(var gData: GameData);
begin
  if not (gData.IsDead) then
  begin
    CheckForCollisions(gData);
    HandleInput(gData.player, gdata.State);
    UpdateBackground(gdata);
    UpdatePlayer(gData.player, gdata.State);
    if (gdata.State = Play) then
    begin
      MarkPoleForMovement(gdata.poles);
      UpdatePoles(gData);
    end;
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
  DrawSprite(gData.Foreroof);
  DrawSprite(gData.ForeGround);
  DrawSprite(gData.player);
  if (gData.State = Play) then
  begin
    DrawText(IntToStr(gData.score), ColorWhite, 'GameFont', 10, 0);
  end
  else if (gData.State = Menu) then
  begin
    DrawBitmap(BitmapNamed('Logo'), 0, 40);
    DrawText('PRESS SPACE!',
    ColorWhite,
    'GameFont',
    ScreenWidth() / 2 - TextWidth(FontNamed('GameFont'), 'PRESS SPACE!') / 2,
    SpriteY(gData.Player) + TextHeight(FontNamed('GameFont'), ' ') * 2);
  end;
end;

procedure Main();
var
  gData: GameData;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
  OpenAudio();
  SetUpGame(gData);

  FadeMusicIn('GameMusic', -1, 15000);

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
