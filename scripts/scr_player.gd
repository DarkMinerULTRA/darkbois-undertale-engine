extends CharacterBody2D

@export var MOVE_SPEED = 90

# Called when the node enters the scene tree for the first time.
func _ready():
	playerVariables.encounter_steps = global.steps_required_until_encounter()
	time_data.active = true
	BGM.pause(false)
	global.can_player_move = true
	fade.fadeIn(0.25)
	$CanvasLayer.visible = false
	playerVariables.player = self
	if playerVariables.position or playerVariables.position != Vector2.ZERO:
		position = playerVariables.position
		$AnimatedSprite2D.animation = playerVariables.anim
		$AnimatedSprite2D.frame = 1
	if !playerVariables.position:
		for i in get_tree().get_root().get_children():
			if data.rooms.find(i.name) != -1:
				data.savedata["curScene"] = data.rooms.find(i.name)
				return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var inputDir = Vector2(Input.get_axis("move_left","move_right"),Input.get_axis("move_up","move_down"))
	var targetVelocity = inputDir*MOVE_SPEED
	velocity = lerp(velocity,targetVelocity,0.6)
	if inputDir == Vector2.ZERO:
		$AnimatedSprite2D.frame = 1
	elif global.can_player_move == true:
		playerVariables.steps += 1
		if playerVariables.steps >= playerVariables.encounter_steps and !playerVariables.encountered_enemy and data.room_encounters.has(data.rooms[data.savedata["curScene"]]) and data.rooms.has(get_tree().current_scene.name):
			playerVariables.encountered_enemy = true
			global.can_player_move = false
			$AudioStreamPlayer2.play()
			$bubble.visible = true
			for i in range(15+randi_range(0,5)):
				await get_tree().process_frame
			var encounter_name = data.room_encounters[data.rooms[data.savedata["curScene"]]][randi_range(0,data.room_encounters[data.rooms[data.savedata["curScene"]]].size()-1)]
			var population : int
			for i in data.areas:
				if data.areas[i]["rooms"].has(data.rooms[data.savedata["curScene"]]):
					population = data.areas[i]["population"]
					break
			print(population)
			var encounter : int
			var encounter_id = -1
			for i in data.battledata:
				encounter_id += 1
				if i.has(encounter_name):
					encounter = encounter_id
					break
			if population-data.savedata["kills"] > 0:
				print("random encounter ! !")
				battleHandler.startBattle(encounter)
			else:
				print("but nobody came......\n\nto my birthday party :(")
				battleHandler.startBattle(-1)
	if Input.is_action_just_pressed("menu") and global.can_player_move:
		$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_squeak.wav")
		$AudioStreamPlayer.play()
		global.can_player_move = false
		$CanvasLayer.visible = true
	if global.can_player_move == false:
		$AnimatedSprite2D.frame = 1
		return
	if inputDir == Vector2(1,0):
		$AnimatedSprite2D.animation = "right"
	elif inputDir == Vector2(-1,0):
		$AnimatedSprite2D.animation = "left"
	elif inputDir == Vector2(0,-1):
		$AnimatedSprite2D.animation = "up"
	elif inputDir == Vector2(0,1):
		$AnimatedSprite2D.animation = "down"
	move_and_slide()
	playerVariables.position = position
	playerVariables.anim = $AnimatedSprite2D.animation
