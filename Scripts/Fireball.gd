extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var target = "Player"
export var passThrough = "Monster"
export var damage = 8
export var timeBetweenHits = 10
export var speed = 30
var direction = 1
var shooter
func _ready():
	if shooter == null:
		shooter = get_node("/root/GameData").get_player()
	direction = shooter.get_direction()
	set_fixed_process(true)

func _fixed_process(delta):
	
	move(Vector2(speed*delta*direction,0))


func _on_Hitbox_body_enter( body ):
	if body.is_in_group(target):
		body.hit(self)
	if !body.is_in_group(passThrough):	
		queue_free()
