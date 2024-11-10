extends Node2D
class_name PlayerCharacter

@onready var deviceNum: int = get_parent().deviceNum
var speed: float = 3
var playerControlled: bool = false
@onready var shotDirection = get_parent().scale.x
var punching: bool = false
@onready var fistBox: Area2D = $Fist/HitBox
var kicking: bool = false
@onready var footBox: Area2D = $Foot/HitBox

var crouching: bool = false
var jumping: bool = false
var jumpHeight: float = 75
var health: int = 3
var dead = false
@onready var birthTime = Time.get_unix_time_from_system()

var lastAggression = 0
var startedMoving = 0
var moveDirection = 1

func _ready():
	PlayerManager.players[deviceNum] = self
	print("Player: " + str(deviceNum) + " has shotDirection: " + str(shotDirection))
	speed *= shotDirection

func _process(_delta):
	if punching == false and kicking == false and crouching == false:
		print("playing idle")
		$Standing/AnimationPlayer.play("idle")
	#print(deviceNum, health)
	if health == 0: PlayerManager.resetPlayers(self)
	if dead: return
	if playerControlled: checkForInputs()
	else: determineAIBehavior()
	get_parent().updateUI()

func toggleJoined():
	playerControlled = !playerControlled
	print("Player is " + ("not " if not playerControlled else "") + "in control")
	
func checkForInputs():
	crouch(MultiplayerInput.get_action_raw_strength(deviceNum, "Crouch") > .4)
	if MultiplayerInput.get_action_raw_strength(deviceNum, "Jump") > .7: jump()
	if !crouching and !jumping:
		if MultiplayerInput.is_action_just_pressed(deviceNum, "Punch"): punch()
		if MultiplayerInput.is_action_just_pressed(deviceNum, "Kick"): kick()
	move(Input.get_joy_axis(deviceNum, JOY_AXIS_LEFT_X))

func determineAIBehavior():
	var currentTime = Time.get_unix_time_from_system()
	if currentTime - startedMoving > .5: moveDirection = 0
	var bricksAbove = $AI/AboveHead.get_overlapping_areas()
	if len(bricksAbove) > 0:
		#Brick falling on head
		moveDirection = directionToMove(bricksAbove[0].get_parent())
		startedMoving = currentTime
	move(moveDirection)
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
	if abs(position.x - get_parent().edgeBound) < 100: return 1
	if abs(position.x - get_parent().centerBound) < 100: return -1
	var brickDiff: float = brickAbove.position.x - position.x
	return -abs(brickDiff)/brickDiff

func move(strength: float):
	if abs(strength) >= 0.4:
		self.position.x = clamp(self.position.x + strength * speed, get_parent().edgeBound, get_parent().centerBound) as float

func jump():
	if jumping: return
	jumping = true
	$Standing.position.y -= jumpHeight
	await get_tree().create_timer(.5).timeout
	$Standing.position.y += jumpHeight
	jumping = false

func crouch(crouchingOn: bool):
	crouching = crouchingOn
	#$Crouching.visible = crouching
	if crouching: $Standing/AnimationPlayer.play("crouch")
	#$Standing.visible = !crouching
	#$Foot.visible = !crouching and !jumping
	$Standing/HurtBox.set_monitoring(!crouching)
	$Crouching/HurtBox.set_monitoring(crouching)

func punch():
	#print("playing punch")
	$Standing/AnimationPlayer.play("punch")
	if punching == true: return
	punching = true
	lastAggression = Time.get_unix_time_from_system()
	#print("Punch")
	$Fist.position.x += 10
	for brickBox: Area2D in fistBox.get_overlapping_areas():
		(brickBox.get_parent() as Brick).shoot()
	await get_tree().create_timer(.1).timeout
	$Fist.position.x -= 10
	punching = false

func kick():
	#print("playing kick")
	$Standing/AnimationPlayer.play("kick")
	if kicking == true: return
	kicking = true
	lastAggression = Time.get_unix_time_from_system()
	#print("Kick")
	$Foot.position.x += 10
	for brickBox: Area2D in footBox.get_overlapping_areas():
		(brickBox.get_parent() as Brick).shoot()
	await get_tree().create_timer(.1).timeout
	$Foot.position.x -= 10
	kicking = false

func hitByBrick(area):
	if Time.get_unix_time_from_system() - birthTime < 1 or dead: return
	health -= 1
	(area.get_parent() as Brick).queue_free()
