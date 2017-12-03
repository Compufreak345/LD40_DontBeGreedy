extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var timeSinceLastShot = -1
var shootEvery = 5
var projectilePosition
var sounds
export var fireballSpeed = 80
var world
func _ready():
	if timeSinceLastShot == -1:
		timeSinceLastShot = (randi()%10+1)/2
	projectilePosition = get_node("FireballPosition")
	world = get_node("/root/Game/World")
	sounds = get_node("/root/Sounds")
	set_fixed_process(true)
	

func _fixed_process(delta):
	timeSinceLastShot += delta
	if timeSinceLastShot > shootEvery:
		timeSinceLastShot = 0
		var projectile = preload("res://MiniScenes/Fireball.tscn").instance()
		projectile.set_pos(projectilePosition.get_global_pos())
		projectile.shooter = get_parent()
		projectile.speed = fireballSpeed
		world.add_child(projectile)
		sounds.play("Monster_Fire_Shoot")
