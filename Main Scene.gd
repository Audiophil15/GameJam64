extends Node2D

var packedmapscene
var levelmap

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	packedmapscene = preload("res://LevelMap.tscn")
	#add_child(map.instantiate())
	initMap(packedmapscene, 80,50)
	#print(levelmap.initialheight, to_global(levelmap.initialheight))
	initPlayer(levelmap)
	initBottom(levelmap)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#clamp($Camera.position.x, )
	pass

func initMap(packedSceneMap:PackedScene, width:int, height:int) :
	levelmap = packedSceneMap.instantiate()
	add_child(levelmap)
	levelmap.initialize(width, height)
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
