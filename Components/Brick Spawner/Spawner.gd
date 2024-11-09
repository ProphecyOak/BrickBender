extends Node2D

var preloadedBrick = preload("res://Components/Brick/brick.tscn")

@export var spawnSpeed: float = 1 

var next_spawnTime: float = 1

func _ready():
	activate()

func activate():
	$SpawnTimer.start(next_spawnTime)
	
func deactivate():
	$SpawnTimer.stop()

func _on_spawn_timer_timeout():
	next_spawnTime = randf_range(.7,1.2) * 1/spawnSpeed
	$SpawnTimer.start(next_spawnTime)
	#sets position for new brick instance
	var xPos: float = randf_range(0, 500)
	

	#creates new brick instance
	#var brickPreload = preloadedBrick
	var brick = preloadedBrick.instantiate()
	#set position and puts the brick on the actual map
	brick.position = Vector2(xPos, 0)
	self.add_child(brick)
