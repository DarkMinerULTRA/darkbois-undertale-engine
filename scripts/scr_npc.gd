extends StaticBody2D

@export var id : int
@export var animationName : String = "froggit"
@export var dialogue : Array[String]
@export var startBattle : bool = false
@export var battle_id : int
@export var post_interact_dialogue : Array[String]
@export var battle_theme : String = "mus_battle1"
var canInteract = true
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = animationName

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if data.savedata["npc_state"].has(str(id)):
		if state != data.savedata["npc_state"][str(id)]:
			print(name+": loading npc state "+str(data.savedata["npc_state"][str(id)]))
			state = data.savedata["npc_state"][str(id)]
	if state == 2:
		queue_free()
	for i in $Area2D.get_overlapping_bodies():
		if i.name == "player":
			if global.can_player_move == true and Input.is_action_just_pressed("select") and canInteract:
				canInteract = false
				await interact()
				state = 1
				data.savedata["npc_state"][id] = 1
				canInteract = true

func interact():
	if state == 1:
		if post_interact_dialogue:
			dialogueHandler.doDialogue(post_interact_dialogue)
			await dialogueHandler.dialogueFinished
		else:
			dialogueHandler.doDialogue(dialogue)
			await dialogueHandler.dialogueFinished
		while Input.is_action_just_pressed("select"):
			await get_tree().process_frame
	else:
		dialogueHandler.doDialogue(dialogue)
		await dialogueHandler.dialogueFinished
		if startBattle == true:
			data.savedata["npc_state"][id] = 1
			battleHandler.startBattle(battle_id,true,battle_theme,id)
		else:
			while Input.is_action_just_pressed("select"):
				await get_tree().process_frame
