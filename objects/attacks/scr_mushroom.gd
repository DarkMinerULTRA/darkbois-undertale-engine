extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().create_timer(5).timeout.connect(_attackEnd)
	await get_tree().create_timer(0.5).timeout
	while true:
		print(playerVariables.soulPos.x - 160)
		if (playerVariables.soulPos.x - 160) <= 10 and (playerVariables.soulPos.x - 160) >= -10:
			get_tree().create_tween().tween_property($Attacks/Attack2,"position",Vector2(31,40),0.4)
			await get_tree().create_timer(0.5).timeout
			get_tree().create_tween().tween_property($Attacks/Attack2,"position",Vector2(31,109),0.1)
			await get_tree().create_timer(0.3).timeout
		elif (playerVariables.soulPos.x - 160) <= 10:
			get_tree().create_tween().tween_property($Attacks/Attack3,"position",Vector2(12,40),0.4)
			await get_tree().create_timer(0.5).timeout
			get_tree().create_tween().tween_property($Attacks/Attack3,"position",Vector2(12,109),0.1)
			await get_tree().create_timer(0.3).timeout
		elif (playerVariables.soulPos.x - 160) >= -10:
			get_tree().create_tween().tween_property($Attacks/Attack,"position",Vector2(50,40),0.4)
			await get_tree().create_timer(0.5).timeout
			get_tree().create_tween().tween_property($Attacks/Attack,"position",Vector2(50,109),0.1)
			await get_tree().create_timer(0.3).timeout

func _attackEnd():
	queue_free()
