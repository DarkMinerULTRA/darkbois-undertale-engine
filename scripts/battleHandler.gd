extends Node

signal monsterTurnStart
signal playerTurnStart
signal monsterDialogueStart(dialogue)
signal playDialogue(dialogue)
signal attackappear
signal attackbar
signal attack(damage)
signal endBattle(end)
signal preMonsterDialogue

@export var battleId : int = 0
@export var battle = false
@export var choice = 0
@export var choose1 = false
@export var locked1 = false
@export var choice2 = 0
@export var choose2 = false
@export var soulMode = 0
@export var safe = false
@export var monsterHP : float
var maxOptions2 = 1
var canSpare = true
var expAdd = 0
var goldAdd = 0
var enemyTurn = true
var battleOver = false
var monsterDialogue : String = ""
var itemPage = 0
var npc = -1
var music = "mus_battle1"

var AudioPlayer = AudioStreamPlayer.new()

func _ready():
	battleOver = false
	add_child(AudioPlayer)
	endBattle.connect(EndtheBattle)

func startBattle(id : int,transition : bool = true,battle_music : String = "mus_battle1",npc_id_to_set : int = -1):
	npc = npc_id_to_set
	music = battle_music
	battleId = id
	canSpare = data.battledata[id]["spare"]
	soulMode = 0
	enemyTurn = true
	if transition:
		get_tree().change_scene_to_file("res://rooms/room_battletransition.tscn")
	else:
		if id == -1:
			get_tree().change_scene_to_file("res://rooms/room_butnobodycame.tscn")
		else:
			get_tree().change_scene_to_file("res://rooms/room_battle.tscn")

