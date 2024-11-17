extends "res://scripts/scr_enemy.gd"

var timer = 0

func _process(delta: float):
	timer += delta
	if get_node_or_null("Normal"):
		$Normal/Sprite2D.position.x = sin(timer*2)*5
		$Normal/Sprite2D.position.y = sin(timer*4)*5
		$Normal/Sprite2D.rotation_degrees = sin(timer*2)*5
		$Normal/Sprite2D2.scale.y = 1+(-sin(timer*4)*0.1)
