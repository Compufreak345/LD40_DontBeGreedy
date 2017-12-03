extends Node2D

# class member variables go here, for example:
export var gravity = 2
export var slippyness = 1
var rightEnd = 0
var leftStart = 0
func _ready():
	var game = get_node("/root/GameData")
	rightEnd = game.rightEnd
	leftStart = game.leftStart