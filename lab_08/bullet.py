import pyray as rl
import math
import utils


class Bullet:
    def __init__(self, x, y, angle):
        self.x = x
        self.y = y
        self.angle = angle

        speed = 600.0

        dir_x, dir_y = utils.rotate_point(0, -1, self.angle)
        self.vx = dir_x * speed
        self.vy = dir_y * speed

        self.radius = 2.0
        self.ttl = 1.5
        self.alive = True

    def wrap(self):
        self.x %= utils.SCREEN_W
        self.y %= utils.SCREEN_H

    def update(self, dt):
        self.x += self.vx * dt
        self.y += self.vy * dt

        self.ttl -= dt
        if self.ttl <= 0:
            self.alive = False

    def draw(self):
        rl.draw_circle(int(self.x), int(self.y), int(self.radius), rl.YELLOW)