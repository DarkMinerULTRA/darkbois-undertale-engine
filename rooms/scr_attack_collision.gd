extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CollisionShape2D.shape.size = Vector2(get_parent().texture.get_width(),get_parent().texture.get_height())
