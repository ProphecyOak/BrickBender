extends Node2D

var preloadedBrick = preload("res://Components/Brick/brick.tscn")

@export var spawnSpeed = 1 

var next_spawnTime = 1

var spawnReady = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start(next_spawnTime)
	#spawnTimer.start(next_spawnTime)
	spawnReady = 0
	print("Started first timer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if spawnReady == 1:
		#print("Started timer")
		#next_spawnTime = randf_range(.7,1.2)
		#print("Starting a new timer for " +  next_spawnTime)
		#$SpawnTimer.start(next_spawnTime)
	pass


func _on_spawn_timer_timeout():
	print("New Brick")
	next_spawnTime = randf_range(.7,1.2) * 1/spawnSpeed
	print(next_spawnTime)
	$SpawnTimer.start(next_spawnTime)
	#sets position for new brick instance
	var xPos = randf_range(0, 500)
	

	#creates new brick instance
	#var brickPreload = preloadedBrick
	var brick = preloadedBrick.instantiate()
	#set position and puts the brick on the actual map
	brick.position = Vector2(xPos, 0)
	self.add_child(brick)
