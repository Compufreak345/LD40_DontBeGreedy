extends "res://Scripts/CharacterKinematicBody2D.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var RIGHTANGLETOLERANCE = 100
var LEFTANGLETOLERANCE = 80
export var canAutoJump = true
export var canAutoClimb = true
export var canTurnAroundAtCliffs = false
export var movingDirection = 1
func _ready():
	
	._ready()
	# Called every time the node is added to the scene.
	# Initialization here

func _fixed_process(delta):
	._fixed_process(delta)
	moveMyMonster(delta)

func moveMyMonster(delta):
	
	if(fallingTime < 0.3 && (timeSinceLastDrop > 1 || timeSinceLastClimb<0.25) && canClimb && canAutoClimb):
		slowDown()
		climb(true)
	elif movingDirection > 0:
		moveRight()
	elif movingDirection <0 :
		moveLeft()
		
	if(!canClimb):
		climb(false)
	
	

func _on_Hitbox_body_enter( body ):
	._on_Hitbox_body_enter(body)
	if !canMoveThroughWalls && !body.is_in_group(attackTarget): # Check if we hit a wall and turn around
		var n = body.get_pos().normalized() - get_pos().normalized()
		var angle = rad2deg(acos(n.dot(Vector2(0, -1))))
		if angle > RIGHTANGLETOLERANCE || angle < LEFTANGLETOLERANCE:
			# we are hitting a wall
			movingDirection = -1 * movingDirection


func _on_Jumpbox_Front_area_enter( area ):
	if area.is_in_group("Gap"):
		if canAutoJump && !area.is_in_group("DontJump"):
			jump(true)




func _on_Cliffbox_area_enter( area ):
	if area.is_in_group("Gap"):
		if canTurnAroundAtCliffs && !area.is_in_group("DontTurn"):
			movingDirection = -1 * movingDirection
