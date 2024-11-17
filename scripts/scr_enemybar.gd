extends TextureProgressBar



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	max_value = data.battledata[battleHandler.battleId]["hp"]
	value = data.battledata[battleHandler.battleId]["hp"]
