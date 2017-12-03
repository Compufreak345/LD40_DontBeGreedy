extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var minRot = -90
var rotSpeed = 1000
var maxRot = 0
var rotDirection = -1
var game
export var weight = 20
export var damage = 0.5
export var timeBetweenHits = 0.1
func _ready():
	game = get_node("/root/GameData")
	set_fixed_process(true)
	
func _fixed_process(delta):
	var rot = get_rotd()
	if rot <= minRot:
		rotDirection = 1
	elif rot >= maxRot:
		rotDirection = -1
	if rotDirection == -1:
		rot = max(rot-rotSpeed * delta,minRot)
	elif rotDirection == 1:
		rot = min(rot+rotSpeed *delta, maxRot)
	set_rotd(rot)
	


func _on_Hitbox_body_enter( body ):
	var player = game.get_player()
	player.tryAddAttackTarget(body, self)


func _on_Hitbox_body_exit( body ):
	var player = game.get_player()
	player.tryRemoveAttackTarget(body)
	
func tryRemoveAttackTarget(body):
	var player = game.get_player()
	player.tryRemoveAttackTarget(body)
