
extends KinematicBody2D
export var weight = 350
export var maxSpeed = 200
export var acceleration = 50
export var jumpStrength = 70
export var climbSpeed = 20
export var canMoveThroughWalls = true
var laddersTouched = Dictionary()
var isFalling = false
var isClimbing = false
var isJumping = false
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
var direction = 1 setget set_direction # 1 = right 0 = standing -1 = left
export var slowSpeed = 10
var fallingTime = 0
var timeSinceLastDrop = 0
var timeSinceLastClimb = 0
var sprite
var scale
export var jumpSpeedBoost = 100
var stoppedJumping = false
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world
func _ready():
	world = get_node("/root/World")
	gravity = world.get("gravity")
	sprite = get_node("Sprite")
	scale = get_scale()
	set_health(health)
	set_fixed_process(true)
	
func _fixed_process(delta):
	_moveCharacter(delta)
	if isFalling:
		fallingTime += delta
		timeSinceLastDrop = 0
	else:
		fallingTime = 0
		timeSinceLastDrop +=  delta
	if isClimbing:
		timeSinceLastClimb += delta
	else:
		timeSinceLastClimb = 0

func set_direction(value):
	var prevDirection = direction
	direction = value
	if prevDirection != direction:
		if direction > 0 && sprite!=null:
			sprite.set_flip_h(false)
		elif direction < 0  && sprite!=null:
			sprite.set_flip_h(true)
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
	if !_climbing || !canClimb:
		velocity.y += delta * gravity * weight * 2
		isClimbing = false
	var motion = velocity * delta
	if stoppedJumping:
		velocity.x = velocity.x - jumpSpeedBoost
		stoppedJumping = false
	
	if _climbing && canClimb:
		velocity.y = -1666 * climbSpeed/weight
		isClimbing = true
	elif wasClimbing:
		_climbing = false
		isClimbing = false
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
			isJumping = true
			_jumping = false
		elif isJumping && isOnFloor:
			isJumping = false
			stoppedJumping = true
			
		move(motion)
	else:
		isOnFloor = false
	
	if velocity.y > 0 :
		isFalling = true
	else:
		isFalling = false
	
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
	set_direction(-1)
	_moveLeft(maxSpeed, acceleration)


func _moveLeft(maxSpeed, acceleration):
	if isJumping:
		maxSpeed += jumpSpeedBoost
		acceleration += jumpSpeedBoost
	var newX = max(velocity.x-acceleration, -1*maxSpeed)
	velocity.x = newX
	
func _moveRight(maxSpeed, acceleration):
	if isJumping:
		maxSpeed += jumpSpeedBoost
		acceleration += jumpSpeedBoost
	var newX = min(velocity.x+acceleration, maxSpeed)
	velocity.x = newX

func _stop(stopSpeed, targetSpeed):
	set_direction(0)
	if velocity.x>0:
		_moveLeft(targetSpeed, stopSpeed)
	elif velocity.x<0:
		_moveRight(targetSpeed, stopSpeed)
		
func slowDown():
	_stop(999,slowSpeed * -1)
	
func stop():
	_stop(acceleration,0)

func moveRight():
	set_direction(1)
	_moveRight(maxSpeed, acceleration)
	