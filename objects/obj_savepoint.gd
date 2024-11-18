extends "res://scripts/scr_npc.gd"

func _ready():
	pass

func _process(_delta):
	for i in $Area2D.get_overlapping_bodies():
		if i.name == "player":
			if global.can_player_move == true and Input.is_action_just_pressed("select") and canInteract:
				canInteract = false
				await interact()
				canInteract = true

func interact():
	battleHandler._heal(99)
	dialogueHandler.doDialogue(dialogue)
	await dialogueHandler.dialogueFinished
	ui_save.save_ui()
