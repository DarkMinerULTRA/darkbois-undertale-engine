extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$BGM.finished.connect(_loop)
	$Sprite2D.position = playerVariables.soulPos
	$Sprite2D.modulate = data.soulcolors[battleHandler.soulMode]
	$AnimatedSprite2D.modulate = data.soulcolors[battleHandler.soulMode]
	$AnimatedSprite2D2.modulate = data.soulcolors[battleHandler.soulMode]
	$AnimatedSprite2D3.modulate = data.soulcolors[battleHandler.soulMode]
	await get_tree().create_timer(1.5).timeout
	$Sprite2D.texture = preload("res://assets/sprites/battle/spr_heartbreak_0.png")
	$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_break1_c.wav")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1).timeout
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.velocity = Vector2(randi_range(-2,-4)*20,randi_range(-3,-5)*20)
	$AnimatedSprite2D.gravity = 6
	$AnimatedSprite2D2.visible = true
	$AnimatedSprite2D2.velocity = Vector2(randi_range(-4,4)*20,randi_range(-3,-5)*20)
	$AnimatedSprite2D2.gravity = 6
	$AnimatedSprite2D3.visible = true
	$AnimatedSprite2D3.velocity = Vector2(randi_range(2,4)*20,randi_range(-3,-5)*20)
	$AnimatedSprite2D3.gravity = 6
	$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_break2_c.wav")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1.5).timeout
	$BGM.play()
	create_tween().tween_property($SprGameoverbg0,"modulate:a",1,1)
	await get_tree().create_timer(1).timeout
	await type(["You cannot give up just&yet...",data.savedata["name"]+"!^5&Stay determined..."])
	$Label.text = ""
	while Input.is_action_pressed("select"):
		await get_tree().process_frame
	while not Input.is_action_just_pressed("select"):
		await get_tree().process_frame
	create_tween().tween_property($SprGameoverbg0,"modulate:a",0,1)
	create_tween().tween_property($BGM,"volume_db",-20,1.5)
	await get_tree().create_timer(2).timeout
	data.load_file()

func _process(_delta):
	$Sprite2D.position = lerp($Sprite2D.position,Vector2(160,120),0.1)

func _loop():
	$BGM.play()

func type(text : Array[String]):
	$Label.text = ""
	$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_txtasg.wav")
	var wait = false
	for i in text:
		$Label.text = ""
		for j in i:
			if wait == true:
				wait = false
				await get_tree().create_timer(float(j)/10).timeout
			elif j == "&":
				$Label.text = $Label.text + "\n"
			elif j == "^":
				wait = true
			else:
				$Label.text = $Label.text + j
				$AudioStreamPlayer.play()
				await get_tree().create_timer(0.05).timeout
		while not Input.is_action_just_pressed("select"):
			await get_tree().process_frame
