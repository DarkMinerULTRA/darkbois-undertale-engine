extends Sprite2D

## Attack type. 0 = White, 1 = Blue, 2 = Orange, 3 = Green.
@export var attackType = 0

func _process(_delta):
	if get_node_or_null("attack"):
		$attack.name = "attack"+str(attackType)
	else:
		get_node("attack"+str(attackType)).name = "attack"+str(attackType)
	match attackType:
		0:
			modulate = Color(1,1,1)
		2:
			modulate = Color(1,0.6,0)
		1:
			modulate = Color(0,0.6,1)
