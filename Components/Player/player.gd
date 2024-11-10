extends Node2D


class_name PlayerCharacter

@onready var deviceNum: int = get_parent().deviceNum
@onready var shotDirection = get_parent().scale.x
var playerControlled: bool = false

const jumpHeight: float = 30
const crouchShrink: float = 30

var currentSpeed: float = 0
var acc: float = 900
var maxSpeed: float = 250
var slowingFriction: float = 700
var movingFriction: float = 250
var momentumBoost: float = 100

var punching: bool = false
var kicking: bool = false
var crouching: bool = false
var jumping: bool = false

@onready var birthTime = Time.get_unix_time_from_system()
var health: int = 3
var dead: bool = false
var invulnerable: bool = false
var FlashDuration: float = 1.5

var lastAggression: float = 0
var startedMoving: float = 0
var moveDirection: float = 1

func _ready():
	PlayerManager.players[deviceNum] = self
	print("Player: " + str(deviceNum) + " has shotDirection: " + str(shotDirection))
	momentumBoost *= -shotDirection

func _process(delta):
	#print(deviceNum, health)
	if invulnerable:
		FlashDuration -= delta
		if FlashDuration <= 0:
			modulate = Color(1, 1, 1)
			invulnerable = false
		elif fmod(roundf(FlashDuration*10), 2.0) == 0:
			modulate = Color(1,1,1) if modulate == Color(.5, .5, .5) else Color(.5, .5, .5)
	if health == 0: PlayerManager.resetPlayers(self)
	if dead: return
	if !punching and !kicking and !jumping: $Standing/AnimationPlayer.play("idle" if !crouching else "crouch")
	if playerControlled: checkForInputs(delta)
	else: determineAIBehavior(delta)
	get_parent().updateUI()
	#if deviceNum == 1: print("Punching: " + str(punching) + " Kicking: " + str(kicking) + " Jumping: " + str(jumping) + " Crouching: " + str(crouching))

func toggleJoined():
	playerControlled = !playerControlled
	print("Player is " + ("not " if not playerControlled else "") + "in control")
	
func checkForInputs(delta: float):
	crouch(!jumping and MultiplayerInput.get_action_raw_strength(deviceNum, "Crouch") > .4)
	if MultiplayerInput.get_action_raw_strength(deviceNum, "Jump") > .7: jump()
	if !crouching and !jumping and !punching and !kicking:
		if MultiplayerInput.is_action_just_pressed(deviceNum, "Punch"): punch()
		if MultiplayerInput.is_action_just_pressed(deviceNum, "Kick"): kick()
	move(delta, MultiplayerInput.get_axis(deviceNum, "Left", "Right"))

func determineAIBehavior(delta: float):
	var currentTime = Time.get_unix_time_from_system()
	if currentTime - startedMoving > .5: moveDirection = 0
	var bricksAbove = $AI/AboveHead.get_overlapping_areas()
	if len(bricksAbove) > 0:
		#Brick falling on head
		moveDirection = directionToMove(bricksAbove[0].get_parent())
		moveDirection *= 1 if deviceNum == 0 else -1
		startedMoving = currentTime
	move(delta, moveDirection)
	if Time.get_unix_time_from_system() - lastAggression > .5:
		if len($AI/InFrontFist.get_overlapping_areas()) > 0 and randf() < .8:
			#Brick in punching range
			await get_tree().create_timer(.1).timeout
			punch()
		elif len($AI/InFrontFoot.get_overlapping_areas()) > 0 and randf() < .8:
			#Brick in kicking range
			await get_tree().create_timer(.1).timeout
			kick()

func directionToMove(brickAbove: Brick):
	if position.x < get_parent().edgeBound + 100: return 1
	if position.x > get_parent().centerBound - 100: return -1
	var brickDiff: float = brickAbove.position.x - position.x
	return -abs(brickDiff)/brickDiff

func anim_done(anim_name: String):
	if anim_name == "jump": jumpDone()
	if anim_name == "kick": kickDone()
	if anim_name == "punch": punchDone()

func move(delta: float, strength: float):
	var appliedForce: float = 0.0 if jumping else acc * strength * delta
	currentSpeed = clampf(currentSpeed + appliedForce, -maxSpeed, maxSpeed)
	var frictionForce: float = clampf((movingFriction if abs(strength) > .4 else slowingFriction) * delta, 0, abs(currentSpeed))
	if crouching: frictionForce *= 1.5
	currentSpeed = currentSpeed - frictionForce * sign(currentSpeed)
	self.position.x = clampf(self.position.x + currentSpeed * shotDirection * delta, get_parent().edgeBound, get_parent().centerBound)
	#if deviceNum == 0: print(sign(currentSpeed), " Speed: ", round(currentSpeed), " Input: ", round(strength), " Friction: ", round(frictionForce), " Applied: ", appliedForce)

func jump():
	if jumping: return
	jumping = true
	$Standing/AnimationPlayer.play("jump")
	$StandingHurtBox.set_monitorable(false)
	$JumpingHurtBox.set_monitorable(true)
	$Standing.position.y -= jumpHeight
	
func jumpDone():
	$Standing.position.y += jumpHeight
	$StandingHurtBox.set_monitorable(true)
	$JumpingHurtBox.set_monitorable(false)
	$Standing/AnimationPlayer.play("idle")
	await get_tree().create_timer(.25).timeout
	jumping = false

func crouch(crouchingOn: bool):
	crouching = crouchingOn
	$Standing.position.y = 0.0 if !crouching else crouchShrink
	$StandingHurtBox.set_monitoring(!crouching)
	$CrouchingHurtBox.set_monitoring(crouching)

func punch():
	if punching == true: return
	$Standing/AnimationPlayer.play("punch")
	punching = true
	currentSpeed += momentumBoost
	lastAggression = Time.get_unix_time_from_system()
	#print("Punch")
	$FistHitBox.position.x += 10
	for brickBox: Area2D in $FistHitBox.get_overlapping_areas():
		(brickBox.get_parent() as Brick).shoot()
	
func punchDone():
	$Standing/AnimationPlayer.play("idle")
	await get_tree().create_timer(.25).timeout
	$FistHitBox.position.x -= 10
	punching = false

func kick():
	if kicking == true: return
	$Standing/AnimationPlayer.play("kick")
	kicking = true
	currentSpeed += momentumBoost * 1.5
	lastAggression = Time.get_unix_time_from_system()
	#print("Kick")
	$FootHitBox.position.x += 10
	for brickBox: Area2D in $FootHitBox.get_overlapping_areas():
		(brickBox.get_parent() as Brick).shoot()
	
func kickDone():
	$Standing/AnimationPlayer.play("idle")
	await get_tree().create_timer(.25).timeout
	$FootHitBox.position.x -= 10
	kicking = false

func hitByBrick(area):
	if invulnerable or dead or Time.get_unix_time_from_system() - birthTime < 1: return
	#get_node("../../Freeze").pause()
	invulnerable = true
	currentSpeed += momentumBoost * 1.5
	FlashDuration = 1.5
	health -= 1
	(area.get_parent() as Brick).breakApart()
