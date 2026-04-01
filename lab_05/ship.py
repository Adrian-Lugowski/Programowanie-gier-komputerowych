import pyray as rl
import math

THRUST = 300.0
FRICTION = 80.0
ROT_SPEED = 3.5
MAX_SPEED = 400.0
BRAKE_FORCE = 400.0

DEBUG = True


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

    def _rotate_point(self, px, py, angle):
        qx = px * math.cos(angle) - py * math.sin(angle)
        qy = px * math.sin(angle) + py * math.cos(angle)
        return qx, qy

    def update(self, dt, screen_w, screen_h):
        self.is_thrusting = False

        if rl.is_key_down(rl.KeyboardKey.KEY_RIGHT):
            self.angle += ROT_SPEED * dt
        if rl.is_key_down(rl.KeyboardKey.KEY_LEFT):
            self.angle -= ROT_SPEED * dt

        if rl.is_key_down(rl.KeyboardKey.KEY_UP):
            self.is_thrusting = True
            dir_x, dir_y = self._rotate_point(0, -1, self.angle)
            self.vx += dir_x * THRUST * dt
            self.vy += dir_y * THRUST * dt

        speed = math.hypot(self.vx, self.vy)

        if speed > 0:
            if rl.is_key_down(rl.KeyboardKey.KEY_Z):
                drop = BRAKE_FORCE * dt
            else:
                drop = FRICTION * dt

            new_speed = max(0, speed - drop)
            ratio = new_speed / speed
            self.vx *= ratio
            self.vy *= ratio

        speed = math.hypot(self.vx, self.vy)
        if speed > MAX_SPEED:
            ratio = MAX_SPEED / speed
            self.vx *= ratio
            self.vy *= ratio

        self.x += self.vx * dt
        self.y += self.vy * dt

    def draw(self):
        screen_verts = []
        for vx, vy in self.verts:
            rx, ry = self._rotate_point(vx, vy, self.angle)
            screen_verts.append((self.x + rx, self.y + ry))

        rl.draw_triangle_lines(
            rl.Vector2(screen_verts[0][0], screen_verts[0][1]),
            rl.Vector2(screen_verts[1][0], screen_verts[1][1]),
            rl.Vector2(screen_verts[2][0], screen_verts[2][1]),
            rl.RAYWHITE
        )

        if self.is_thrusting:
            flame_screen = []
            for fx, fy in self.flame_verts:
                rx, ry = self._rotate_point(fx, fy, self.angle)
                flame_screen.append((self.x + rx, self.y + ry))

            rl.draw_triangle_lines(
                rl.Vector2(flame_screen[0][0], flame_screen[0][1]),
                rl.Vector2(flame_screen[1][0], flame_screen[1][1]),
                rl.Vector2(flame_screen[2][0], flame_screen[2][1]),
                rl.ORANGE
            )

        if DEBUG:
            rl.draw_line(int(self.x), int(self.y), int(self.x + self.vx * 0.3), int(self.y + self.vy * 0.3), rl.RED)
            speed = math.hypot(self.vx, self.vy)
            rl.draw_text(f"Speed: {speed:.1f}", 10, 30, 20, rl.GRAY)