extends Node2D

signal knightinfrontofstation
signal victory
signal textprinted
signal acceptkey

var victorydone = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Player.position = Vector2(-100, 450)
	$Player/Victory.visible = false
	$Player/Label.visible_ratio = 0
	#get_tree().quit()
	
	await animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera.position = $Player.position
	if abs(400 - $Player.position.x) < 5 :
		emit_signal("victory")
	if abs($Station.position.x - $Player.position.x) < 5 :
		emit_signal("knightinfrontofstation")
	if abs($Station.position.x - $Player.position.x) < 25 :
		$Player.animated = true
	if Input.is_action_just_pressed("ui_accept") :
		emit_signal("acceptkey")
	pass

func timer(time) :
	await get_tree().create_timer(time).timeout

func animatelabel (node, text, time = 0, from = 0, to = 1) :
	var tween = create_tween()
	if time == 0 :
		time = 0.05*len(text)
	node.visible_ratio = from
	node.text = text
	await tween.tween_property(node, "visible_ratio", to, time).finished

func animation() :
	$Player.initialSpeedx = $Player.speed
	await victory
	print("Victory")
	$Player.initialSpeedx = 0
	$Player.velocity.x = 0
	$Player/Victory.visible = true
	await acceptkey
	$Player/Victory.visible = false
	$Player.animated = false
	await knightinfrontofstation
	$Player.initialSpeedx = 0
	$Player.velocity.x = 0
	await animatelabel($Player/Label, "Hmmmm...")
	await acceptkey
	await animatelabel($Player/Label, "Je crois me souvenir...")
	await timer(1)
	await animatelabel($Player/Label, "HEY !!!", 0.1)
	await timer(1)
	#await acceptkey
	get_tree().change_scene_to_file("res://Main Scene.tscn")
	
