extends CanvasLayer

var state = 0
var choice = 0

func _enter_tree():
	visible = false

func _process(_delta):
	if choice == 0:
		$heart.position.x = 75.5
	else:
		$heart.position.x = 167

func save_ui():
	global.can_player_move = false
	var save = data.get_savedata()
	if save:
		$Label.text = save["name"]
		$Label2.text = "LV "+str(save["lv"])
		if str(fmod(save["time"],60)).length() == 1:
			$Label3.text = str(floor(save["time"]/60))+":0"+str(fmod(save["time"],60))
		else:
			$Label3.text = str(floor(save["time"]/60))+":"+str(fmod(save["time"],60))
		$Label4.text = data.room_names[data.rooms[save["curScene"]]]
	$Label.label_settings.font_color = Color(1,1,1)
	$Label5.text = "Save"
	$heart.visible = true
	$Label6.visible = true
	choice = 0
	$heart.position.x = 75.5
	$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_squeak.wav")
	visible = true
	await get_tree().process_frame
	while not Input.is_action_just_pressed("select") and not Input.is_action_just_pressed("back"):
		if Input.is_action_just_pressed("ui_left"):
			$AudioStreamPlayer.play()
			choice -= 1
			choice = fmod(choice,2)
		if Input.is_action_just_pressed("ui_right"):
			$AudioStreamPlayer.play()
			choice += 1
			choice = fmod(choice,2)
		await get_tree().process_frame
	if Input.is_action_just_pressed("back") or choice == 1:
		await get_tree().process_frame	
		visible = false
		global.can_player_move = true
		return
	await get_tree().process_frame
	$Label.text = data.savedata["name"]
	$Label2.text = "LV "+str(data.savedata["lv"])
	if str(fmod(data.savedata["time"],60)).length() == 1:
		$Label3.text = str(floor(data.savedata["time"]/60))+":0"+str(fmod(data.savedata["time"],60))
	else:
		$Label3.text = str(floor(data.savedata["time"]/60))+":"+str(fmod(data.savedata["time"],60))
	global.can_player_move = false
	$Label4.text = data.room_names[data.rooms[data.savedata["curScene"]]]
	$Label.label_settings.font_color = Color(1,1,1)
	$Label6.visible = false
	$heart.visible = false
	$Label5.text = " File saved."
	$AudioStreamPlayer.stream = preload("res://assets/sounds/snd_save.wav")
	$AudioStreamPlayer.play()
	data.save_file()
	$Label.label_settings.font_color = Color(1,1,0)
	while not Input.is_action_just_pressed("select"):
		await get_tree().process_frame
	await get_tree().process_frame
	visible = false
	global.can_player_move = true
