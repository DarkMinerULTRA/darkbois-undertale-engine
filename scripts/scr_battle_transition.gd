extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.modulate = data.soulcolors[battleHandler.soulMode]
	$Camera2D.position = playerVariables.camPosition
	$AnimatedSprite2D.position = playerVariables.position
	for i in range(3):
		$AudioStreamPlayer.play()
		$AnimatedSprite2D.frame = fmod($AnimatedSprite2D.frame+1,2)
		print($AnimatedSprite2D.frame)
		await get_tree().create_timer(0.13).timeout
	$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_battlefall.wav")
	$AudioStreamPlayer.play()
	var tween = create_tween()
	var topleft = $Camera2D.position - Vector2(160,120)
	tween.tween_property($AnimatedSprite2D,"position",Vector2(topleft.x+22,topleft.y+223),0.25)
	await get_tree().create_timer(0.5).timeout
	if battleHandler.battleId == -1:
		get_tree().change_scene_to_file("res://rooms/room_butnobodycame.tscn")
	else:
		get_tree().change_scene_to_file("res://rooms/room_battle.tscn")
