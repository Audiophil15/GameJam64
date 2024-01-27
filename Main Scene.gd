extends Node2D

var packedmapscene
var levelmap
var screensize
var cameraXMin 
var cameraXMax 

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screensize = get_viewport_rect().size
	#screensize = $".".get_size()
	packedmapscene = preload("res://LevelMap.tscn")
	initMap(packedmapscene, 160,50)
	initPlayer(levelmap)
	initBottom(levelmap)
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
	$Camera.limit_right = levelmap.mapwidth+8
	$Camera.limit_bottom = levelmap.minheight+50
	#packedmapscene = preload("res://LevelMap.tscn")
	
func initPlayer(mapNode) :
	$Player.position = to_global(mapNode.initialheight)+Vector2(0, -32)
	
func deinitMap():
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
	deinitMap()
	initMap(packedmapscene, randi_range(15,80), randi_range(15,50))
	initPlayer(levelmap)
	initBottom(levelmap)
	pass # Replace with function body.


func _on_bottom_body_entered(body:Node2D):
	#print("Body entered : ", body.get_instance_id())
	if body.get_instance_id() == $Player.get_instance_id() :
		#print("reload !")
		deinitMap()
		initMap(packedmapscene, randi_range(15,80), randi_range(15,50))
		initPlayer(levelmap)
		initBottom(levelmap)
	pass # Replace with function body.
