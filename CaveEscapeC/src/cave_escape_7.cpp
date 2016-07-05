#include <stdio.h>
#include "SwinGame.h"

#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2
#define FOREGROUND_FOREROOF_POLE_SCROLL_SPEED -2
#define BACKGROUND_SCROLL_SPEED -1
#define NUM_POLES 4

typedef struct pole_data
{
  bool score_limiter;
  sprite up_pole, down_pole;
} pole_data;

typedef struct pole_data poles[NUM_POLES];

typedef struct game_data
{
  sprite player, foreroof, foreground, background;
  bool is_dead;
  int score;
  poles poles;
} game_data;

pole_data get_random_poles()
{
  pole_data result;
  result.up_pole = create_sprite(bitmap_named("UpPole"));
  result.down_pole = create_sprite(bitmap_named("DownPole"));
  sprite_set_x(result.up_pole, screen_width() + rnd(1200));
  sprite_set_y(result.up_pole, screen_height() - sprite_height(result.up_pole));
  sprite_set_x(result.down_pole, sprite_x(result.up_pole));
  sprite_set_y(result.down_pole, 0);
  sprite_set_dx(result.up_pole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  sprite_set_dx(result.down_pole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  result.score_limiter = true;

  return result;
}

sprite get_new_player()
{
  sprite result;
  result = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
  sprite_set_x(result, screen_width() / 2 - sprite_width(result));
  sprite_set_y(result, screen_height() / 2);
  sprite_start_animation(result, "Fly");

  return result;
}

void setup_background(game_data* game)
{
  game->background = create_sprite(bitmap_named("Background"));
  sprite_set_x(game->background, 0);
  sprite_set_y(game->background, 0);
  sprite_set_dx(game->background, BACKGROUND_SCROLL_SPEED);

  game->foreground = create_sprite(bitmap_named("Foreground"), animation_script_named("ForegroundAminations"));
  sprite_set_x(game->foreground, 0);
  sprite_set_y(game->foreground, screen_height() - sprite_height(game->foreground));
  sprite_set_dx(game->foreground, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);

  game->foreroof = create_sprite(bitmap_named("Foreroof"));
  sprite_set_x(game->foreroof, 0);
  sprite_set_y(game->foreroof, 0);
  sprite_set_dx(game->foreroof, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
}

void set_up_game(game_data* game)
{
  int i;

  load_resource_bundle_named("CaveEscape", "CaveEscape.txt", false);
  for (i = 0; i < NUM_POLES; i++)
  {
    game->poles[i] = get_random_poles();
  }
  game->player = get_new_player();
  game->score = 0;
  game->is_dead = false;
  setup_background(game);

  sprite_start_animation(game->foreground, "Fire");
}

void update_velocity(sprite player)
{
  sprite_set_dy(player, sprite_dy(player) + GRAVITY);

  if (sprite_dy(player) > MAX_SPEED)
  {
    sprite_set_dy(player, MAX_SPEED);
  }
  else if (sprite_dy(player) < -(MAX_SPEED))
  {
    sprite_set_dy(player, -(MAX_SPEED));
  }
}

void update_background(game_data* game)
{
  update_sprite(game->foreground);
  update_sprite(game->foreroof);
  update_sprite(game->background);

  if (sprite_x(game->foreground) <= -(sprite_width(game->foreground) / 2))
  {
    sprite_set_x(game->foreground, 0);
    sprite_set_x(game->foreroof, 0);
  }
  if (sprite_x(game->background) <= -(sprite_width(game->background) / 2))
  {
    sprite_set_x(game->background, 0);
  }
}

void check_for_collisions(game_data* game)
{
  int i;

  if (sprite_collision(game->player, game->foreground) || sprite_collision(game->player, game->foreroof))
  {
    game->is_dead = true;
    return;
  }

  for (i = 0; i < NUM_POLES; i++)
  {
    if (sprite_collision(game->player, game->poles[i].up_pole) || sprite_collision(game->player, game->poles[i].down_pole))
    {
      game->is_dead = true;
      return;
    }
  }
}

void update_player(sprite player)
{
  update_velocity(player);
  update_sprite(player);
}

void handle_input(sprite player)
{
  if (key_typed(SPACE_KEY))
  {
    sprite_set_dy(player, sprite_dy(player) - JUMP_RECOVERY_BOOST);
  }
}

void reset_pole_data(pole_data* pole)
{
  pole_data temp = get_random_poles();
  free_sprite(pole->up_pole);
  free_sprite(pole->down_pole);

  *pole = temp;
}

void update_poles(game_data* game)
{
  int i;

  for (i = 0; i < NUM_POLES; i++)
  {
    update_sprite(game->poles[i].up_pole);
    update_sprite(game->poles[i].down_pole);

    if ((sprite_x(game->poles[i].up_pole) < sprite_x(game->player)) && (game->poles[i].score_limiter == true))
    {
      game->poles[i].score_limiter = false;
      game->score++;
    }

    if (sprite_offscreen(game->poles[i].up_pole) && sprite_offscreen(game->poles[i].down_pole) && (game->poles[i].score_limiter == false))
    {
      reset_pole_data(&game->poles[i]);
    }
  }
}

void reset_game(game_data* game)
{
  int i;

  game->player = get_new_player();
  for (i = 0; i < NUM_POLES; i++)
  {
    reset_pole_data(&game->poles[i]);
  }
  game->is_dead = false;
  game->score = 0;
}

void update_game(game_data* game)
{
  if (!game->is_dead)
  {
    check_for_collisions(game);
    handle_input(game->player);
    update_background(game);
    update_player(game->player);
    update_poles(game);
  }
  else
  {
    reset_game(game);
  }
}

void draw_poles(poles poles)
{
  int i;

  for (i = 0; i < NUM_POLES; i++)
  {
    draw_sprite(poles[i].up_pole);
    draw_sprite(poles[i].down_pole);
  }
}

void draw_game(game_data* game)
{
  char str[15];
  sprintf(str, "%d", game->score);

  draw_sprite(game->background);
  draw_poles(game->poles);
  draw_sprite(game->foreroof);
  draw_sprite(game->foreground);
  draw_sprite(game->player);
  draw_text(str, COLOR_WHITE, "GameFont", 10, 0);
}

int main()
{
    game_data game;

    open_graphics_window("Cave Escape", 432, 768);
    set_up_game(&game);

    fade_music_in("GameMusic", -1, 15000);

    do
    {
      process_events();
      clear_screen(ColorWhite);
      update_game(&game);
      draw_game(&game);
      refresh_screen();

    } while(!window_close_requested());

    return 0;
}
