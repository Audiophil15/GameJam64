extends CharacterBody2D
class_name Mob

#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 1000

@export var speed = 50.0
@export var damages = 35
@export var life = 100
@export var LastAttackFrame = 0
@export var validFrames = []
var followPlayer = false
var attacking = false
var ishurt = false
var distancetoplayer = 0

func _ready():
	$Animation.play("Idle")

func _physics_process(delta):
	
	$Hitbox/Left.visible = not $Hitbox/Left.disabled
	$Hitbox/Right.visible = not $Hitbox/Right.disabled
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	distancetoplayer = $"/root/Globals".playerpos.x-position.x

	if life <= 0 :
		$Animation.play("Death")
	else :
		if not (followPlayer or attacking or ishurt) :
			$Animation.play("Idle")

		if followPlayer and not (attacking or ishurt) :
				var direction = sign(distancetoplayer)
				velocity.x = direction*speed
				$Animation.scale.x = direction
		else :
			velocity.x = 0
		
		if velocity.x != 0 :
			$Animation.play("Running")
		
		if distancetoplayer < 20 :
			attacking = true
		
		move_and_slide()

		if attacking :
			var hitbox
			if sign(distancetoplayer) > 0 :
				hitbox = $Hitbox/Right
			else :
				hitbox = $Hitbox/Left
			$Animation.play("Attack")
			match $Animation.frame :
				LastAttackFrame :
					attacking = false
				validFrames :
					hitbox.disabled = false
				_ :
					hitbox.disabled = true
					

func getlife() :
	return life
	
func setlife(value) :
	life = value

func gethurt(value) :
	life -= value
	
func getdamages() :
	return damages

func _on_player_detector_body_entered(body):
	if body.is_in_group("Player Body") and life > 0:
		followPlayer = true
	pass # Replace with function body.

func _on_player_detector_body_exited(body):
	if body.is_in_group("Player Body") :
		followPlayer = false
	pass # Replace with function body.

func _on_hurtbox_area_entered(area):
	#print(area.get_groups())
	if area.is_in_group("Knight Hitbox") :
		ishurt = true
		gethurt(area.get_parent().getdamages())
		#print(life)
	pass # Replace with function body.
