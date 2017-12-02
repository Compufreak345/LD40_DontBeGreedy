
extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world

func _ready():
	set_fixed_process(true)
	world = get_node("/root/World")
	pass
	
func _fixed_process(delta):
	set_gravity_scale(world.get("gravity"))
