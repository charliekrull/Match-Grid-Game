--color constants with rgb values

RED = {1, 0, 0}
YELLOW = {1, 1, 0}
GREEN = {0, 1, 0}
LIGHT_BLUE = {0, 1, 1}
DARK_BLUE = {0, 0.15, 1}
PURPLE = {0.69, 0, 1}

WHITE = {1, 1, 1}
BLACK = {0, 0, 0}

--A table of the above
gOrbColors = {RED, YELLOW, GREEN, LIGHT_BLUE, DARK_BLUE, PURPLE}
gAllColors = {RED, YELLOW, GREEN, LIGHT_BLUE, DARK_BLUE, PURPLE, WHITE, BLACK}

--actual display window dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--virtual resolution
VIRTUAL_WIDTH = 1280 
VIRTUAL_HEIGHT = 720

BOARD_OFFSET_X = VIRTUAL_WIDTH / 2 - 256
BOARD_OFFSET_Y = 16