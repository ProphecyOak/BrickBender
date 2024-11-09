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
@onready var birthTime = Time.get_unix_time_from_system()

func _ready():
	PlayerManager.players[deviceNum] = self
	print("Player: " + str(deviceNum) + " has shotDirection: " + str(shotDirection))
	speed *= shotDirection

func _process(_delta):
	if playerControlled: checkForInputs()
	if health == 0:
		var newTime = Time.get_unix_time_from_system()
		print("You lived for " + str(newTime - birthTime) + " seconds")
		birthTime = newTime
		health = 3

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
	$Crouching.visible = crouching
	$Standing.visible = !crouching
	$Fist.visible = !crouching and !jumping
	$Foot.visible = !crouching and !jumping
	$Standing/HurtBox.set_monitoring(!crouching)
	$Crouching/HurtBox.set_monitoring(crouching)

func punch():
	if punching == true: return
	punching = true
	#print("Punch")
	$Fist.position.x += 10
	for brickBox: Area2D in fistBox.get_overlapping_areas():
		(brickBox.get_parent() as Brick).shoot()
	await get_tree().create_timer(.1).timeout
	$Fist.position.x -= 10
	punching = false

func kick():
	if kicking == true: return
	kicking = true
	#print("Kick")
	$Foot.position.x += 10
	for brickBox: Area2D in footBox.get_overlapping_areas():
		(brickBox.get_parent() as Brick).shoot()
	await get_tree().create_timer(.1).timeout
	$Foot.position.x -= 10
	kicking = false

func hitByBrick(area):
	health -= 1
	(area.get_parent() as Brick).queue_free()

