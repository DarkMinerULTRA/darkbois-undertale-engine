extends Node

var audio = AudioStreamPlayer.new()

var room_audio = {
	"room_overworldtest":"mus_ruins.ogg",
	"room_test2":"mus_ruins.ogg"
}

func pause(paused : bool):
	audio.stream_paused = paused

func _ready():
	add_child(audio)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !get_tree().current_scene:
		return
	if get_tree().current_scene.name == data.rooms[data.savedata["curScene"]] and data.rooms[data.savedata["curScene"]] in room_audio:
		if audio.stream == load("res://assets/music/"+room_audio[data.rooms[data.savedata["curScene"]]]):
			return
		else:
			audio.stream = load("res://assets/music/"+room_audio[data.rooms[data.savedata["curScene"]]])
		if audio.playing == false:
			audio.play()
	else:
		audio.stream_paused = true
