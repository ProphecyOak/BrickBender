extends Label

var oldPoints = 0

func changePoints(player: PlayerCharacter):
	if oldPoints == player.points: return
	if $Icons.visible:
		$Icons/MinusFive.visible = player.points < oldPoints
		$Icons/PlusTen.visible = player.points > oldPoints
	$AnimationPlayer.play("points")
	oldPoints = player.points
	text = str(oldPoints)
	await $AnimationPlayer.animation_finished
	$Icons/MinusFive.visible = false
	$Icons/PlusTen.visible = false
