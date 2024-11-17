extends AnimatedSprite2D

@export var id : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if battleHandler.choice == id and (battleHandler.choose1 == true or battleHandler.choose2 == true):
		frame = 1
	else:
		frame = 0
