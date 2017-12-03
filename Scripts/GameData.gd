extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var score = 0
var rightEnd = 0
var leftStart = 0
var playerItems = Array()
var player setget set_player, get_player
func _ready():
	rightEnd = Globals.get("display/width")
	
func update_health(value):
	get_node("/root/Game").update_health(value)
	
func set_player(value):
	player = value
	
func get_player():
	return player
