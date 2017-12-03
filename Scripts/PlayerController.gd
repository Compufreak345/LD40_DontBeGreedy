extends "res://Scripts/CharacterKinematicBody2D.gd"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	._ready()

func _fixed_process(delta):
	_movePlayer(delta, gravity)
	._fixed_process(delta)
	
func set_health(value):
	.set_health(value)
	if game != null:
		game.update_health(health)

func _movePlayer(delta, gravity):
	if Input.is_action_pressed("ui_left"):
		moveLeft()
	elif Input.is_action_pressed("ui_right"):
		moveRight()
	else:
		stop()
	if Input.is_action_pressed("ui_up"):
		climb(true)
	else:
		climb(false)
		
				
	if Input.is_action_pressed("ui_jump"):
		jump(true)
	else:
		jump(false)

func _on_Hitbox_body_enter( body ):
	pass # replace with function body
