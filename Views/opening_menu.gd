extends Node2D

var sequenceDone = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel/AnimationPlayer.play("blink")
	$Title.visible = false
	$Spawner.visible = false
	$PlayLabel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MultiplayerInput.is_action_just_pressed(0, "ui_accept") and !sequenceDone:
		$RichTextLabel/CoinSound.play()
		$RichTextLabel/AnimationPlayer.play("blank")
		await get_tree().create_timer(2).timeout
		$FirstPopup.visible = true
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.3).timeout
		$FirstPopup.visible = false
		await get_tree().create_timer(1).timeout
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.3).timeout
		$SecondPopup.visible = false
		await get_tree().create_timer(.5).timeout
		$FirstPopup.visible = true
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.2).timeout
		$FirstPopup.visible = false
		await get_tree().create_timer(.4).timeout
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.2).timeout
		$SecondPopup.visible = false
		await get_tree().create_timer(.2).timeout
		$FirstPopup.visible = true
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.2).timeout
		$FirstPopup.visible = false
		await get_tree().create_timer(.1).timeout
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.1).timeout
		$SecondPopup.visible = false
		await get_tree().create_timer(.05).timeout
		$FirstPopup.visible = true
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.05).timeout
		$FirstPopup.visible = false
		await get_tree().create_timer(.05).timeout
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.05).timeout
		$SecondPopup.visible = false
		await get_tree().create_timer(.04).timeout
		$FirstPopup.visible = true
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.04).timeout
		$FirstPopup.visible = false
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.04).timeout
		$SecondPopup.visible = false
		await get_tree().create_timer(.04).timeout
		$FirstPopup.visible = false
		await get_tree().create_timer(.04).timeout
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.04).timeout
		$SecondPopup.visible = false
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = true
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = false
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = true
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = false
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = true
		$SecondPopup.visible = false
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = false
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = true
		$SecondPopup.visible = false
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = false
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = true
		$SecondPopup.visible = false
		$FirstPopup/FirstSound.play()
		await get_tree().create_timer(.03).timeout
		$FirstPopup.visible = false
		$SecondPopup.visible = true
		$SecondPopup/SecondSound.play()
		await get_tree().create_timer(.03).timeout
		$SecondPopup.visible = false
		$FirstPopup.visible = true
		$SecondPopup.visible = true
		$AvatarTheme.play()
		
		print("playing animation")
		await get_tree().create_timer(2).timeout
		
		$Title/AnimationPlayer.play("fade_in")
		await get_tree().create_timer(6).timeout
		$Spawner.visible = true
		sequenceDone = true
		$PlayLabel.visible = true
		$PlayLabel/AnimationPlayer.play("blink")
	
	if MultiplayerInput.is_action_just_pressed(0, "ui_accept") and sequenceDone:
		PlayerManager.inGame = true
		get_tree().change_scene_to_file("res://Views/battle.tscn")  	 
