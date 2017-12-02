extends "res://Scripts/CharacterKinematicBody2D.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var damage = 1
var timePassed = 0
var timeBetweenHits = 0.5
var hittingElements = Dictionary()
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
	
	if movingDirection > 0:
		moveRight()
	#for body in get_colliding_bodies():
	#	var dif = body.get_pos() - get_pos()
	#	var n = dif.normalized()
	#	print(n)
	#	if rad2deg(acos(n.dot(Vector2(0, -1)))) > floorAngleTolerance:
	#		# we are hitting a wall
	#		print("hit a wall")
	pass
		
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



func _on_Hitbox_body_exit( body ):
	hittingElements.erase(body.get_instance_ID())

class HittingElement:
	var body
	var nextHitIn = 0.5
	func _init(_body, _nextHitIn):
		body = _body
		nextHitIn = _nextHitIn
