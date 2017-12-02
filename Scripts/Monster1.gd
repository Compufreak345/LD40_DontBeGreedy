extends "res://Scripts/WorldRigidBody2D.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var movingSpeed = 100
export var acceleration = 20
export var canPassWalls = false
export var damage = 1
var timePassed = 0
var timeBetweenHits = 0.5
var hittingElements = Dictionary()


func _ready():
	._ready()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _fixed_process(delta):
	._fixed_process(delta)
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
