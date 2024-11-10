extends Control

var makeSound: bool = true

func _ready():
	PlayerManager.winnerTexts[0] = $TextureRect
	PlayerManager.winnerTexts[1] = $TextureRect2




@onready var lastBlink = Time.get_unix_time_from_system()
func _process(_delta):
	var currentTime = Time.get_unix_time_from_system()
	if currentTime - lastBlink > .2:
		lastBlink = currentTime
		modulate = Color(0, 0, 0) if modulate == Color(1, 1, 1) else Color(1, 1, 1)




func _on_texture_rect_visibility_changed():
	if makeSound:
		print("Do stuff on the left!")
		$WinnerSound.play()
		#$WinnerTrumpet.play()
		makeSound = false
	else:
		makeSound = true


func _on_texture_rect_2_visibility_changed():
	if makeSound:
		print("Do stuff on the right!")
		$WinnerSound.play()
		#$WinnerTrumpet.play()
		makeSound = false
	else:
		makeSound = true
