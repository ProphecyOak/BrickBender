extends Control

var flashing: bool = false

func _ready():
	visible = PlayerManager.gameMode == 1
	PlayerManager.pointCountdown = self
	startTimer(PlayerManager.gameLength)

func _process(_delta):
	$Timer.text = timeToDisplay()

func startTimer(time: float):
	$Countdown.start(time)
	flashing = false

func timeToDisplay():
	if !flashing and $Countdown.time_left < 10:
		flashing = true
		$TimerEffects.play("Flashing")
	if $Countdown.time_left == 0: return "0.00"
	if $Countdown.time_left < 10:
		var roundedTime: String = str(round($Countdown.time_left*100)/100)
		roundedTime += "0".repeat(4 - len(roundedTime))
		return roundedTime
	return str(round($Countdown.time_left))

func gameOver():
	$TimerEffects.stop()
	if PlayerManager.players[0].points == PlayerManager.players[1].points:
		$Countdown.start(PlayerManager.overtime)
		$TimerEffects.play("Overtime")
		await $TimerEffects.animation_finished
		$TimerEffects.play("Overtime")
		await $TimerEffects.animation_finished
		$Overtime.modulate = Color(1, 1, 1, 0)
	elif PlayerManager.players[0].points > PlayerManager.players[1].points:
		PlayerManager.resetPlayers(PlayerManager.players[1])
	elif PlayerManager.players[0].points < PlayerManager.players[1].points:
		PlayerManager.resetPlayers(PlayerManager.players[0])
