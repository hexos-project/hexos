# converts an image file to a kernel format

import sys
from pygame import *


image = image.load(sys.argv[1])

code = "int image_width = " + str(image.get_width()) + ";\n"
code += "int image_height = " + str(image.get_height()) + ";\n"
code += "unsigned char image_contents[] = {\n"

for y in range(image.get_height()):
    for x in range(image.get_width()):
        color = image.get_at((x, y))
        code += str(color.b) + ", "
        code += str(color.g) + ", "
        code += str(color.r) + ", "
        code += str(color.a) + ", "
    code += "\n"

code += "};"

with open("image.c", "w") as f:
    f.write(code)