func _process(_delta):
	if battle == true:
		get_node("/root/room_battle/ChoiceBox").visible = false
		if choose1 == true:
			get_node("/root/room_battle/BattleBox").visible = true
			if Input.is_action_just_pressed("select"):
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream = preload("res://assets/sounds/snd_select.wav")
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
				if choice == 2 and data.savedata["items"].size() == 0:
					return
				locked1 = true
				choose1 = false
				choice2 = 0
				get_node("/root/room_battle/BattleBox").skip = true
				get_node("/root/room_battle/ChoiceBox/Option0").label_settings.font_color = Color(1,1,1,1)
				match choice:
					0:
						get_node("/root/room_battle/ChoiceBox/Option0").text = "* "+data.battledata[battleId]["name"]
						get_node("/root/room_battle/ChoiceBox/Option0").visible = true
						get_node("/root/room_battle/ChoiceBox/Option1").visible = false
						get_node("/root/room_battle/ChoiceBox/Option2").visible = false
						get_node("/root/room_battle/ChoiceBox/Option3").visible = false
						get_node("/root/room_battle/ChoiceBox/Option4").visible = false
						get_node("/root/room_battle/ChoiceBox/Option5").visible = false
					1:
						maxOptions2 = 0
						get_node("/root/room_battle/ChoiceBox/Option0").visible = false
						get_node("/root/room_battle/ChoiceBox/Option1").visible = false
						get_node("/root/room_battle/ChoiceBox/Option2").visible = false
						get_node("/root/room_battle/ChoiceBox/Option3").visible = false
						get_node("/root/room_battle/ChoiceBox/Option4").visible = false
						get_node("/root/room_battle/ChoiceBox/Option5").visible = false
						for i in range(data.battledata[battleId]["acts"].size()):
							maxOptions2 += 1
							get_node("/root/room_battle/ChoiceBox/Option"+str(i)).text = "* "+data.battledata[battleId]["acts"][i]
							get_node("/root/room_battle/ChoiceBox/Option"+str(i)).visible = true
					2:
						itemPage = 0
					3:
						maxOptions2 = 1
						get_node("/root/room_battle/ChoiceBox/Option0").visible = true
						get_node("/root/room_battle/ChoiceBox/Option0").text = "* Spare"
						if canSpare == true:
							get_node("/root/room_battle/ChoiceBox/Option0").label_settings.font_color = Color(0.9,1,0,1)
						get_node("/root/room_battle/ChoiceBox/Option1").visible = false
						get_node("/root/room_battle/ChoiceBox/Option2").visible = false
						get_node("/root/room_battle/ChoiceBox/Option3").visible = false
						get_node("/root/room_battle/ChoiceBox/Option4").visible = false
						get_node("/root/room_battle/ChoiceBox/Option5").visible = false
				choose2 = true
			if Input.is_action_just_pressed("ui_left"):
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream = preload("res://assets/sounds/snd_squeak.wav")
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
				choice -= 1
			if Input.is_action_just_pressed("ui_right"):
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream = preload("res://assets/sounds/snd_squeak.wav")
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
				choice += 1
			if choice == -1:
				choice = 3
			elif choice == 4:
				choice = 0
		elif choose2 == true:
			get_node("/root/room_battle/ChoiceBox").visible = true
			get_node("/root/room_battle/BattleBox").visible = false
			if choice == 2:
				maxOptions2 = 0
				get_node("/root/room_battle/ChoiceBox/Option0").visible = false
				get_node("/root/room_battle/ChoiceBox/Option1").visible = false
				get_node("/root/room_battle/ChoiceBox/Option2").visible = false
				get_node("/root/room_battle/ChoiceBox/Option3").visible = false
				get_node("/root/room_battle/ChoiceBox/Option4").visible = false
				get_node("/root/room_battle/ChoiceBox/Option5").visible = true
				get_node("/root/room_battle/ChoiceBox/Option5").text = "PAGE "+str(itemPage+1)
				for i in range(data.savedata["items"].size()):
					if i <= 3 and itemPage == 0:
						maxOptions2 += 1
						get_node("/root/room_battle/ChoiceBox/Option"+str(i)).text = "* "+data.items[data.savedata["items"][i]]["short"]
						get_node("/root/room_battle/ChoiceBox/Option"+str(i)).visible = true
					elif i >= 4 and itemPage == 1:
						maxOptions2 += 1
						get_node("/root/room_battle/ChoiceBox/Option"+str(i-4)).text = "* "+data.items[data.savedata["items"][i]]["short"]
						get_node("/root/room_battle/ChoiceBox/Option"+str(i-4)).visible = true
			if Input.is_action_just_pressed("back"):
				playerTurnStart.emit()
			if Input.is_action_just_pressed("select"):
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream = preload("res://assets/sounds/snd_select.wav")
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
				_action(get_node("/root/room_battle/ChoiceBox/Option"+str(choice2)).text)
			if Input.is_action_just_pressed("ui_left"):
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream = preload("res://assets/sounds/snd_squeak.wav")
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
				if ((choice2-1) == -1 or (choice2-1) == 1) and choice == 2 and data.savedata["items"].size() >= 5:
					choice2 -= 3
					if itemPage == 0:
						itemPage = 1
					else:
						itemPage = 0
				elif (choice2-1) != -1 and (choice2-1) != 1:
					choice2 -= 1
			if Input.is_action_just_pressed("ui_right"):
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream = preload("res://assets/sounds/snd_squeak.wav")
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
				if ((choice2+1) == 2 or (choice2+1) == maxOptions2) and choice == 2 and data.savedata["items"].size() >= 5:
					choice2 -= 3
					if itemPage == 0:
						itemPage = 1
					else:
						itemPage = 0
				elif (choice2+1) != 2 and (choice2+1) != maxOptions2:
					choice2 += 1
			if Input.is_action_just_pressed("ui_up"):
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream = preload("res://assets/sounds/snd_squeak.wav")
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
				if not (choice2 - 2) < 0:
					choice2 -= 2
			if Input.is_action_just_pressed("ui_down"):
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream = preload("res://assets/sounds/snd_squeak.wav")
				get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
				if not (choice2 + 2) > maxOptions2-1:
					choice2 += 2
			choice2 = clamp(choice2,0,maxOptions2-1)
	data.savedata["hp"] = clamp(data.savedata["hp"],0,data.savedata["maxhp"])

func _hurt(amount : int):
	safe = true
	AudioPlayer.stream = load("res://assets/sounds/snd_hurt1_c.wav")
	AudioPlayer.play()
	data.savedata["hp"] -= amount
	for i in 30:
		if !battleOver:
			playerVariables.soul.get_node("heart_ui").modulate.a = abs(playerVariables.soul.get_node("heart_ui").modulate.a-1)
			print(abs(playerVariables.soul.get_node("heart_ui").modulate.a-1))
		await get_tree().process_frame
	if !battleOver:
		playerVariables.soul.get_node("heart_ui").modulate.a = 1
	safe = false
	
