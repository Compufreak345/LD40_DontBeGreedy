extends Node2D

# class member variables go here, for example:
export var gravity = 40
var leftStart = 0
var rightEnd = 0
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	rightEnd = Globals.get("display/width")
	
func update_health(value):
	get_node("HealthLabel").set_text("Health:" + str(value))
