
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
var gravity = 2
var slippyness = 1
var wasClimbing = false
var direction = 1 setget set_direction, get_direction # 1 = right 0 = standing -1 = left
export var slowSpeed = 80
var fallingTime = 0
var timeSinceLastDrop = 0
var timeSinceLastClimb = 0
var sprite
var scale
var game
export var jumpSpeedBoost = 100
var stoppedJumping = false
export var attackTarget = "Player"
var hittingElements = Dictionary()
export var damage = 1.0
export var timeBetweenHits = 0.5
var damageLabel
var sounds

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world
func _ready():
	world = get_node("/root/Game/World")
	game = get_node("/root/GameData")
	gravity = world.get("gravity")
	slippyness = world.get("slippyness")
	sprite = get_node("Sprite")
	damageLabel = get_node("DamageLabel")
	sounds = get_node("/root/Sounds")
	scale = get_scale()
	set_health(health)
	set_fixed_process(true)
	
func _fixed_process(delta):
	_moveCharacter(delta)
	_autoAttack(delta)
	
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

func get_direction():
	return direction
func set_direction(value, force = false):
	var prevDirection = direction
	
	if prevDirection != value && value != 0 || force:
		direction = value
		var scale = get_scale()
		if direction == -1:
			set_scale(Vector2(-1 * scale.x, scale.y))
		elif direction == 1:
			set_scale(Vector2(scale.x, scale.y))
			
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
	if !_climbing || !canClimb:
		velocity.y += delta * gravity * weight * 2
		isClimbing = false
	var motion = velocity * delta
	if stoppedJumping:
		if velocity.x > 0 :
			velocity.x = velocity.x - jumpSpeedBoost
		elif velocity.x < 0 :
			velocity.x = velocity.x + jumpSpeedBoost
		stoppedJumping = false
	
	if _climbing && canClimb:
		velocity.y = -1666 * climbSpeed/weight * delta * 100
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
			# TODO: Make better sound selection, e.g. in player & monster-class
			if is_in_group("Player"):
				sounds.play("Player_Jump")
			elif is_in_group("Monster"):
				sounds.play("Monster_Jump")
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

func get_health():
	return health
	
func hit(attacker):
	set_health(get_health() - attacker.damage)
	showDamage(attacker.damage)
	if is_in_group("Monster"):
		sounds.play("Monster_Hit")
	elif is_in_group("Player"):
		sounds.play("Player_Hit")
	if get_health() <= 0:
		die(attacker)

func die(attacker):
	print(get_name() + ": I am dead.")
	if attacker != null && attacker.has_method("tryRemoveAttackTarget"):
		# We are dead and cannot be attacked anymore!
		attacker.tryRemoveAttackTarget(self)
		
	if is_in_group("Monster"):
		sounds.play("Monster_Died")
	elif is_in_group("Player"):
		sounds.play("Player_Died")
	set_scale(Vector2(0,0))
	

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
	var acc = acceleration
	if !isClimbing: # ladders are not slippy
		if velocity.x > 0: # we are moving right - slip hard while breaking
			acc = float(acceleration)/(slippyness * 5)
		else:
			acc = float(acceleration)/(slippyness)
	var newX = max(velocity.x - acc, (-1 * float(maxSpeed) / weight) * 100)
	velocity.x = newX
	
func _moveRight(maxSpeed, acceleration):
	if isJumping:
		maxSpeed += jumpSpeedBoost
		acceleration += jumpSpeedBoost
	
	var acc = acceleration
	if velocity.x < 0: # we are moving left - slip hard while breaking
		acc = float(acceleration)/(slippyness * 5)
	else:
		acc = float(acceleration)/(slippyness)
	var newX = min(velocity.x + acc, (float(maxSpeed)  / weight) * 100)
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

func _autoAttack(delta):
	for element in hittingElements.values():
		element.nextHitIn -= delta
		if element.nextHitIn <= 0:
			attack(element.body, element.attacker)
			element.nextHitIn = element.attacker.timeBetweenHits

func showDamage(amount):
	if damageLabel != null:
		damageLabel.set_text("-" + str(amount))
		damageLabel.show()
		var timer = Timer.new()
		timer.set_wait_time(1)
		timer.connect("timeout",self,"_on_showDamage_timeout") 
		#timeout is what says in docs, in signals
		#self is who respond to the callback
		#_on_timer_timeout is the callback, can have any name
		add_child(timer) #to process
		timer.start() #to start

func _on_showDamage_timeout():
	damageLabel.hide()

func attack(target, attacker):
	do_damage(target, attacker)
	
func do_damage(target, attacker):
	if target.has_method("hit"):
		target.hit(attacker)

func tryAddAttackTarget(body, attacker):
	if body.is_in_group(attackTarget):
		var element = HittingElement.new(body, 0, attacker)
		hittingElements[body.get_instance_ID()] = element

func tryRemoveAttackTarget(body):
	if body.is_in_group(attackTarget):
		hittingElements.erase(body.get_instance_ID())

func _on_Hitbox_body_enter( body ):
	tryAddAttackTarget(body, self)
			
func _on_Hitbox_body_exit( body ):
	tryRemoveAttackTarget(body)

class HittingElement:
	var body
	var nextHitIn = 0.5
	var attacker
	func _init(_body, _nextHitIn, _attacker):
		body = _body
		nextHitIn = _nextHitIn
		attacker = _attacker