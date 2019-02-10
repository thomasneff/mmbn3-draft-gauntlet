import sys


gba_color  = int(sys.argv[1], 16)

# Convert to ARGB.
red = (gba_color & 31) << 3
green = ((gba_color >> 5) & 31) << 3
blue = ((gba_color >> 10) & 31) << 3
alpha = 255
print(red)
print(green)
print(blue)
argb_int = alpha << 24 | red << 16 | green << 8 | blue

print (hex(argb_int))