extends Node2D

var select = 0
var state = 0
var select2 = 0
var tween1 : Tween
var tween2 : Tween
var save = data.get_savedata()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if save:
		$name.text = save["name"]
		$confirm/name.text = save["name"]
		$lv.text = "LV "+str(save["lv"])
		$location.text = data.room_names[data.rooms[save["curScene"]]]

func _process(_delta: float) -> void:
	$confirm/name.rotation_degrees = randf_range(-2,2)
	match state:
		0:
			$confirm/name.scale = Vector2(1,1)
			$confirm/name.position = Vector2(140,55)
			if tween1:
				tween1.stop()
			if tween2:
				tween2.stop()
			$confirm.visible = false
			if Input.is_action_just_pressed("ui_left"):
				select = 0
			if Input.is_action_just_pressed("ui_right"):
				select = 1
			if Input.is_action_just_pressed("ui_down"):
				select = 2
			if Input.is_action_just_pressed("ui_up") and select == 2:
				select = 0
			if Input.is_action_just_pressed("select"):
				match select:
					0:
						data.load_file()
					1:
						state = 1
						tween1 = create_tween()
						tween2 = create_tween()
						tween1.tween_property($confirm/name,"scale",Vector2(3.075,3.075),2)
						tween2.tween_property($confirm/name,"position",Vector2(107,107),2)
			match select:
				0:
					$continue.label_settings.font_color = Color(1,1,0)
					$reset.label_settings.font_color = Color(1,1,1)
				1:
					$continue.label_settings.font_color = Color(1,1,1)
					$reset.label_settings.font_color = Color(1,1,0)
				2:
					$continue.label_settings.font_color = Color(1,1,1)
					$reset.label_settings.font_color = Color(1,1,1)
		1:
			$confirm.visible = true
			match select2:
				0:
					$confirm/no.label_settings.font_color = Color(1,1,0)
					$confirm/yes.label_settings.font_color = Color(1,1,1)
				1:
					$confirm/no.label_settings.font_color = Color(1,1,1)
					$confirm/yes.label_settings.font_color = Color(1,1,0)
			if Input.is_action_just_pressed("ui_left"):
				select2 = 0
			if Input.is_action_just_pressed("ui_right"):
				select2 = 1
			if Input.is_action_just_pressed("back"):
				select2 = 0
				state = 0
			if Input.is_action_just_pressed("select"):
				match select2:
					0:
						select2 = 0
						state = 0
					1:
						data.savedata["name"] = save["name"]
						state = 3
						$confirm/yes.visible = false
						$confirm/no.visible = false
						$AudioStreamPlayer.stream = preload("res://assets/sounds/mus_cymbal.ogg")
						$AudioStreamPlayer.play()
						await create_tween().tween_property($ColorRect,"color:a",1,5.25).finished
						fade.setFade(1)
						get_tree().change_scene_to_file("res://rooms/"+data.rooms[0]+".tscn")
