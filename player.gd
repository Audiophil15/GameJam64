extends CharacterBody2D

signal doorencoutered
signal dead

@export var speed = 150
@export var jump_speed = -275
@export var gravity = 1000
@export var maxlife = 250
@export var life = 250
@export var animated = false
var initialSpeedx = 0
var attacking = 0
var damages = 0
var ishurt = false
var rolling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"/root/Globals".playerpos = position
	
	$SwordHitbox/SwordHitboxLeft.visible = not $SwordHitbox/SwordHitboxLeft.disabled #debug
	$SwordHitbox/SwordHitboxRight.visible = not $SwordHitbox/SwordHitboxRight.disabled #debug
	velocity.y += gravity * delta
	if $Animation.animation == "Attack" :
		damages = 50
	elif $Animation.animation == "Combo" : 
		damages = 75
		
	#print(life, " ", ishurt)

	# Input affects x axis only
	if is_on_floor() and not animated:
		if not bool(attacking) and not ishurt :
			initialSpeedx = Input.get_axis("left", "right") * speed
			velocity.x = initialSpeedx
	else :
		if initialSpeedx == 0 :
			initialSpeedx = Input.get_axis("left", "right") * speed/1.5
		if initialSpeedx > 0 :
			velocity.x = initialSpeedx - int(Input.is_action_pressed("left")) * speed/1.5
		if initialSpeedx < 0 :
			velocity.x = initialSpeedx + int(Input.is_action_pressed("right")) * speed/1.5
	
	if rolling :
		velocity.x = sign($Animation.scale.x)*speed/1.2

	move_and_slide()

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	if attacking < 2 and not ishurt and Input.is_action_just_pressed("attack") :
		$LightAttackSound.stop()
		$StrongAttackSound.stop()
		attacking += 1
		
	if Input.is_action_just_pressed("Roll") and $Animation.animation != "Combo" :
		rolling = true
		ishurt = false
		$Hurtbox/hurtbox.disabled = true
		attacking = 0
		$SwordHitbox/SwordHitboxRight.disabled = true
		$SwordHitbox/SwordHitboxLeft.disabled = true
	
	if life <= 0 :
		ishurt = 0
		$Hurtbox/hurtbox.disabled = true
		velocity.x = 0
		if not $DeathEffect.playing :
			$DeathEffect.play()
		if not $DeathSound.playing :
			$DeathSound.play()
		$Animation.play("Death")
		if $Animation.frame == 10 :
			emit_signal("dead")
	else :
		if ishurt  :
			velocity.x = 0
			$Animation.play("Hurt")
			$Hurtbox/hurtbox.disabled = true
			if $Animation.frame > 1 :
				ishurt = 0
		else :
			$Hurtbox/hurtbox.disabled = false
			if not rolling :
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
								if not $LightAttackSound.playing :
									$LightAttackSound.play()
								swordhitbox.disabled = false
							3 :
								attacking = 0
								swordhitbox.disabled = true
					elif $Animation.animation == "Combo" :
						match $Animation.frame :
							1,2 :
								swordhitbox.disabled = false
								if not $LightAttackSound.playing :
									$LightAttackSound.play()
							6,7 :
								swordhitbox.disabled = false
								if not $StrongAttackSound.playing :
									$StrongAttackSound.play()
							9 :
								attacking = 0
							_ :
								swordhitbox.disabled = true
			else :
				$Animation.play("Roll")
				if $Animation.frame == 11 :
					rolling = false

func getlife() :
	return life
	
func setlife(value) :
	life = value

func gethurt(value) :
	life -= value
	
func getdamages() :
	return damages

func _on_hurtbox_area_entered(area:Area2D):
	#print(area.get_instance_id())
	#print(area.get_groups())
	if area.is_in_group("Mobs Hitbox") or area.is_in_group("Mobs Body"):
		ishurt = true
		gethurt(area.get_parent().getdamages())
		#print(life)

func _on_door_collision_body_entered(body):
	#print("Door: ", body)
	if body.is_in_group("Door") :
		emit_signal("doorencoutered")
	pass # Replace with function body.
