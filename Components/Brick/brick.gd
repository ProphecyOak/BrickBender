extends StaticBody2D

# Variables to control rotation... 1 for clockwise, -1 for counterclockwise
var rotation_speed: float = 0.0
var rotation_direction: float = 1 

func _ready():
	# Set random rotation speed and direction
	rotation_speed = randf_range(0.01, 0.1) 
	var rotation_direction_random_num: float = randf_range(0,1)
	if rotation_direction_random_num < .5:
		rotation_direction = 1
	else:
		rotation_direction = -1

func _physics_process(_delta):
	move_and_collide(Vector2(0, 10))
	rotation += rotation_direction * rotation_speed
