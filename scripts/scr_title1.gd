extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	fade.setFade(0)
	await get_tree().create_timer(2).timeout
	while true:
		$Label3.visible = !$Label3.visible
		await get_tree().create_timer(0.5).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("select"):
		print("Going to main menu!")
		if data.savefile_exists:
			get_tree().change_scene_to_file("res://rooms/room_menu.tscn")
		else:
			get_tree().change_scene_to_file("res://rooms/room_intromenu.tscn")
