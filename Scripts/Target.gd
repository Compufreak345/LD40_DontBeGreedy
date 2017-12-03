extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var game
func _ready():
	game = get_node("/root/Game")


func _on_Target_body_enter( body ):
	if body.is_in_group("Player"):
		game.finish_level()
