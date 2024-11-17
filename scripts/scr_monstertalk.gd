extends Node2D

var skip = false

signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	battleHandler.monsterDialogueStart.connect(_Dialogue)

func _Dialogue(dialogue : Array,sound : String = "SND_TXT1",wait_time : float = 0.05):
	print("Printing MONSTER DIALOGUE")
	$AudioStreamPlayer.stream = load("res://assets/sounds/"+sound+".wav")
	visible = true
	var wait = false
	for i in dialogue:
		skip = false
		$Label.text = ""
		for j in i:
			if wait == true:
				wait = false
				if !skip:
					await get_tree().create_timer(float(j)/10).timeout
			elif j == "&":
				$Label.text = $Label.text + "\n"
			elif j == "^":
				wait = true
			else:
				$Label.text = $Label.text + j
				if !skip:
					$AudioStreamPlayer.play()
					await get_tree().create_timer(wait_time).timeout
		while not Input.is_action_just_pressed("select"):
			await get_tree().process_frame
	finished.emit()
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("back"):
		skip = true
