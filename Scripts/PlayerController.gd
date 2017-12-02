extends KinematicBody2D
export var weight = 300
export var currentSpeed = 50
export var maxSpeed = 200
export var minSpeed = 10
export var velocityStep = 50
export var jumpStrength = 100
export var climbSpeed = 20
export var health = 10
var climbing = false
var velocity = Vector2()
var world
# Angle in degrees towards either side that the player can consider "floor"
export var floorAngleTolerance = 40
var canClimb = false
var laddersTouched = Dictionary()
var canMoveThroughWalls = true
var isMovingThroughWall = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	world = get_node("/root/World")
	set_fixed_process(true)

func decrease_health(value):
	health -= value
func enterLadder(ladder):
	canClimb = true
	laddersTouched[ladder.get_instance_ID()] = ladder
	
func leaveLadder(ladder):
	laddersTouched.erase(ladder.get_instance_ID())
	if laddersTouched.size() == 0:
		canClimb = false


func _fixed_process(delta):
	var gravity = world.get("gravity")
	
	_movePlayer(delta, gravity)

func _movePlayer(delta, gravity):
	if Input.is_action_pressed("ui_left"):
		_moveLeft(velocityStep, maxSpeed)
	elif Input.is_action_pressed("ui_right"):
		_moveRight(velocityStep, maxSpeed)
	else:
		if velocity.x > 0:
			_moveLeft(velocityStep, 0)
		elif velocity.x < 0:
			_moveRight(velocityStep, 0)

	if !climbing:
		velocity.y += delta * gravity * weight * 2
	var motion = velocity * delta
	
	var jumping = false
	var wasClimbing = climbing
	climbing = false
	if Input.is_action_pressed("ui_up"):
			if canClimb:
				climbing = true
	if climbing:
		velocity.y = -1666 * climbSpeed/weight
	elif wasClimbing:
		velocity.y = 0
	
	motion = move(motion)
	if is_colliding():
		var n = get_collision_normal()
		if Input.is_action_pressed("ui_jump"):
			if rad2deg(acos(n.dot(Vector2(0, -1)))) < floorAngleTolerance:
				# If angle to the "up" vectors is < angle tolerance
				# char is on floor
				jumping = true
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		if jumping:
			velocity.y = -1666 * jumpStrength / weight
		move(motion)
	
func _moveLeft(velocityStep, maxSpeed):
	var newX = max(velocity.x-velocityStep, -1*maxSpeed)
	velocity.x = newX

func _moveRight(velocityStep, maxSpeed):
	var newX = min(velocity.x+velocityStep, maxSpeed)
	velocity.x = newX