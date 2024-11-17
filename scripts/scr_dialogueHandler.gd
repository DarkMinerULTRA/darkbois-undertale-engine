extends CanvasLayer

signal dialogueFinished
var skip = false

func doDialogue(dialogue : Array,sound : String = "",wait_time : float = 0.05):
	visible = true
	var wait = false
	var face = false
	var facename = ""
	$UiBox/AnimatedSprite2D.animation = "none"
	global.can_player_move = false
	if sound != "":
		$UiBox/AudioStreamPlayer.stream = load("res://assets/sounds/"+sound+".wav")
	else:
		$UiBox/AudioStreamPlayer.stream = load("res://assets/sounds/SND_TXT1.wav")
	for i in dialogue:
		skip = false
		var text_index = 0
		$UiBox/Label.text = ""
		for j in i:
			text_index += 1
			if wait == true:
				wait = false
				if !skip:
					await get_tree().create_timer(float(j)/10).timeout
			elif j == "&":
				$UiBox/Label.text += "\n"
			elif j == "^":
				wait = true
			elif j == "%":
				if face == false:
					face = true
					facename = ""
				else:
					face = false
					if facename != "":
						$UiBox/AnimatedSprite2D.animation = facename
					else:
						$UiBox/AnimatedSprite2D.animation = "none"
			elif face:
				facename += j
			else:
				$UiBox/Label.text += j
				if fmod(text_index,2) == 1:
					if $UiBox/AnimatedSprite2D.frame == 1:
						$UiBox/AnimatedSprite2D.frame = 0
					else:
						$UiBox/AnimatedSprite2D.frame = 1
				if !skip:
					$UiBox/AudioStreamPlayer.play()
					await get_tree().create_timer(wait_time).timeout
		$UiBox/AnimatedSprite2D.frame = 1
		while !Input.is_action_just_pressed("select"):
			await get_tree().process_frame
	visible = false
	global.can_player_move = true
	dialogueFinished.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $UiBox/AnimatedSprite2D.animation == "none":
		$UiBox/Label.position.x = -133
	else:
		$UiBox/Label.position.x = -69
	if Input.is_action_pressed("back"):
		skip = true
