import math

SCREEN_W = 800
SCREEN_H = 600

def ghost_positions(x, y, size):
    positions = [(x, y)]

    if x < size:
        positions.append((x + SCREEN_W, y))
    elif x > SCREEN_W - size:
        positions.append((x - SCREEN_W, y))

    new_positions = []
    for px, py in positions:
        if py < size:
            new_positions.append((px, py + SCREEN_H))
        elif py > SCREEN_H - size:
            new_positions.append((px, py - SCREEN_H))

    positions.extend(new_positions)
    return positions

def rotate_point(px, py, angle):
    qx = px * math.cos(angle) - py * math.sin(angle)
    qy = px * math.sin(angle) + py * math.cos(angle)
    return qx, qy

def check_collision_circles(x1, y1, r1, x2, y2, r2):
    dist = math.hypot(x1 - x2, y1 - y2)
    return dist < (r1 + r2)