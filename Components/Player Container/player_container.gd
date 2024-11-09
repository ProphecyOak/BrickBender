extends Node2D

var edgeBound: int = 40
var centerBound: int = 350
@export var deviceNum: int = 0

func updateUI():
	$HealthBar.updateHearts($Player.health)
