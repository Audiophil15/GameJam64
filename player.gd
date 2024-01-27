extends CharacterBody2D

@export var speed = 150
@export var jump_speed = -275
@export var gravity = 1000
var initialSpeedx = 0
var attacking = 0
var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SwordHitbox/SwordHitboxLeft.visible = not $SwordHitbox/SwordHitboxLeft.disabled #debug
	$SwordHitbox/SwordHitboxRight.visible = not $SwordHitbox/SwordHitboxRight.disabled #debug
	velocity.y += gravity * delta
	if $Animation.animation == "Attack" :
		damage = 50
	elif $Animation.animation == "Combo" : 
		damage = 75

	# Input affects x axis only
	if is_on_floor() :
		if not bool(attacking) :
			initialSpeedx = Input.get_axis("left", "right") * speed
			velocity.x = initialSpeedx
	else :
		if initialSpeedx == 0 :
			initialSpeedx = Input.get_axis("left", "right") * speed/1.5
		if initialSpeedx > 0 :
			velocity.x = initialSpeedx - int(Input.is_action_pressed("left")) * speed/1.5
		if initialSpeedx < 0 :
			velocity.x = initialSpeedx + int(Input.is_action_pressed("right")) * speed/1.5

	move_and_slide()

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	if attacking < 2 and Input.is_action_just_pressed("attack") :
		attacking += 1
	
	if not bool(attacking) :
		if velocity.x == 0 :
			$Animation.play("Idle")
		if velocity.x < 0 :
			$Animation.scale.x = -1
		if velocity.x > 0 :
			$Animation.scale.x = 1
		if abs(velocity.x) < speed*2 : # Il continue d'agiter les jambes en sautant ?
			if velocity.y < 0 :
				$Animation.play("Jump")
			if velocity.y > 0 :
				$Animation.play("Falling")
		if is_on_floor() and velocity.x != 0 :
			$Animation.play("Running")
	else :
		velocity.x = 0
		var swordhitbox
		var frame
		if $Animation.scale.x == 1 :
			swordhitbox = $SwordHitbox/SwordHitboxRight
		else :
			swordhitbox = $SwordHitbox/SwordHitboxLeft
		if attacking == 1 :
			$Animation.play("Attack")
		if attacking == 2 and $Animation.animation == "Attack" :
			frame = $Animation.frame
			$Animation.play("Combo")
			$Animation.frame = frame
		if $Animation.animation == "Attack" :
			match $Animation.frame :
				1,2 :
					swordhitbox.disabled = false
				3 :
					attacking = 0
					swordhitbox.disabled = true
		elif $Animation.animation == "Combo" :
			match $Animation.frame :
				1,2,6,7 :
					swordhitbox.disabled = false
				9 :
					attacking = 0
				_ :
					swordhitbox.disabled = true

