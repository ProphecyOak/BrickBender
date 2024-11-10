extends Node2D

var players: Array[PlayerCharacter] = [null, null]
var connected: Array[bool] = [false, false]
var joinTexts: Array[Node2D] = [null, null]
var winnerTexts: Array[TextureRect] = [null, null]
var pointCountdown: Control = null
var controlsPanel: Node2D = null

var gameMode: int = 1 # 0:Lives, 1:Timed
var gameLength: int = 20
var overtime: int = 20
var winScreenTime: int = 5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta):
	for device in Input.get_connected_joypads():
		if MultiplayerInput.is_action_just_pressed(device, "Join"):
			players[device].toggleJoined()
			connected[device] = !connected[device]
			controlsPanel.visible = !connected[0] and !connected[1]
			joinTexts[device].visible = !joinTexts[device].visible

func giveOther(deviceNum: int, pts: int):
	players[[1,0][deviceNum]].points += pts

func resetPlayers(loser: PlayerCharacter):
	for x in players:
		if x != loser: winnerTexts[x.deviceNum].visible = true
		x.get_parent().updateUI()
		x.dead = true
		x.get_node("../Spawner").deactivate()
		x.visible = false
	await get_tree().create_timer(winScreenTime).timeout
	for x in players:
		if gameMode == 0: x.health = 3
		elif gameMode == 1: x.points = 0
		winnerTexts[x.deviceNum].visible = false
		x.visible = true
		x.dead = false
		x.get_node("../Spawner").activate()
		x.birthTime = Time.get_unix_time_from_system()
		x.get_parent().updateUI()
		x.punching = false
		x.kicking = false
		x.jumping = false
		x.crouching = false
	pointCountdown.startTimer(gameLength)
