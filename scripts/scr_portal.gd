extends Area2D

@export var room_id : int
@export var room_position : Vector2
var touched = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for i in get_overlapping_bodies():
		if i.name == "player" and !touched:
			global.can_player_move = false
			playerVariables.encountered_enemy = false
			playerVariables.steps = 0
			touched = true
			fade.fadeOut(0.25)
			await get_tree().create_timer(0.25).timeout
			playerVariables.position = room_position
			data.savedata["curScene"] = room_id
			get_tree().change_scene_to_file("res://rooms/"+data.rooms[room_id]+".tscn")
