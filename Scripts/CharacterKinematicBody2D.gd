
extends KinematicBody2D
export var weight = 350
export var maxSpeed = 200
export var acceleration = 50
export var jumpStrength = 70
export var climbSpeed = 20
export var canMoveThroughWalls = true
var laddersTouched = Dictionary()
export var health = 10 setget set_health, get_health
var velocity = Vector2()
# Angle in degrees towards either side that the player can consider "floor"
const FLOORANGLETOLERANCE = 40
var _climbing = false
var _jumping = false
var canClimb = false
var isOnFloor = false
var gravity = 200
var wasClimbing = false
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world
var player
func _ready():
	player = self
	set_fixed_process(true)
	world = get_node("/root/World")
	gravity = world.get("gravity")
	set_health(health)
	
func _fixed_process(delta):
	_moveCharacter(delta)

func climb(doIt):
	if !doIt:
		_climbing = false
		return
	if canClimb:
		_climbing = true
func jump(doIt):
	if !doIt:
		_jumping = false
		return
	if isOnFloor:
		_jumping = true
		
func _moveCharacter(delta):
	gravity = world.get("gravity")
	if !_climbing:
		velocity.y += delta * gravity * weight * 2
	var motion = velocity * delta
	
	
	if _climbing && canClimb:
		velocity.y = -1666 * climbSpeed/weight
	elif wasClimbing:
		_climbing = false
		velocity.y = 0
	wasClimbing = _climbing
	motion = move(motion)
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		#print(rad2deg(acos(n.dot(Vector2(0, -1)))))
		isOnFloor = rad2deg(acos(n.dot(Vector2(0, -1)))) < FLOORANGLETOLERANCE
		if _jumping && isOnFloor:
			# character is standing on the ground and wants to jump
			velocity.y = -1666 * jumpStrength / weight
			
		move(motion)
	else:
		isOnFloor = false
	
func set_health(value):
	health = value
	if world != null:
		world.update_health(health)

func get_health():
	return health

func hit(strength):
	set_health(get_health() - strength)
	if get_health() <= 0:
		die()

func die():
	print("I am dead.")
	#TODO: Die

func enter_ladder(ladder):
	canClimb = true
	laddersTouched[ladder.get_instance_ID()] = ladder
	
func leave_ladder(ladder):
	laddersTouched.erase(ladder.get_instance_ID())
	if laddersTouched.size() == 0:
		canClimb = false

func moveLeft():
	_moveLeft(maxSpeed)

func _moveLeft(maxSpeed):
	var newX = max(velocity.x-acceleration, -1*maxSpeed)
	velocity.x = newX
	
func _moveRight(maxSpeed):
	var newX = min(velocity.x+acceleration, maxSpeed)
	velocity.x = newX
	
func stop():
	if velocity.x>0:
		_moveLeft(0)
	elif velocity.x<0:
		_moveRight(0)

func moveRight():
	_moveRight(maxSpeed)
	