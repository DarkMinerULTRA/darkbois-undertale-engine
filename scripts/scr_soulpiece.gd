extends AnimatedSprite2D

@export var velocity : Vector2
@export var gravity : float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity
	position += velocity*delta
