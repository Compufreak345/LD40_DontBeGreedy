extends "res://Scripts/Monster1.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("CollisionShape2D")
	._ready()
	
	# Called every time the node is added to the scene.
	# Initialization here
	pass