func _heal(amount : int):
	AudioPlayer.stream = load("res://assets/sounds/snd_heal_c.wav")
	AudioPlayer.play()
	data.savedata["hp"] += amount

func _action(action : String):
	choose2 = false
	match action:
		"* Check":
			if data.battledata[battleId]["fake_stats"] == false:
				playDialogue.emit(["* "+data.battledata[battleId]["name"]+" - ATK "+str(data.battledata[battleId]["atk"])+" DEF "+str(data.battledata[battleId]["def"])+"&"+data.battledata[battleId]["check"]])
			else:
				playDialogue.emit(["* "+data.battledata[battleId]["name"]+" - ATK "+str(data.battledata[battleId]["fake_atk"])+" DEF "+str(data.battledata[battleId]["fake_def"])+"&"+data.battledata[battleId]["check"]])
			await get_node("/root/room_battle/BattleBox").finished
		"* Spare":
			if canSpare == true:
				get_node("/root/room_battle/Enemy").get_node("Normal").queue_free()
				get_node("/root/room_battle/Enemy").get_node("Hurt").visible = true
				enemyTurn = false
				battleOver = true
				endBattle.emit(0)
		_:
			if action == "* "+data.battledata[battleId]["name"]:
				attackappear.emit()
			elif choice == 2:
					if data.savedata["hp"]+data.items[data.savedata["items"][choice2+(itemPage*4)]]["value"]>=data.savedata["maxhp"]:
						playDialogue.emit([data.items[data.savedata["items"][choice2+(itemPage*4)]]["equip"].pick_random()+"^5&* Your HP was fully restored!"])
					else:
						playDialogue.emit([data.items[data.savedata["items"][choice2+(itemPage*4)]]["equip"].pick_random()+"^5&* You recovered "+str(data.items[data.savedata["items"][choice2+(itemPage*4)]]["value"])+" HP!"])
					_heal(data.items[data.savedata["items"][choice2+(itemPage*4)]]["value"])
					data.savedata["items"].remove_at(choice2+(itemPage*4))
					await get_node("/root/room_battle/BattleBox").finished
	print("Action finished")
	if not choice == 0 and enemyTurn == true:
		preMonsterDialogue.emit()

func EndtheBattle(end):
	get_tree().get_root().get_node("room_battle").get_node("BGM").stop()
	get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").stream  = preload("res://assets/sounds/snd_vaporized.wav")
	get_tree().get_root().get_node("room_battle").get_node("AudioStreamPlayer").play()
	if end == 0:
		data.savedata["npc_state"][str(npc)] = 1
		get_node("/root/room_battle/Enemy").get_node("Hurt").queue_free()
		get_node("/root/room_battle/Enemy").get_node("Spare").visible = true
		playDialogue.emit(["* YOU WON!^5^5&* You got 0 EXP and "+str(data.battledata[battleId]["gold"])+" GOLD."])
		data.savedata["g"]+=data.battledata[battleId]["gold"]
		await get_node("/root/room_battle/BattleBox").finished
		battle = false
		fade.fadeOut(0.25)
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("rooms/"+data.rooms[data.savedata["curScene"]]+".tscn")
	else:
		data.savedata["npc_state"][str(npc)] = 2
		get_node("/root/room_battle/Enemy").get_node("Normal").queue_free()
		data.savedata["g"]+=data.battledata[battleId]["gold"]
		data.savedata["kills"]+=1
		data.savedata["exp"]+=data.battledata[battleId]["exp"]
		var levelup = global._levelup()
		if levelup:
			playDialogue.emit(["* YOU WON!^5^5&* You got "+str(data.battledata[battleId]["exp"])+" EXP and "+str(data.battledata[battleId]["gold"])+" GOLD.&* Your LOVE increased."])
		else:
			playDialogue.emit(["* YOU WON!^5^5&* You got "+str(data.battledata[battleId]["exp"])+" EXP and "+str(data.battledata[battleId]["gold"])+" GOLD."])
		await get_node("/root/room_battle/BattleBox").finished
		battle = false
		fade.fadeOut(0.25)
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("rooms/"+data.rooms[data.savedata["curScene"]]+".tscn")
