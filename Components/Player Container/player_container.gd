extends Node2D

var edgeBound: int = 40
var centerBound: int = 350
@export var deviceNum: int = 0
@export var pointCounter: Label = null

func _ready():
	$HealthBar.visible = PlayerManager.gameMode == 0

func updateUI():
	if PlayerManager.gameMode == 0: $HealthBar.updateHearts($Player.health)
	elif PlayerManager.gameMode == 1: pointCounter.text = str($Player.points)
