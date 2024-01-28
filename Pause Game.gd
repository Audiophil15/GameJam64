extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") :
		get_tree().paused = not get_tree().paused
		if get_tree().paused :
			#$Control/AnimationPlayer.play("Pause")
			$"Main Scene/Camera/Pause Menu".setpause()
		else :
			#$Control/AnimationPlayer.play("Depause")
			$"Main Scene/Camera/Pause Menu".leavepause()
		
	if $"Main Scene".levelstotop == 3:
		if not $Music.playing :
			$Music.play()
		$Music2.stop()
		$Music3.stop()
	elif $"Main Scene".levelstotop == 2:
		if not $Music2.playing :
			$Music2.play()
		$Music.stop()
		$Music3.stop()
	elif $"Main Scene".levelstotop == 1:
		if not $Music3.playing :
			$Music3.play()
		$Music2.stop()
		$Music.stop()
	pass


func _on_pause_menu_resume():
	get_tree().paused = false
	$"Main Scene/Camera/Pause Menu".leavepause()
	pass # Replace with function body.


func _on_pause_menu_restart():
	print("OK")
	get_tree().paused = false
	$"Main Scene".loadNextLevel(randi_range(150,300), randi_range(150,300))
	$"Main Scene".levelstotop = 3
	$"Main Scene/Player".life = $"Main Scene/Player".maxlife
	pass # Replace with function body.


func _on_pause_menu_quit():
	get_tree().paused = false
	get_tree().quit()
	pass # Replace with function body.
