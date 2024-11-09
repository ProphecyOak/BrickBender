extends StaticBody2D
class_name PlayerCharacter

@onready var deviceNum: int = get_parent().deviceNum
var speed: float = 3
var playerControlled: bool = false
var kicking: bool = false
var punching: bool = false

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
	move(Input.get_joy_axis(deviceNum, JOY_AXIS_LEFT_X))
		
func move(strength: float):
	if abs(strength) >= 0.4:
		self.position.x = clamp(self.position.x + strength * speed, get_parent().edgeBound, get_parent().centerBound) as float

func punch():
	if punching == true: return
	punching = true
	#print("Punch")
	$Fist.position.x += 10
	await get_tree().create_timer(.1).timeout
	$Fist.position.x -= 10
	punching = false

func kick():
	if kicking == true: return
	#print("Kick")
	$Foot.position.x += 10
	await get_tree().create_timer(.1).timeout
	$Foot.position.x -= 10
	pass
