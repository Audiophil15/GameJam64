extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	seed(1)
	var space = [0,1,2,3]
	var P = [[0.600, 0.175, 0.175, 0.050],
	 [0.700, 0.300, 0.000, 0.000],
	 [0.700, 0.000, 0.300, 0.000],
	 [0.700, 0.000, 0.000, 0.300]]
	var x = 0
	var cellpos = Vector2i(15,15)
	for i in range(80) :
		x = weightedChoice(space, P[x])
		if  x == 0 :
			set_cell(0, cellpos, 0, Vector2i(1,0))
			cellpos.x += 1
		if x == 1 :
			set_cell(0, cellpos-Vector2i(0,1), 0, Vector2i(0,0))
			set_cell(0, cellpos, 0, Vector2i(4,1))
			cellpos.x+=1
			cellpos.y-=1
		if x == 2 :
			set_cell(0, cellpos, 0, Vector2i(2,0))
			set_cell(0, cellpos+Vector2i(0,1), 0, Vector2i(3,1))
			cellpos.x+=1
			cellpos.y+=1
		if x == 3 :
			cellpos.x+=1
			set_cell(0, cellpos, 0, Vector2i(1,0))
			var xshift = randi_range(1, 2)
			cellpos.x += xshift
			if xshift == 2 :
				cellpos.y += randi_range(-1,1)
			
			
	pass # Replace with function body.

func sum(array) :
	var s = 0.0
	for v in array :
		s+=v
	return s

func weightedChoice(space, weights) :
	var r = randf()
	var debug = str(r)
	debug += " : "
	for i in range(len(weights)) :
		debug += " " + str(i)
		#print(weights.slice(0,i+1), sum(weights.slice(0,i+1)))
		if sum(weights.slice(0,i+1)) > r :
			debug += " : " + str(space[i])
			#print(debug)
			return space[i]
