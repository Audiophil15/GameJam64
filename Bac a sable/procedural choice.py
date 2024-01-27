# Python 3

from random import choice, choices, randint

space = [0,1,2,3]

P = [[0.600, 0.175, 0.175, 0.050],
	 [0.700, 0.300, 0.000, 0.000],
	 [0.700, 0.000, 0.300, 0.000],
	 [0.300, 0.300, 0.300, 0.100]]

x = choice(space)

values = []

for i in range(80) :
	values.append(x)
	x = choices(space, P[x])[0]

# print(values)

charmap = ["_", "/", "\\", " -"]
for v in values :
	print(charmap[v], end="")
print()
