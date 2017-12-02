extends "res://Scripts/WorldRigidBody2D.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var movingSpeed = 100
export var acceleration = 20
export var canPassWalls = false


func _ready():
	._ready()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _fixed_process(delta):
	._fixed_process(delta)