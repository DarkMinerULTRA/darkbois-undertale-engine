extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$BattleBox._BattleDialogue(["* But nobody came."])
	await $BattleBox.finished
	fade.fadeOut(0.25)
	await get_tree().create_timer(0.25).timeout
	get_tree().change_scene_to_file("rooms/"+data.rooms[data.savedata["curScene"]]+".tscn")
