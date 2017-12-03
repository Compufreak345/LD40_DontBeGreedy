extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	world = get_node("/root/Game/World")


func _on_RightWall_body_enter( body ):
	if body.get("canMoveThroughWalls"):
		var pos = body.get_pos()
		var collisionRect = body.get_node("CollisionShape2D").get_item_rect()
		var offset = body.get_node("CollisionShape2D").get_shape().get_extents().x * body.get_scale().x
		body.set_pos(Vector2(world.leftStart + offset ,pos.y))
		# Force setting of direction to orient character in the right direction
		body.set_direction(body.get_direction(), true)
