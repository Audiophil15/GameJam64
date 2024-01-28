extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position = Vector2(50, 450)
	animation()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func animation() :
	$Player.initialSpeedx = $Player.speed
