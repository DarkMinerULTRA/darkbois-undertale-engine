extends CanvasLayer

var choose1 = false
var choose2 = false
var choose3 = false
var choice1 = 0
var choice2 = 0
var choice3 = 0
var can_move = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UiBox4/Label8.text = "\""+data.savedata["name"]+"\""
	$UiBox4/Label10.text = "\n\nLV"+str(data.savedata["lv"])+"\nHP "+str(data.savedata["hp"])+"\n\nAT "+str(data.savedata["at"]+data.items[data.savedata["weapon"]]["value"])+"("+str(data.items[data.savedata["weapon"]]["value"])+")\nDF "+str(data.savedata["def"]+data.items[data.savedata["armor"]]["value"])+"("+str(data.items[data.savedata["armor"]]["value"])+")"
	$UiBox4/Label14.text = str(data.savedata["maxhp"])
	$UiBox4/Label11.text = "EXP:"+str(data.savedata["exp"])+"\nNEXT:"+str(global.get_exp_remaining())
	$UiBox4/Label12.text = "WEAPON:"+data.items[data.savedata["weapon"]]["name"]+"\nARMOR:"+data.items[data.savedata["armor"]]["name"]
	$UiBox4/Label13.text = "GOLD:"+str(data.savedata["g"])+" KILLS:"+str(data.savedata["kills"])
	match choice1:
		0:
			$UiBox2/Label7.text = ""
			for i in data.savedata["items"]:
				$UiBox2/Label7.text = $UiBox2/Label7.text+i+"\n"
			choice2 = clamp(choice2,0,data.savedata["items"].size()-1)
		2:
			$UiBox2/Label7.text = ""
			for i in data.savedata["cell"]:
				$UiBox2/Label7.text = $UiBox2/Label7.text+i+"\n"
			choice2 = clamp(choice2,0,data.savedata["cell"].size()-1)
	choice1 = clamp(choice1,0,2)
	if visible == true:
		if choice1 == 0:
			$UiBox2/USE.visible = true
			$UiBox2/INFO.visible = true
			$UiBox2/DROP.visible = true
		else:
			$UiBox2/USE.visible = false
			$UiBox2/INFO.visible = false
			$UiBox2/DROP.visible = false
		if choose1:
			can_move = true
			$UiBox2.visible = false
			$UiBox4.visible = false
			$Sprite2D.visible = true
			$Sprite2D.position.x = 32.5
			match choice1:
				0:
					$Sprite2D.position.y = 103.5
				1:
					$Sprite2D.position.y = 121.5
				2:
					$Sprite2D.position.y = 138.5
		elif choose2:
			if choice1 == 1:
				can_move = false
			else:
				can_move = true
			if choice1 == 1:
				$UiBox4.visible = true
				$Sprite2D.visible = false
			else:
				$UiBox2.visible = true
			$Sprite2D.position.x = 110
			$Sprite2D.position.y = 50+(16.35*choice2)
		elif choose3:
			$Sprite2D.position.y = 190
			match choice3:
				0:
					$Sprite2D.position.x = 108
				1:
					$Sprite2D.position.x = 158
				2:
					$Sprite2D.position.x = 212
		if can_move:
			if Input.is_action_just_pressed("ui_up"):
				$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_squeak.wav")
				$AudioStreamPlayer.play()
				if choose1:
					choice1 -= 1
				elif choice2:
					choice2 -= 1
			if Input.is_action_just_pressed("ui_down"):
				$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_squeak.wav")
				$AudioStreamPlayer.play()
				if choose1:
					choice1 += 1
				elif choose2:
					choice2 += 1
			if Input.is_action_just_pressed("ui_left"):
				$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_squeak.wav")
				$AudioStreamPlayer.play()
				if choose3:
					choice3 -= 1
			if Input.is_action_just_pressed("ui_right"):
				$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_squeak.wav")
				$AudioStreamPlayer.play()
				if choose3:
					choice3 += 1
		if Input.is_action_just_pressed("select") and !(choose2 == true and choice1 == 1):
			$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_select.wav")
			$AudioStreamPlayer.play()
			if choose1:
				if (data.savedata["items"].size() == 0 and choice1 == 0) or (data.savedata["cell"].size() == 0 and choice1 == 2):
					return
				choose2 = true
				choose1 = false
			elif choose2:
				match choice1:
					0:
						choose2 = false
						choose3 = true
					2:
						visible = false
						if data.calls[data.savedata["cell"][choice2]].has(data.rooms[data.savedata["curScene"]]):
							$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_phone.wav")
							$AudioStreamPlayer.play()
							await dialogueHandler.doDialogue(["* Ring...^2 Ring..."])
							await dialogueHandler.doDialogue(data.calls[data.savedata["cell"][choice2]][data.rooms[data.savedata["curScene"]]],data.calls[data.savedata["cell"][choice2]]["voice"])
							await dialogueHandler.doDialogue(["* Click..."])
						else:
							$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_phone.wav")
							$AudioStreamPlayer.play()
							dialogueHandler.doDialogue(["* Ring...^2 Ring...","* Nobody picked up."])
			else:
				visible = false
				match choice3:
					0:
						match data.items[data.savedata["items"][choice2]]["type"]:
							"item":
								if data.savedata["hp"]+data.items[data.savedata["items"][choice2]]["value"]>=data.savedata["maxhp"]:
									dialogueHandler.doDialogue([data.items[data.savedata["items"][choice2]]["equip"].pick_random()+"^5&* Your HP was fully restored!"])
								else:
									dialogueHandler.doDialogue([data.items[data.savedata["items"][choice2]]["equip"].pick_random()+"^5&* You recovered "+str(data.items[data.savedata["items"][choice2]]["value"])+" HP!"])
								battleHandler._heal(data.items[data.savedata["items"][choice2]]["value"])
								data.savedata.items.erase(data.savedata["items"][choice2])
							"weapon":
								data.savedata["items"].append(data.savedata["weapon"])
								data.savedata["weapon"] = data.savedata["items"][choice2]
								dialogueHandler.doDialogue([data.items[data.savedata["items"][choice2]]["equip"].pick_random()])
								data.savedata.items.erase(data.savedata["items"][choice2])
							"armor":
								data.savedata["items"].append(data.savedata["armor"])
								data.savedata["armor"] = data.savedata["items"][choice2]
								dialogueHandler.doDialogue([data.items[data.savedata["items"][choice2]]["equip"].pick_random()])
								data.savedata.items.erase(data.savedata["items"][choice2])
							"special":
								dialogueHandler.doDialogue([data.items[data.savedata["items"][choice2]]["equip"].pick_random()])
								data.savedata.items.erase(data.savedata["items"][choice2])
					1:
						dialogueHandler.doDialogue(data.items[data.savedata["items"][choice2]]["info"])
					2:
						match randi_range(0,3):
							0:
								dialogueHandler.doDialogue(["* You put the "+data.items[data.savedata["items"][choice2]]["name"]+"&  on the ground and gave it a&  little pat."])
								data.savedata.items.erase(data.savedata["items"][choice2])
							1:
								dialogueHandler.doDialogue(["* You threw the "+data.items[data.savedata["items"][choice2]]["name"]+"&  on the ground like the piece&  of trash it is."])
								data.savedata.items.erase(data.savedata["items"][choice2])
							2:
								dialogueHandler.doDialogue(["* You abandoned the &  "+data.items[data.savedata["items"][choice2]]["name"]+"."])
								data.savedata.items.erase(data.savedata["items"][choice2])
							3:
								dialogueHandler.doDialogue(["* The "+data.items[data.savedata["items"][choice2]]["name"]+" was&  thrown away."])
								data.savedata.items.erase(data.savedata["items"][choice2])
		if Input.is_action_just_pressed("back"):
			if choose2:
				choose2 = false
				choose1 = true
			elif choose3:
				choose3 = false
				choose2 = true
			else:
				visible = false
				global.can_player_move = true
	else:
		choose1 = true
		choose2 = false
		choose3 = false
		choice1 = 0
		choice2 = 0
		choice3 = 0
