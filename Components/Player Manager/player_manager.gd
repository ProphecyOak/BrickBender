extends Node2D

var players: Array[PlayerCharacter] = [null, null]
var joinTexts: Array[PanelContainer] = [null, null]
var winnerTexts: Array[PanelContainer] = [null, null]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta):
	for device in Input.get_connected_joypads():
		if MultiplayerInput.is_action_just_pressed(device, "Join"):
			players[device].toggleJoined()
			joinTexts[device].visible = !joinTexts[device].visible

func resetPlayers(loser: PlayerCharacter):
	for x in players:
		if x != loser: winnerTexts[x.deviceNum].visible = true
		x.get_parent().updateUI()
		x.dead = true
		x.health = 3
		x.get_node("../Spawner").deactivate()
		x.visible = false
	await get_tree().create_timer(2).timeout
	for x in players:
		winnerTexts[x.deviceNum].visible = false
		x.visible = true
		x.dead = false
		x.get_node("../Spawner").activate()
		x.birthTime = Time.get_unix_time_from_system()
		x.get_parent().updateUI()
