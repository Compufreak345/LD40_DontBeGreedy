extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	world = get_node("/root/World")

func _on_Area2D_body_enter( body ):
	if body.get("canMoveThroughWalls"):
		var pos = body.get_pos()
		var offset = body.get_node("CollisionShape2D").get_shape().get_extents().x
		body.set_pos(Vector2(world.rightEnd - offset,pos.y))
