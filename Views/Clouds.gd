extends ParallaxLayer


@export var CLOUD_SPEED = -15

#Moves clouds in the background
func _process(delta: float) -> void:
	self.motion_offset.x += CLOUD_SPEED * delta
