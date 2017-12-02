extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Ladder_body_enter( body ):
	if body.has_method("enter_ladder"):
		body.enter_ladder(self)
	pass # replace with function body


func _on_Ladder_body_exit( body ):
	if body.has_method("leave_ladder"):
		body.leave_ladder(self)
	pass # replace with function body
