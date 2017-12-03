extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var target = "Monster"
export var damage = 1
export var timeBetweenHits = 10
var speed = 500
var direction = 1
var player
func _ready():
	player = get_node("/root/GameData").get_player()
	direction = player.get_direction()
	set_fixed_process(true)

func _fixed_process(delta):
	move(Vector2(speed*delta*direction,0))


func _on_Hitbox_body_enter( body ):
	if body.is_in_group(target):
		body.hit(self)
	queue_free()
