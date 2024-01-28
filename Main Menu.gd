extends Control

var game = preload("res://Main Scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	await $Faders.fadein()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	await $Faders.fadeout()
	get_tree().quit()
	pass # Replace with function body.


func _on_play_pressed():
	await $Faders.fadeout(2)
	get_tree().change_scene_to_file("res://Main Scene.tscn")
	pass # Replace with function body.
