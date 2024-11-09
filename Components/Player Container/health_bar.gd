extends Node2D

func updateHearts(playerHealth: int):
	$Icon.visible = playerHealth > 0
	$Icon2.visible = playerHealth > 1
	$Icon3.visible = playerHealth > 2
