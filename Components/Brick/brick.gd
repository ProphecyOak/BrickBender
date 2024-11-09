extends StaticBody2D

func _physics_process(_delta):
	move_and_collide(Vector2(0, 10))
