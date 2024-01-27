extends CharacterBody2D

@export var speed = 150
@export var jump_speed = -275
@export var gravity = 1000
var initialSpeedx = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity * delta

	# Input affects x axis only
	if is_on_floor() :
		initialSpeedx = Input.get_axis("ui_left", "ui_right") * speed
		velocity.x = initialSpeedx
	else :
		if initialSpeedx == 0 :
			initialSpeedx = Input.get_axis("ui_left", "ui_right") * speed/1.5
		if initialSpeedx > 0 :
			velocity.x = initialSpeedx - int(Input.is_action_pressed("ui_left")) * speed/1.5
		if initialSpeedx < 0 :
			velocity.x = initialSpeedx + int(Input.is_action_pressed("ui_right")) * speed/1.5

	move_and_slide()

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	
