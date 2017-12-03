
extends KinematicBody2D
export var weight = 300
export var maxSpeed = 200
export var velocityStep = 50
export var jumpStrength = 100
export var climbSpeed = 20
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world

func _ready():
	set_fixed_process(true)
	world = get_node("/root/Game/World")
	set_health(health)
	
	
func _fixed_process(delta):
	var gravity = world.get("gravity")
	_moveCharacter(delta, gravity)
