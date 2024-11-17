extends Label

@export var prefix : String
@export var dataName : String

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	text = prefix+str(data.savedata[dataName])
