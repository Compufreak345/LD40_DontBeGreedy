extends "res://Scripts/CharacterKinematicBody2D.gd"

var itemWeight = 0
var items = Dictionary()
export var medKitHealth = 2
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	._ready()
	game.set_player(self)

func _fixed_process(delta):
	_movePlayer(delta, gravity)
	._fixed_process(delta)
	
func set_health(value):
	.set_health(value)
	if game != null:
		game.update_health(health)

func die(attacker):
	.die(attacker)
	game.game_over()
func add_item(name):
	if items.has(name) :
		return # Do nothing, item already added
	if name == "Hammer":
		var hammer = preload("res://MiniScenes/Hammer.tscn").instance()
		_add_item("Hammer",hammer)
	elif name == "MedKit":
		var medKit = preload("res://MiniScenes/MedKit.tscn").instance()
		_add_item("MedKit", medKit)
		set_health(health + medKitHealth)
	elif name == "Minigun":
		var minigun = preload("res://MiniScenes/Minigun.tscn").instance()
		_add_item("Minigun", minigun)
		

func _add_item(name, value):
	items[name] = value
	get_node("Items/" + name + "Position").add_child(value)
	weight += value.weight

func remove_item(name) :
	if !items.has(name):
		return
	var item = items[name]
	weight -= name.weight
	get_node("Items/" + name + "Position").remove_child(item)
	if name == "MedKit":
		set_health(health - medKitHealth)
	items.erase(name)
	
func clear_items():
	items.clear()
	


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
