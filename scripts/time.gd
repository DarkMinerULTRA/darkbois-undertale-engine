extends Node

var active = false

func _ready() -> void:
	count()

func count():
	if active:
		data.savedata["time"] += 1
	await get_tree().create_timer(1).timeout
	count()
