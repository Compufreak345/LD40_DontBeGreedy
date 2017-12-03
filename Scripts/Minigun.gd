extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var weight = 100
var timeSinceLastShot = 0
var shootEvery = 0.05
var projectilePosition
var world
func _ready():
	projectilePosition = get_node("ProjectilePosition")
	world = get_node("/root/Game/World")
	set_fixed_process(true)
	

func _fixed_process(delta):
	timeSinceLastShot += delta
	if timeSinceLastShot > shootEvery:
		timeSinceLastShot = 0
		var projectile = preload("res://MiniScenes/Projectile.tscn").instance()
		projectile.set_pos(Vector2(projectilePosition.get_global_pos().x,projectilePosition.get_global_pos().y + randi()%10+1-5))
		world.add_child(projectile)
		
		
