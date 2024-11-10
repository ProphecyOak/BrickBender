extends Node2D
class_name Brick  

# Variables to control rotation... 1 for clockwise, -1 for counterclockwise
var rotation_speed: float = 0.0
var rotation_direction: float = 1
var horizontalSpeed: float = 0
var fallSpeed: float = 350
var shotBack: bool = false
var health: int = 4
var lastHit = 0

func _ready():
	# Set random rotation speed and direction
	rotation_speed = randf_range(0.01, 0.1) 
	var rotation_direction_random_num: float = randf_range(0,1)
	rotation_direction = 1 if rotation_direction_random_num < .5 else -1

func _physics_process(delta):
	position += (Vector2(horizontalSpeed, fallSpeed)) * delta
	rotation += rotation_direction * rotation_speed
	
func shoot():

	if Time.get_unix_time_from_system() - lastHit < .5: return
	health -=   1
	if health <= 0:
		breakApart(false)
		return
	if health == 3: horizontalSpeed = 500
	else: horizontalSpeed = 200 + abs(horizontalSpeed)
	if shotBack: horizontalSpeed *= -1
	shotBack = !shotBack
	fallSpeed = 0
	
func breakApart(hitByPlayer: bool = true):
	$Hurtbox.set_deferred("monitorable", false)
	$Hitbox.set_deferred("monitorable", false)
	$AnimationPlayer.play("explode")
	rotation_speed = 0
	if hitByPlayer: horizontalSpeed *= -.1
	fallSpeed = 75
	await get_tree().create_timer(.5).timeout
	queue_free()
