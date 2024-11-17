extends Node

@export var can_player_move = true
var audio = AudioStreamPlayer.new()

func _ready():
	add_child(audio)
	audio.stream = preload("res://assets/sounds/snd_levelup.wav")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		if get_window().mode == get_window().MODE_FULLSCREEN:
			get_window().mode = get_window().MODE_WINDOWED
		else:
			get_window().mode = get_window().MODE_FULLSCREEN

func getCurrentCamera2D():
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera:
			if camera is Camera2D and camera.enabled:
				return camera
	return null

func _levelup():
	print("Testing for levelup")
	var exp_needed = 0
	var currentlevel = data.savedata["lv"]
	if (data.savedata["exp"] >= 10):
		data.savedata["lv"] = 2
	if (data.savedata["exp"] >= 30):
		data.savedata["lv"] = 3
	if (data.savedata["exp"] >= 70):
		data.savedata["lv"] = 4
	if (data.savedata["exp"] >= 120):
		data.savedata["lv"] = 5
	if (data.savedata["exp"] >= 200):
		data.savedata["lv"] = 6
	if (data.savedata["exp"] >= 300):
		data.savedata["lv"] = 7
	if (data.savedata["exp"] >= 500):
		data.savedata["lv"] = 8
	if (data.savedata["exp"] >= 800):
		data.savedata["lv"] = 9
	if (data.savedata["exp"] >= 1200):
		data.savedata["lv"] = 10
	if (data.savedata["exp"] >= 1700):
		data.savedata["lv"] = 11
	if (data.savedata["exp"] >= 2500):
		data.savedata["lv"] = 12
	if (data.savedata["exp"] >= 3500):
		data.savedata["lv"] = 13
	if (data.savedata["exp"] >= 5000):
		data.savedata["lv"] = 14
	if (data.savedata["exp"] >= 7000):
		data.savedata["lv"] = 15
	if (data.savedata["exp"] >= 10000):
		data.savedata["lv"] = 16
	if (data.savedata["exp"] >= 15000):
		data.savedata["lv"] = 17
	if (data.savedata["exp"] >= 25000):
		data.savedata["lv"] = 18
	if (data.savedata["exp"] >= 50000):
		data.savedata["lv"] = 19
	if (data.savedata["exp"] >= 99999):
		data.savedata["lv"] = 20
		data.savedata["exp"] = 99999
	if currentlevel != data.savedata["lv"]:
		print("Leveling up to lv "+str(data.savedata["lv"])+"!")
		audio.play()
		data.savedata["maxhp"] = 16 + (data.savedata["lv"] * 4)
		data.savedata["hp"] = data.savedata["maxhp"]
		data.savedata["at"] = 8 + (data.savedata["lv"] * 2)
		data.savedata["def"] = 9 + ceil((data.savedata["lv"] / 4.0))
		return true
	else:
		print("EXP not high enough to change lv")
		return false

func get_exp_remaining() -> int:
	var exp_needed = 0
	if (data.savedata["exp"] < 99999):
		exp_needed = 99999-data.savedata["exp"]
	if (data.savedata["exp"] < 50000):
		exp_needed = 50000-data.savedata["exp"]
	if (data.savedata["exp"] < 25000):
		exp_needed = 25000-data.savedata["exp"]
	if (data.savedata["exp"] < 15000):
		exp_needed = 15000-data.savedata["exp"]
	if (data.savedata["exp"] < 10000):
		exp_needed = 10000-data.savedata["exp"]
	if (data.savedata["exp"] < 7000):
		exp_needed = 7000-data.savedata["exp"]
	if (data.savedata["exp"] < 5000):
		exp_needed = 5000-data.savedata["exp"]
	if (data.savedata["exp"] < 3500):
		exp_needed = 3500-data.savedata["exp"]
	if (data.savedata["exp"] < 2500):
		exp_needed = 2500-data.savedata["exp"]
	if (data.savedata["exp"] < 1700):
		exp_needed = 1700-data.savedata["exp"]
	if (data.savedata["exp"] < 1200):
		exp_needed = 1200-data.savedata["exp"]
	if (data.savedata["exp"] < 800):
		exp_needed = 800-data.savedata["exp"]
	if (data.savedata["exp"] < 500):
		exp_needed = 500-data.savedata["exp"]
	if (data.savedata["exp"] < 300):
		exp_needed = 300-data.savedata["exp"]
	if (data.savedata["exp"] < 200):
		exp_needed = 200-data.savedata["exp"]
	if (data.savedata["exp"] < 120):
		exp_needed = 120-data.savedata["exp"]
	if (data.savedata["exp"] < 70):
		exp_needed = 70-data.savedata["exp"]
	if (data.savedata["exp"] < 30):
		exp_needed = 30-data.savedata["exp"]
	if (data.savedata["exp"] < 10):
		exp_needed = 10-data.savedata["exp"]
	return exp_needed

func steps_required_until_encounter():
	var required : int
	var cur_steps = playerVariables.steps
	var kills = data.savedata["kills"]
	var population : int
	for i in data.areas:
		if data.areas[i]["rooms"].has(data.rooms[data.savedata["curScene"]]):
			population = data.areas[i]["population"]
			break
	if population-kills > 0:
		var populationfactor = population / (population - kills)
		if populationfactor > 8:
			populationfactor = 8
		required = (randi_range(60,240) + randi_range(0,20)) * populationfactor
	else:
		required = 20
	print(required)
	return required
