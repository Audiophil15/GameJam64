extends TileMap

var space = [0,1,2,3]
#var P = [[0.600, 0.175, 0.175, 0.050],
		#[0.700, 0.300, 0.000, 0.000],
		#[0.700, 0.000, 0.300, 0.000],
		#[0.700, 0.000, 0.000, 0.300]]
var P = [[0.600, 0.255, 0.095, 0.050],
		[0.700, 0.300, 0.000, 0.000],
		[0.700, 0.000, 0.300, 0.000],
		[0.700, 0.000, 0.000, 0.300]]
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var levelTable = generateTileTable(80,50)
	tableToTiles(levelTable)

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

func generateTileTable(sizex, sizey) :
	var cellpos = Vector2(0,int(sizey/2))
	var x = 0
	var table = []
	for i in range(sizex) :
		table.append([])
		for j in range(sizey) :
			table[i].append(-1)
	while cellpos.x < sizex :
		x = weightedChoice(space, P[x])
		if  x == 0 :
			table[cellpos.x][cellpos.y] = 0
			cellpos.x += 1
		if x == 1 :
			table[cellpos.x][cellpos.y] = 41
			table[cellpos.x][cellpos.y-1] = 1
			cellpos.x+=1
			cellpos.y-=1
		if x == 2 :
			table[cellpos.x][cellpos.y] = 2
			table[cellpos.x][cellpos.y+1] = 42
			cellpos.x+=1
			cellpos.y+=1
		if x == 3 :
			table[cellpos.x][cellpos.y] = 3
			var xshift = randi_range(1, 2)
			cellpos.x += xshift
			if xshift == 2 :
				cellpos.y += randi_range(-1,1)
	#for col in table :
		#var l = ""
		#for v in col :
			#if v == -1 :
				#l+= " "
			#else : 
				#l += str(v)
		#print(l)
		
	for i in range(sizex) :
		for j in range(sizey) :
			if table[i][j] == 3 :
				table[i][j] = 0
			if table[i][j] == 0 and (i != sizex-1 and table[i+1][j] == -1) and (i == 0 or table[i-1][j] != -1) :
				# Case of a cliff before a gap
				table[i][j] = 2
				for k in range(j+1, sizey) :
					table[i][k] = 4
			if table[i][j] == 0 and (i != 0 and table[i-1][j] == -1) and (i == sizex-1 or table[i+1][j] != -1) :
				# Case of a cliff after a gap
				table[i][j] = 1
				for k in range(j+1, sizey) :
					table[i][k] = 5
		
	return table

func tableToTiles(table) :
	var cols = len(table)
	var lines = len(table[0])
	for i in range(cols) :
		for j in range(lines) :
			match table[i][j] :
				0, 3 :
					set_cell(0, Vector2i(i, j), 0, Vector2i(1, 0))
				1 :
					set_cell(0, Vector2i(i, j), 0, Vector2i(0, 0))
				2 :
					set_cell(0, Vector2i(i, j), 0, Vector2i(2, 0))
				4 :
					set_cell(0, Vector2i(i, j), 0, Vector2i(2, 1))
				5 :
					set_cell(0, Vector2i(i, j), 0, Vector2i(0, 1))
				41 :
					set_cell(0, Vector2i(i, j), 0, Vector2i(4, 1))
				42 :
					set_cell(0, Vector2i(i, j), 0, Vector2i(3, 1))
				_ :
					pass
	
