extends Control

func _ready():
	PlayerManager.winnerTexts[0] = $PanelContainer
	PlayerManager.winnerTexts[1] = $PanelContainer2


@onready var lastBlink = Time.get_unix_time_from_system()
func _process(_delta):
	var currentTime = Time.get_unix_time_from_system()
	if currentTime - lastBlink > .2:
		lastBlink = currentTime
		modulate = Color(0, 0, 0) if modulate == Color(1, 1, 1) else Color(1, 1, 1)
