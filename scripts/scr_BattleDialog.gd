extends Node2D

@export var skip = false
signal finished
var firstTurn = true

func FlavorDialogue(dialogue : String,wait_time : float = 0.05):
	visible = true
	var wait = false
	skip = false
	$Label.text = ""
	for j in dialogue:
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

func _BattleDialogue(dialogue : Array,wait_time : float = 0.05):
	print("Printing BATTLE DIALOGUE!! :D")
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
	

# Called when the node enters the scene tree for the first time.
func _ready():
	battleHandler.playDialogue.connect(_BattleDialogue)
	battleHandler.playerTurnStart.connect(handleFlavourText)
	battleHandler.monsterTurnStart.connect(disableFirstTurn)

func disableFirstTurn():
	firstTurn = false

func handleFlavourText():
	await get_tree().process_frame
	if firstTurn == true:
		FlavorDialogue(data.battledata[battleHandler.battleId]["encounter"])
	else:
		FlavorDialogue(data.battledata[battleHandler.battleId]["flavTexts"][randi_range(0,data.battledata[battleHandler.battleId]["flavTexts"].size()-1)])

func _process(_delta):
	if Input.is_action_just_pressed("back"):
		skip = true
