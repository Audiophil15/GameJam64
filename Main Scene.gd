extends Node2D

var packedmapscene
var packedmobscene
var packedendscene
var levelmap
var screensize
var cameraXMin 
var cameraXMax 
var levelstotop = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screensize = get_viewport_rect().size
	#screensize = $".".get_size()
	packedmapscene = preload("res://LevelMap.tscn")
	packedmobscene = preload("res://mushroom.tscn")
	packedendscene = preload("res://Final Screen.tscn")
	loadNextLevel(160,50)
	#await get_tree().create_timer(1.5).timeout
	#await  $"../Faders".fadein(1.5)
	pass # Replace with function body.

	#cameraXMin = $Camera.zoom.x*screensize.x #screensize.x*$Camera.zoom.x/2
	#cameraXMax = screensize.x-cameraXMin
	#print(cameraXMin, cameraXMax)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player.position.x = clamp($Player.position.x, 0, levelmap.mapwidth)
	$Camera.position = $Player.position-Vector2(0,35)
	#$Camera.position.x = clamp($Camera.position.x, cameraXMin, cameraXMax)
	#$Camera.position.y = clamp($Camera.position.y, 0, levelmap.mapheight)
	pass

func initMap(packedSceneMap:PackedScene, width:int, height:int) :
	levelmap = packedSceneMap.instantiate()
	add_child(levelmap)
	levelmap.initialize(width, height)
	$Camera.limit_left = 0
	$Camera.limit_top = 0
	$Camera.limit_right = levelmap.mapwidth+8
	$Camera.limit_bottom = levelmap.minheight+50
	#packedmapscene = preload("res://LevelMap.tscn")
	
func initMobs(mapNode):
	var coeff = mapNode.mapwidth/300
	var nbmobs = randi_range(int(coeff/1.5), int(coeff*1.5))
	var mob
	for i in range(nbmobs) :
		mob = packedmobscene.instantiate()
		mob.position = Vector2(randi_range(250, mapNode.mapwidth-150), 0)
		mapNode.call_deferred("add_child", mob)
	
func initPlayer(mapNode) :
	$Player.position = to_global(mapNode.initialheight)+Vector2(50, -32)
	
func deinitMap():
	if levelmap != null :
		levelmap.queue_free()

func initBottom(mapNode) :
	$Bottom/hitbox.set_deferred("polygon", PackedVector2Array([Vector2(0, mapNode.mapheight), Vector2(mapNode.mapwidth, mapNode.mapheight), Vector2(mapNode.mapwidth, mapNode.mapheight+100), Vector2(0, mapNode.mapheight+100)]))
	#$Bottom/hitbox.shape.distance = -to_global(Vector2(0, mapNode.mapheight)).y
	#$Bottom2/hitbox.shape.distance = -to_global(Vector2(0, mapNode.mapheight)).y
	#$Bottom/hitbox.shape.a = to_global(Vector2(0, mapNode.mapheight))
	#$Bottom/hitbox.shape.b = to_global(Vector2(mapNode.mapwidth, mapNode.mapheight))
	#$Bottom2/hitbox.shape.a = to_global(Vector2(0, mapNode.mapheight+10))
	#$Bottom2/hitbox.shape.b = to_global(Vector2(mapNode.mapwidth, mapNode.mapheight+10))
	#print($Bottom/hitbox.shape.a, $Bottom/hitbox.shape.b)
	#print("== ", $Bottom/hitbox.shape.distance)
	
	pass

func _on_button_pressed():
	loadNextLevel(randi_range(50,100), randi_range(50,100))
	pass # Replace with function body.

func _on_bottom_body_entered(body:Node2D):
	#print("Body entered : ", body.get_instance_id())
	if body.get_instance_id() == $Player.get_instance_id() :
		#print("reload !")
		initPlayer(levelmap)
	pass # Replace with function body.

func loadNextLevel(width:int, height:int) :
	await $"../Faders".fadeout()
	deinitMap()
	initMap(packedmapscene, width, height)
	initMobs(levelmap)
	initPlayer(levelmap)
	initBottom(levelmap)
	await $"../Faders".fadein()
	

func _on_player_doorencoutered():
	if levelstotop > 1 :
		loadNextLevel(randi_range(150,300), randi_range(150,300))
		levelstotop -= 1
		print("nana")
	else :
		print("Ok")
		get_tree().change_scene_to_packed(packedendscene)
	pass # Replace with function body.

func _on_player_dead():
	$Player.life = $Player.maxlife
	loadNextLevel(randi_range(150,300), randi_range(150,300))
	pass # Replace with function body.
