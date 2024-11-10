extends Node2D

func _ready():
	$AnimationPlayer.play("fade")
	PlayerManager.controlsPanel = self
