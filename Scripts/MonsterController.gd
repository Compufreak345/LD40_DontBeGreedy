extends "res://Scripts/CharacterKinematicBody2D.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var damage = 1
var timePassed = 0
var timeBetweenHits = 0.5
var hittingElements = Dictionary()
var RIGHTANGLETOLERANCE = 100
var LEFTANGLETOLERANCE = 80
export var canAutoJump = true
export var canAutoClimb = true
export var movingDirection = 1
func _ready():
	._ready()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _fixed_process(delta):
	._fixed_process(delta)
	do_damage(delta)
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
	
	
		
func do_damage(delta):
	for element in hittingElements.values():
		element.nextHitIn -= delta
		if element.nextHitIn <= 0:
			element.body.hit(damage)
			element.nextHitIn = timeBetweenHits
func _on_Hitbox_body_enter( body ):
	if body.is_in_group("Player"):
			var element = HittingElement.new(body, 0)
			hittingElements[body.get_instance_ID()] = element
	elif !canMoveThroughWalls: # Check if we hit a wall and turn around
		var n = body.get_pos().normalized() - get_pos().normalized()
		var angle = rad2deg(acos(n.dot(Vector2(0, -1))))
		if angle > RIGHTANGLETOLERANCE || angle < LEFTANGLETOLERANCE:
			# we are hitting a wall
			movingDirection = -1 * movingDirection


func _on_Jumpbox_Front_area_enter( area ):
	if canAutoJump && direction > 0 && area.is_in_group("Gap"):
		jump(true)

func _on_Jumpbox_Back_area_enter( area ):
	if canAutoJump && direction < 0 && area.is_in_group("Gap"):
		jump(true)

func _on_Hitbox_body_exit( body ):
	hittingElements.erase(body.get_instance_ID())

	
class HittingElement:
	var body
	var nextHitIn = 0.5
	func _init(_body, _nextHitIn):
		body = _body
		nextHitIn = _nextHitIn
