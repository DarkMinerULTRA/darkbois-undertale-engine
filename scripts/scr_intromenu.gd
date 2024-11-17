extends Node2D

var state = 0
var choice1 = 0
var choice2 = 0
var choice3 = 0
@onready var selections = [$"name/0",$"name/1",$"name/2",$"name/3",$"name/4",$"name/5",$"name/6",$"name/7",$"name/8",$"name/9",$"name/10",$"name/11",$"name/12",$"name/13",$"name/14",$"name/15",$"name/16",$"name/17",$"name/18",$"name/19",$"name/20",$"name/21",$"name/22",$"name/23",$"name/24",$"name/25",$"name/26",$"name/27",$"name/28",$"name/29",$"name/30",$"name/31",$"name/32",$"name/33",$"name/34",$"name/35",$"name/36",$"name/37",$"name/38",$"name/39",$"name/40",$"name/41",$"name/42",$"name/43",$"name/44",$"name/45",$"name/46",$"name/47",$"name/48",$"name/49",$"name/50",$"name/51",$"name/quit",$"name/backspace",$"name/done"]
var positions = []
var tween1 : Tween
var tween2 : Tween

var can_pick = true

func _ready() -> void:
	for i in selections:
		if i:
			positions.append(i.position)

func _process(_delta: float) -> void:
	$name/name.rotation_degrees = randf_range(-2,2)
	$confirm/name.rotation_degrees = randf_range(-2,2)
	match $name/name.text.to_lower():
		"aaaaaa":
			can_pick = true
			$confirm/Label.text = "Not very creative...?"
		"chara":
			can_pick = true
			$confirm/Label.text = "The true name."
		"papyru":
			can_pick = true
			$confirm/Label.text = "I'LL ALLOW IT!!!!"
		"sans":
			can_pick = false
			$confirm/Label.text = "nope."
		"flowey":
			can_pick = false
			$confirm/Label.text = "I already CHOSE\nthat name."
		"toriel":
			can_pick = false
			$confirm/Label.text = "I think you should\nthink of your own\nname, my child."
		"asgore":
			can_pick = false
			$confirm/Label.text = "You cannot."
		"mtt","metta":
			can_pick = false
			$confirm/Label.text = "OOOH!!! ARE YOU\nPROMOTING MY BRAND?"
		"aaron":
			can_pick = true
			$confirm/Label.text = "Is this name correct? ;)"
		"woshua":
			can_pick = true
			$confirm/Label.text = "Clean name."
		"bpants":
			can_pick = true
			$confirm/Label.text = "You are really scraping the\nbottom of the barrel."
		"murder","mercy":
			can_pick = true
			$confirm/Label.text = "That's a little on-\nthe-nose, isn't it...?"
		"undyne":
			can_pick = false
			$confirm/Label.text = "Get your OWN name!"
		"alphys":
			can_pick = false
			$confirm/Label.text = "D-don't do that..."
		"alphy":
			can_pick = true
			$confirm/Label.text = "Uh... OK?"
		"frisk":
			can_pick = false
			$confirm/Label.text = "Sorry. If you want Hard Mode,\ncode it yourself."
		"asriel":
			can_pick = false
			$confirm/Label.text = "..."
		"":
			can_pick = false
			$confirm/Label.text = "You must choose a name."
		"jerry":
			can_pick = true
			$confirm/Label.text = "Jerry."
		"gerson":
			can_pick = true
			$confirm/Label.text = "Wah ha ha!\nWhy not?"
		"napsta","blooky":
			can_pick = true
			$confirm/Label.text = "............ (They are\npowerless to stop you.)"
		"catty":
			can_pick = true
			$confirm/Label.text = "Bratty! Bratty!\nThat's MY name!"
		"bratty":
			can_pick = true
			$confirm/Label.text = "Like, OK I guess."
		"temmie":
			can_pick = true
			$confirm/Label.text = "hOI!"
		"shyren":
			can_pick = true
			$confirm/Label.text = "...?"
		"darky","dark","dakboi":
			can_pick = false
			$confirm/Label.text = "Did you make this engine?\nNo."
		"merg","yub","":
			can_pick = true
			$confirm/Label.text = "yo!!! hi!!!\nthanks for playing!"
		"clover":
			can_pick = false
			$confirm/Label.text = "Disrespecting the\ndead, are you?"
		"starlo":
			can_pick = false
			$confirm/Label.text = "Dual!"
		"martlet":
			can_pick = false
			$confirm/Label.text = "I'm flattered...but no."
		"ceroba":
			can_pick = false
			$confirm/Label.text = "Get your own name!!"
		"chujin":
			can_pick = false
			$confirm/Label.text = "Sorry...but no."
		"kanako":
			can_pick = false
			$confirm/Label.text = "..."
		"axis":
			can_pick = false
			$confirm/Label.text = "[screw] YOU"
		"dalv":
			can_pick = false
			$confirm/Label.text = "...no."
		_:
			can_pick = true
			$confirm/Label.text = "Is this name correct?"
	if can_pick:
		$confirm/no.text = "No"
		$confirm/yes.visible = true
	else:
		$confirm/no.text = "Go back"
		$confirm/yes.visible = false
	if state == 0:
		$name.visible = false
		$confirm.visible = false
		$tutorial.visible = true
		if Input.is_action_just_pressed("ui_up"):
			choice1 = 0
		if choice1 == 0:
			$tutorial/Label5.label_settings.font_color = Color(1,1,0)
		if Input.is_action_just_pressed("select"):
			state = 1
	elif state == 1:
		if tween1:
			tween1.stop()
		if tween2:
			tween2.stop()
		choice3 = 0
		$confirm/name.scale = Vector2(1,1)
		$confirm/name.position = Vector2(140,55)
		for i in range(positions.size()):
			var pos = positions[i]
			pos.x += randf_range(-1,1)/1.9
			pos.y += randf_range(-1,1)/1.9
			if selections[i]:
				selections[i].position = pos
		$name.visible = true
		$tutorial.visible = false
		$confirm.visible = false
		if Input.is_action_just_pressed("back"):
			if $name/name.text.length() != 0:
				$name/name.text[$name/name.text.length()-1] = ""
		if Input.is_action_just_pressed("ui_down"):
			match choice2:
				21,22,23,24,25:
					choice2 += 5
				19,20:
					choice2 += 12
				47,48:
					choice2 = 52
				49,50,51:
					choice2 = 53
				45,46:
					choice2 = 54
				_:
					choice2 += 7
		if Input.is_action_just_pressed("ui_up"):
			match choice2:
				26,27,28,29,30:
					choice2 -= 5
				31,32:
					choice2 -= 12
				52:
					choice2 = 47
				53:
					choice2 = 49
				54:
					choice2 = 45
				_:
					choice2 -= 7
		if Input.is_action_just_pressed("ui_left"):
			match choice2:
				0,7,14,21,26,33,40,47,52:
					pass
				_:
					choice2 -= 1
		if Input.is_action_just_pressed("ui_right"):
			match choice2:
				6,13,20,25,32,39,46,51,54:
					pass
				_:
					choice2 += 1
		choice2 = clamp(choice2,0,54)
		for i in selections:
			if i:
				i.label_settings.font_color = Color(1,1,1)
		if selections[choice2]:
			selections[choice2].label_settings.font_color = Color(1,1,0)
		if Input.is_action_just_pressed("select"):
			match choice2:
				52:
					state = 0
				53:
					if $name/name.text.length() != 0:
						$name/name.text[$name/name.text.length()-1] = ""
				54:
					state = 2
					$confirm/name.text = $name/name.text
					tween1 = create_tween()
					tween2 = create_tween()
					tween1.tween_property($confirm/name,"scale",Vector2(3.075,3.075),2)
					tween2.tween_property($confirm/name,"position",Vector2(107,107),2)
				_:
					if $name/name.text.length() == 6:
						$name/name.text[5] = selections[choice2].text
					else:
						$name/name.text += selections[choice2].text
	elif state == 2:
		$name.visible = false
		$tutorial.visible = false
		$confirm.visible = true
		#choice2 = 0
		if can_pick:
			if Input.is_action_just_pressed("ui_left"):
				choice3 = 0
			if Input.is_action_just_pressed("ui_right"):
				choice3 = 1
		else:
			choice3 = 0
		if choice3 == 0:
			$confirm/no.label_settings.font_color = Color(1,1,0)
			$confirm/yes.label_settings.font_color = Color(1,1,1)
		else:
			$confirm/no.label_settings.font_color = Color(1,1,1)
			$confirm/yes.label_settings.font_color = Color(1,1,0)
		if Input.is_action_just_pressed("back"):
			state = 1
		if Input.is_action_just_pressed("select"):
			if choice3 == 0:
				state = 1
			else:
				state = 3
				$AudioStreamPlayer.stream = preload("res://assets/sounds/mus_cymbal.ogg")
				$AudioStreamPlayer.play()
				await create_tween().tween_property($ColorRect,"modulate:a",1,5.25).finished
				data.savedata["name"] = $name/name.text
				fade.setFade(1)
				get_tree().change_scene_to_file("res://rooms/"+data.rooms[0]+".tscn")
