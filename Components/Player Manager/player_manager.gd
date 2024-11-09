extends Node2D

var players: Array[PlayerCharacter] = [null, null]
var joinTexts: Array[PanelContainer] = [null, null]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta):
	for device in Input.get_connected_joypads():
		if MultiplayerInput.is_action_just_pressed(device, "Join"):
			players[device].toggleJoined()
			joinTexts[device].visible = !joinTexts[device].visible
