extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var minRot = -90
var rotSpeed = 500
var maxRot = 0
var rotDirection = -1
func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	print(delta)
	var rot = rad2deg(get_rot())
	if rot <= minRot:
		rotDirection = 1
	elif rot >= maxRot:
		rotDirection = -1
	if rotDirection == -1:
		rot = max(rot-rotSpeed * delta,minRot)
	elif rotDirection == 1:
		rot = min(rot+rotSpeed *delta, maxRot)
	print (rot)
	set_rot(deg2rad(rot))
	
