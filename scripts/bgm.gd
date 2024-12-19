extends Node

var audio = AudioStreamPlayer.new()

var room_audio = {
	"room_entrance":"mus_ruins.ogg",
	"room_spikepuzzle1":"mus_ruins.ogg",
	"room_tree":"mus_ruins.ogg",
	"room_long":"mus_ruins.ogg",
	"room_long2":"mus_ruins.ogg",
	"room_chest":"mus_ruins.ogg",
	"room_ghostgames":"mus_gameshow.ogg",
	"ghosts":"mus_gathering.ogg"
}

func pause(paused : bool):
	audio.stream_paused = paused

func _ready():
	add_child(audio)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if playerVariables.next_room != "":
		if room_audio.has(playerVariables.next_room):
			if audio.stream != load("res://assets/music/"+room_audio[playerVariables.next_room]):
				audio.volume_db = 0-(60*fade.get_node("fade").color.a)
			else:
				audio.volume_db = 0
		else:
			audio.volume_db = 0-(60*fade.get_node("fade").color.a)
	if !get_tree().current_scene:
		return
	if get_tree().current_scene.name in room_audio:
		if audio.stream == load("res://assets/music/"+room_audio[get_tree().current_scene.name]):
			return
		else:
			audio.stream = load("res://assets/music/"+room_audio[get_tree().current_scene.name])
		if audio.playing == false:
			audio.play()
	else:
		audio.stream = null
