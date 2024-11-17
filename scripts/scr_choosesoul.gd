extends Sprite2D

var positions1 = [
	Vector2(22,223),
	Vector2(102,223),
	Vector2(181,223),
	Vector2(261,223)
]
var positions2 = [
	Vector2(30,138),
	Vector2(173,138),
	Vector2(30,153),
	Vector2(173,153)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	modulate = data.soulcolors[battleHandler.soulMode]
	visible = true
	if battleHandler.choose1 == true:
		scale = Vector2(0.5,0.5)
		playerVariables.soulPos = position
		if battleHandler.choice != 4:
			position = positions1[battleHandler.choice]
	elif battleHandler.choose2 == true:
		scale = Vector2(0.6,0.6)
		playerVariables.soulPos = position
		if battleHandler.choice2 != 4:
			position = positions2[battleHandler.choice2]
	else:
		visible = false
