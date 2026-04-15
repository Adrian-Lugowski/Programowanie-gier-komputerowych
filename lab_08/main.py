import pyray as rl
from enum import Enum
from ship import Ship
from asteroid import Asteroid, AsteroidSize
from bullet import Bullet
from explosion import Explosion
import utils
import config
import random

class State(Enum):
    MENU = 1
    GAME = 2
    GAME_OVER = 3

class Game:
    def __init__(self):
        rl.init_window(utils.SCREEN_W, utils.SCREEN_H, "ASTEROIDS")
        rl.set_target_fps(60)
        rl.init_audio_device()

        self.state = State.MENU
        self.score = 0
        self.best = 0
        self.game_won = False

        self.player = None
        self.asteroids = []
        self.bullets = []
        self.explosions = []

        self.transparent = (0, 0, 0, 150)

        self.shoot_sound = rl.load_sound("assets/shoot.wav")
        self.explode_sound = rl.load_sound("assets/explode.wav")

        menu = rl.load_image("assets/menu.jpg")
        rl.image_resize(menu, utils.SCREEN_W, utils.SCREEN_H)
        self.menu_texture = rl.load_texture_from_image(menu)
        rl.unload_image(menu)

        background = rl.load_image("assets/stars.jpg")
        rl.image_resize(background, utils.SCREEN_W, utils.SCREEN_H)
        self.background_texture = rl.load_texture_from_image(background)
        rl.unload_image(background)

    def init_game(self):
        self.score = 0
        self.game_won = False
        self.player = Ship(utils.SCREEN_W // 2, utils.SCREEN_H // 2)
        self.bullets.clear()
        self.explosions.clear()
        self.asteroids.clear()

        for _ in range(3):
            x = random.uniform(0, utils.SCREEN_W)
            y = random.uniform(0, utils.SCREEN_H)
            self.asteroids.append(Asteroid(x, y, 3))

    def run(self):
        while not rl.window_should_close():
            if self.state == State.MENU:
                self.updatemenu()
                self.drawmenu()
            elif self.state == State.GAME:
                self.updategame()
                self.drawgame()
            elif self.state == State.GAME_OVER:
                self.updategameover()
                self.drawgameover()

        rl.unload_texture(self.background_texture)
        rl.unload_texture(self.menu_texture)

        rl.unload_sound(self.shoot_sound)
        rl.unload_sound(self.explode_sound)
        rl.close_audio_device()
        rl.close_window()

    def updatemenu(self):
        if rl.is_key_pressed(rl.KeyboardKey.KEY_SPACE):
            self.init_game()
            self.state = State.GAME

    def drawmenu(self):
        rl.begin_drawing()
        rl.clear_background(rl.RAYWHITE)
        rl.draw_texture(self.menu_texture, 0, 0, rl.WHITE)
        title_text = "ASTEROIDS"
        rl.draw_text(title_text, utils.SCREEN_W // 2 - rl.measure_text(title_text , 60) // 2, utils.SCREEN_H // 2 - 100, 60, rl.LIGHTGRAY)
        menu_text = "PRESS SPACE TO START"
        rl.draw_text(menu_text, utils.SCREEN_W // 2 - rl.measure_text(menu_text, 40) // 2, utils.SCREEN_H // 2, 40, rl.LIGHTGRAY)
        rl.end_drawing()

    def updategame(self):
        dt = rl.get_frame_time()

        if self.player:
            self.player.update(dt)
            self.player.wrap()

        if rl.is_key_pressed(rl.KeyboardKey.KEY_SPACE) and self.player:
            dir_x, dir_y = utils.rotate_point(0, -15, self.player.angle)
            x = self.player.x + dir_x
            y = self.player.y + dir_y
            self.bullets.append(Bullet(x, y, self.player.angle))
            rl.play_sound(self.shoot_sound)

        for ast in self.asteroids:
            ast.update(dt)
            ast.wrap()

        for bullet in self.bullets:
            bullet.update(dt)
            bullet.wrap()

        for exp in self.explosions:
            exp.update(dt)

        new_asteroids = []
        for b in self.bullets:
            for a in self.asteroids:
                if b.alive and a.alive:
                    if utils.check_collision_circles(b.x, b.y, b.radius, a.x, a.y, a.radius):
                        b.alive = False
                        a.alive = False
                        self.score += -a.level + 4
                        new_asteroids.extend(a.split())
                        self.explosions.append(Explosion(a.x, a.y, a.radius))
                        rl.play_sound(self.explode_sound)

        self.asteroids.extend(new_asteroids)

        if self.player:
            for a in self.asteroids:
                if a.alive:
                    if utils.check_collision_circles(self.player.x, self.player.y, config.SHIP_SIZE, a.x, a.y,a.radius):
                        self.explosions.append(Explosion(self.player.x, self.player.y, config.SHIP_SIZE * 2))
                        rl.play_sound(self.explode_sound)
                        self.player = None
                        self.game_won = False
                        if self.score > self.best:
                            self.best = self.score
                        self.state = State.GAME_OVER
                        break

        self.bullets = [b for b in self.bullets if b.alive]
        self.asteroids = [a for a in self.asteroids if a.alive]
        self.explosions = [e for e in self.explosions if e.alive]

        if len(self.asteroids) == 0 and self.state != State.GAME_OVER:
            self.game_won = True
            if self.score > self.best:
                self.best = self.score
            self.state = State.GAME_OVER

    def drawgame(self):
        rl.begin_drawing()
        rl.clear_background(rl.RAYWHITE)
        rl.draw_texture(self.background_texture, 0, 0, rl.WHITE)

        for ast in self.asteroids:
            ast.draw()

        for exp in self.explosions:
            exp.draw()

        for bullet in self.bullets:
            bullet.draw()

        if self.player:
            self.player.draw()

        self.draw_hud()

        rl.end_drawing()

    def draw_hud(self):
        rl.draw_text("Strzalki: Ruch i obrot  |  Z: Hamulec Awaryjny | SPACJA: Strzal", 10, 10, 18, rl.LIGHTGRAY)
        rl.draw_text(f"Score: {self.score}", utils.SCREEN_W - 150, 10, 30, rl.LIGHTGRAY)
        rl.draw_text(f"Best: {self.best}", utils.SCREEN_W - 150, 50, 20, rl.LIGHTGRAY)

    def updategameover(self):
        if rl.is_key_pressed(rl.KeyboardKey.KEY_SPACE):
            self.state = State.MENU

    def drawgameover(self):
        rl.begin_drawing()
        rl.draw_texture(self.background_texture, 0, 0, rl.WHITE)

        for ast in self.asteroids:
            ast.draw()
        for exp in self.explosions:
            exp.draw()

        rl.draw_rectangle(0, 0, utils.SCREEN_W, utils.SCREEN_H, self.transparent)

        title = "ZWYCIESTWO!" if self.game_won else "KONIEC GRY"
        color = rl.GREEN if self.game_won else rl.RED

        rl.draw_text(title, utils.SCREEN_W // 2 - rl.measure_text(title, 50) // 2, utils.SCREEN_H // 2 - 80, 50, color)

        score_text = f"Wynik: {self.score}   Best: {self.best}"
        rl.draw_text(score_text, utils.SCREEN_W // 2 - rl.measure_text(score_text, 30) // 2, utils.SCREEN_H // 2, 30, rl.LIGHTGRAY)

        restart_text = "Nacisnij SPACJE aby wrocic do menu"
        rl.draw_text(restart_text, utils.SCREEN_W // 2 - rl.measure_text(restart_text, 20) // 2, utils.SCREEN_H // 2 + 50, 20, rl.GRAY)

        rl.end_drawing()


if __name__ == "__main__":
    game = Game()
    game.run()