extends Node2D

var monster_line = 0
var monster_atk = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy = load("res://objects/enemies/obj_"+data.battledata[battleHandler.battleId]["obj"]+".tscn").instantiate()
	enemy.position = Vector2(160,68)
	add_child(enemy)
	fade.fadeIn(0.5)
	$BGM.stream = load("res://assets/music/"+battleHandler.music+".ogg")
	$BGM.play()
	battleHandler.monsterHP = data.battledata[battleHandler.battleId]["hp"]
	battleHandler.playerTurnStart.connect(_turnStart)
	battleHandler.monsterTurnStart.connect(_enemyTurn)
	battleHandler.attackappear.connect(_fight)
	battleHandler.attack.connect(_damage)
	battleHandler.monsterDialogueStart.connect(_monsterdialogue)
	battleHandler.playerTurnStart.emit()
	battleHandler.preMonsterDialogue.connect(_pre_monster_dialogue)

func _monsterdialogue(_dialogue : Array):
	$soul.visible = true
	$soul.position = Vector2(160,159)
	$AttackBox/UiBox.size = Vector2(72,72)
	await $speechbubble.finished
	battleHandler.monsterTurnStart.emit()

func _pre_monster_dialogue():
	if battleHandler.monsterDialogue == "":
		if data.battledata[battleHandler.battleId]["lines_in_order"] == true:
			battleHandler.monsterDialogueStart.emit(data.battledata[battleHandler.battleId]["dialogs"][monster_line])
			if monster_line != data.battledata[battleHandler.battleId]["dialogs"].size()-1:
				monster_line += 1
			else:
				if data.battledata[battleHandler.battleId]["loop_lines"] == true:
					monster_line = 0
		else:
			battleHandler.monsterDialogueStart.emit(data.battledata[battleHandler.battleId]["dialogs"][randi_range(0,data.battledata[battleHandler.battleId]["dialogs"].size()-1)])
	else:
		battleHandler.monsterDialogueStart.emit([battleHandler.monsterDialogue])

func _pre_death():
	match battleHandler.battleId:
		_:
			pass
	battleHandler.endBattle.emit(1)

func _damage(damage : float):
	if damage > 0:
		print("successfully attacked with "+str(damage)+" damage! yay")
	else:
		print("you missed sad")
	if damage > 0:
		$slash.play()
		$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_laz_c.wav")
		$AudioStreamPlayer.play()
		await get_tree().create_timer(1.2).timeout
		$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_damage_c.wav")
		$AudioStreamPlayer.play()
		$Enemy.hurt.emit()
		battleHandler.monsterHP -= damage
		$EnemyHealth.visible = true
	var attackTxt = preload("res://objects/obj_battle_text.tscn").instantiate()
	if damage > 0:
		attackTxt.text = str(damage)
		attackTxt.get_node("Label").label_settings.font_color = Color(1,0,0)
	else:
		attackTxt.text = "miss"
		attackTxt.get_node("Label").label_settings.font_color = Color(0.5,0.5,0.5)
	attackTxt.position = Vector2(160,60)
	add_child(attackTxt)
	create_tween().tween_property($EnemyHealth,"value",battleHandler.monsterHP,1)
	await get_tree().create_timer(1.5).timeout
	$EnemyHealth.visible = false
	$SprTarget0/AnimationPlayer.current_animation = "fightdissapear"
	$attackbar.visible = false
	if $EnemyHealth.value == 0:
		battleHandler.battleOver = true
		_pre_death()
	else:
		_pre_monster_dialogue()
		$Enemy/Hurt.visible = false
		$Enemy/Normal.visible = true

func _fight():
	$SprTarget0/AnimationPlayer.current_animation = "fightappear"
	while $SprTarget0/AnimationPlayer.current_animation != "":
		await get_tree().process_frame
	print("animation finished")
	battleHandler.attackbar.emit()

func _enemyTurn():
	$soul.can_move = true
	print(data.battledata[battleHandler.battleId]["attacks"].size()-1)
	var attack : Node2D = Node2D.new()
	var skip = false
	if data.battledata[battleHandler.battleId]["attacks_in_order"] == false:
		attack = load("res://objects/attacks/"+data.battledata[battleHandler.battleId]["attacks"][randi_range(0,-1)]+".tscn").instantiate()
	else:
		if monster_atk != data.battledata[battleHandler.battleId]["attacks"].size():
			attack = load("res://objects/attacks/"+data.battledata[battleHandler.battleId]["attacks"][monster_atk]+".tscn").instantiate()
			monster_atk += 1
		else:
			if data.battledata[battleHandler.battleId]["loop_attacks"] == true:
				monster_atk = 0
			else:
				skip = true
				battleHandler.canSpare = true
	attack.position = Vector2(160,155)
	add_child(attack)
	while get_node_or_null("attack") != null:
		if skip:
			get_node_or_null("attack").queue_free()
		await get_tree().process_frame
	$AttackBox/UiBox.size = Vector2(289,72)
	battleHandler.locked1 = false
	$soul.visible = false
	$soul.can_move = false
	await get_tree().create_timer(0.5).timeout
	battleHandler.playerTurnStart.emit()

func _turnStart():
	$soul.visible = false
	$soul.can_move = false
	battleHandler.monsterDialogue = ""
	battleHandler.battle = true
	if battleHandler.locked1 == false:
		battleHandler.choice = 0
		battleHandler.choice2 = 0
	battleHandler.locked1 = false
	battleHandler.choose1 = true
	battleHandler.choose2 = false

func _process(_delta):
	if data.savedata["hp"] == 0:
		get_tree().change_scene_to_file("res://rooms/room_dead.tscn")
		battleHandler.battle = false
		battleHandler.battleOver = true
