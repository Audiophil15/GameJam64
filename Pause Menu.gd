extends CanvasLayer

signal resume
signal restart
signal quit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setpause() :
	$Control/AnimationPlayer.play("Pause")

func leavepause() :
	$Control/AnimationPlayer.play("Depause")

func _on_resume_pressed():
	emit_signal("resume")
	pass # Replace with function body.


func _on_restart_pressed():
	emit_signal("restart")
	pass # Replace with function body.


func _on_quit_pressed():
	emit_signal("quit")
	pass # Replace with function body.
