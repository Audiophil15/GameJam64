extends CharacterBody2D

@export var speed = 150
@export var jump_speed = -250
@export var gravity = 1000
var initialSpeed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity * delta

	# Input affects x axis only
	if is_on_floor() :
		initialSpeed = Input.get_axis("ui_left", "ui_right") * speed
		velocity.x = initialSpeed
	else :
		if initialSpeed > 0 :
			velocity.x = initialSpeed - int(Input.is_action_pressed("ui_left")) * speed/1.5
		if initialSpeed < 0 :
			velocity.x = initialSpeed + int(Input.is_action_pressed("ui_right")) * speed/1.5

	move_and_slide()

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	
