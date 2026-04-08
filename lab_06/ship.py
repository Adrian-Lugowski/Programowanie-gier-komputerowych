import pyray as rl
import math
import utils
import config


class Ship:
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.angle = 0.0
        self.vx = 0.0
        self.vy = 0.0

        self.verts = [(0, -15), (-10, 10), (10, 10)]
        self.flame_verts = [(0, 20), (-5, 10), (5, 10)]

        self.is_thrusting = False

    def wrap(self):
        self.x %= utils.SCREEN_W
        self.y %= utils.SCREEN_H

    def update(self, dt):
        self.is_thrusting = False

        if rl.is_key_down(rl.KeyboardKey.KEY_RIGHT):
            self.angle += config.ROT_SPEED * dt
        if rl.is_key_down(rl.KeyboardKey.KEY_LEFT):
            self.angle -= config.ROT_SPEED * dt

        if rl.is_key_down(rl.KeyboardKey.KEY_UP):
            self.is_thrusting = True
            dir_x, dir_y = utils.rotate_point(0, -1, self.angle)
            self.vx += dir_x * config.THRUST * dt
            self.vy += dir_y * config.THRUST * dt

        speed = math.hypot(self.vx, self.vy)

        if speed > 0:
            if rl.is_key_down(rl.KeyboardKey.KEY_Z):
                drop = config.BRAKE_FORCE * dt
            else:
                drop = config.FRICTION * dt

            new_speed = max(0, speed - drop)
            ratio = new_speed / speed
            self.vx *= ratio
            self.vy *= ratio

        speed = math.hypot(self.vx, self.vy)
        if speed > config.MAX_SPEED:
            ratio = config.MAX_SPEED / speed
            self.vx *= ratio
            self.vy *= ratio

        self.x += self.vx * dt
        self.y += self.vy * dt

    def draw(self):
        ghosts = utils.ghost_positions(self.x, self.y, config.SHIP_SIZE)

        for gx, gy in ghosts:
            screen_verts = []
            for vx, vy in self.verts:
                rx, ry = utils.rotate_point(vx, vy, self.angle)
                screen_verts.append((gx + rx, gy + ry))

            rl.draw_triangle_lines(
                rl.Vector2(screen_verts[0][0], screen_verts[0][1]),
                rl.Vector2(screen_verts[1][0], screen_verts[1][1]),
                rl.Vector2(screen_verts[2][0], screen_verts[2][1]),
                rl.RAYWHITE
            )

            if self.is_thrusting:
                flame_screen = []
                for fx, fy in self.flame_verts:
                    rx, ry = utils.rotate_point(fx, fy, self.angle)
                    flame_screen.append((gx + rx, gy + ry))

                rl.draw_triangle_lines(
                    rl.Vector2(flame_screen[0][0], flame_screen[0][1]),
                    rl.Vector2(flame_screen[1][0], flame_screen[1][1]),
                    rl.Vector2(flame_screen[2][0], flame_screen[2][1]),
                    rl.ORANGE
                )

            if config.DEBUG:
                rl.draw_line(int(gx), int(gy), int(gx + self.vx * 0.3), int(gy + self.vy * 0.3), rl.RED)

        if config.DEBUG:
            speed = math.hypot(self.vx, self.vy)
            rl.draw_text(f"Speed: {speed:.1f}", 10, 30, 20, rl.GRAY)