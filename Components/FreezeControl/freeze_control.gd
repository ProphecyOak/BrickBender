extends Node2D

func pause():
	get_tree().paused = true
	await get_tree().create_timer(.15).timeout
	get_tree().paused = false
