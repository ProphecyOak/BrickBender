extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.joinTexts[0] = $PanelContainer
	PlayerManager.joinTexts[1] = $PanelContainer2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
