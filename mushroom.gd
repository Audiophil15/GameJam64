extends Mob

func _ready():
	super._ready()
	LastAttackFrame = 7

func _physics_process(delta):

	$Hitbox/Left.visible = not $Hitbox/Left.disabled
	$Hitbox/Right.visible = not $Hitbox/Right.disabled

	distancetoplayer = ($"/root/Globals".playerpos-position).length()
	if life <= 0 :
		if not $DeathSound.playing :
			$DeathSound.play()
		$Body/Collision.disabled= true
		$Animation.play("Death")
		if $Animation.frame == 4 :
			queue_free()
	else :
		if not (followPlayer or attacking or ishurt) :
			$Animation.play("Idle")

		if followPlayer and not (attacking or ishurt) :
				var direction = sign($"/root/Globals".playerpos.x-position.x)
				velocity.x = direction*speed
				$Animation.scale.x = direction
		else :
			velocity.x = 0
		
		if abs(distancetoplayer) < 20 and not ishurt :
			attacking = true
		
		if ishurt :
			attacking = 0
			$Animation.play("Hurt")
			if $Animation.frame == 3 :
				ishurt = false
		
		if velocity.x != 0 :
			if not $Walking.playing :
				$Walking.play()
			$Animation.play("Running")
		else :
			$Walking.stop()
		
		if not is_on_floor():
			velocity.y += gravity * delta
		
		move_and_slide()

		if attacking :
			var hitbox
			if $Animation.scale.x < 0 :
				hitbox = $Hitbox/Right
			else :
				hitbox = $Hitbox/Left
			$Animation.play("Attack")
			match $Animation.frame :
				5:
					$AttackSound.stop()
				LastAttackFrame :
					attacking = false
				6,7 :
					if not $AttackSound.playing :
						$AttackSound.play()
					hitbox.disabled = false
				_ :
					hitbox.disabled = true
		else :
			$Hitbox/Left.disabled = true
			$Hitbox/Right.disabled = true
