extends AnimatedSprite2D

func _ready():
	battleHandler.attackbar.connect(_attack)
	visible = false

func _attack():
	visible = true
	position.x = 30
	while not Input.is_action_just_pressed("select"):
		position.x+= 3
		if position.x >= 290:
			break
		await get_tree().process_frame
	if position.x >= 290:
		battleHandler.attack.emit(0)
	else:
		# formula: round((Weapon ATK + ATK - Monster DEF + r) * b)
		# Taken from undertale-science on tumblr
		var distance = position.distance_to(Vector2(160,157))
		var b : float
		if distance <= 12:
			b = 2.2
		else:
			b = (1-(distance/140.5))*2
		print(b)
		battleHandler.attack.emit(roundf((data.items[data.savedata["weapon"]]["value"] + (data.savedata["at"]+10) - data.battledata[battleHandler.battleId]["def"]+randi_range(0,2))*b))
