@tool
extends StaticBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CollisionShape2D3.position.y = -$UiBox/box.size.y/2
	$CollisionShape2D4.position.y = $UiBox/box.size.y/2-4
	$CollisionShape2D.position.x = -$UiBox/box.size.x/2+3
	$CollisionShape2D2.position.x = $UiBox/box.size.x/2-2
