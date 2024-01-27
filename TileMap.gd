extends Node2D


var space = [0,1,2,3]
#var P = [[0.600, 0.175, 0.175, 0.050],
		#[0.700, 0.300, 0.000, 0.000],
		#[0.700, 0.000, 0.300, 0.000],
		#[0.700, 0.000, 0.000, 0.300]]
var P = [[0.750, 0.155, 0.045, 0.050],
		[0.700, 0.300, 0.000, 0.000],
		[0.700, 0.000, 0.300, 0.000],
		[0.700, 0.000, 0.000, 0.300]]

var mapwidth
var mapheight
var maxheight
var minheight
var initialheight

var table = []
var bgtable = []
	
func _ready():
	seed(1)
	#initialize(80,50)
	pass

func sum(array) :
	var s = 0.0
	for v in array :
		s+=v
	return s

func weightedChoice(valuesspace, weights) :
	var r = randf()
	var debug = str(r)
	debug += " : "
	for i in range(len(weights)) :
		debug += " " + str(i)
		#print(weights.slice(0,i+1), sum(weights.slice(0,i+1)))
		if sum(weights.slice(0,i+1)) > r :
			debug += " : " + str(valuesspace[i])
			#print(debug)
			return valuesspace[i]

func generateTileTable(sizex, sizey) :
	var cellpos = Vector2(1,int(sizey/2))
	var x = 0
	
	for i in range(sizex) :
		table.append([])
		bgtable.append([])
		for j in range(sizey) :
			table[i].append(-1)
			bgtable[i].append(-1)

	table[0][cellpos.y] = 0
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
			var xshift = 3 #randi_range(2, 3)
			cellpos.x += xshift
			#if xshift > 1 :
			cellpos.y += randi_range(-1,1)

	for i in range(sizex) :
		for j in range(sizey) :
			if table[i][j] == 3 and ((i != sizex-1 and table[i+1][j] != -1) or (i != 0 and table[i-1][j] != -1)) :
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
					
	for i in range(sizex) :
		var bg = 11 # 11 clear, 12 dark
		for j in range(sizey) :
			if table[i][j] != -1 and table[i][j] != 3 :
				bg = 12
			bgtable[i][j] = bg

	return table

func setExtremeHeights(table) :
	var cols = len(table)
	var lines = len(table[0])
	
	maxheight = lines
	minheight = 0
	
	for i in range(cols) :
		for j in range(lines) :
			var v = table[i][j]
			if v == 0 or v == 1 :
				maxheight = min(maxheight, j)
				minheight = max(minheight, j)
	
	minheight = $PlatformsTiles.map_to_local(Vector2i(0, minheight)).y
	maxheight = $PlatformsTiles.map_to_local(Vector2i(0, maxheight)).y
	
	for j in range(lines) :
		#print(table[0][j])
		if table[0][j] == 0 :
			initialheight = $PlatformsTiles.map_to_local(Vector2i(0, j))

func tableToTiles(table) :
	var cols = len(table)
	var lines = len(table[0])
	for i in range(cols) :
		for j in range(lines) :
			match table[i][j] :
				0 :
					$PlatformsTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(1, 0))
				1 :
					$PlatformsTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(0, 0))
				2 :
					$PlatformsTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(2, 0))
				3 :
					$PlatformsTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(6, 3))
				4 :
					$PlatformsTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(2, 1))
				5 :
					$PlatformsTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(0, 1))
				41 :
					$PlatformsTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(4, 1))
				42 :
					$PlatformsTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(3, 1))
				_ :
					pass
			match bgtable[i][j] :
				11 :
					$BackgroundTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(11, 0))
				12 :
					$BackgroundTiles.set_cell(0, Vector2i(i, j), 0, Vector2i(11, 3))
				_ :
					pass



func initialize(width, height) :
	mapwidth = $PlatformsTiles.map_to_local(Vector2i(width-1, height)).x # Width-1 car nombre de tuiles = n alors indices jusqu a n-1
	mapheight = $PlatformsTiles.map_to_local(Vector2i(width-1, height)).y # Width-1 car nombre de tuiles = n alors indices jusqu a n-1
	#print("dim : ",mapwidth,"/",mapheight)
	var levelTable = generateTileTable(width,height)
	tableToTiles(levelTable)
	setExtremeHeights(levelTable)
	#setBottom(width, height)
