extends StaticBody2D
class_name PlayerCharacter

@export var deviceNum = 0
var playerControlled = false
var kicking = false
var punching = false

func _ready():
	PlayerManager.players[deviceNum] = self

func _process(_delta):
	if playerControlled: checkForInputs()

func toggleJoined():
	playerControlled = !playerControlled
	print("Player is " + ("not " if not playerControlled else "") + "in control")
	
func checkForInputs():
	if MultiplayerInput.is_action_just_pressed(deviceNum, "Punch"): punch()
	if MultiplayerInput.is_action_just_pressed(deviceNum, "Kick"): kick()
		
func punch():
	if punching == true: return
	punching = true
	print("Punch")
	$Fist.position.x += 10
	await get_tree().create_timer(.1).timeout
	$Fist.position.x -= 10
	punching = false

func kick():
	if kicking == true: return
	print("Kick")
	$Foot.position.x += 10
	await get_tree().create_timer(.1).timeout
	$Foot.position.x -= 10
	pass
