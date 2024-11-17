extends CanvasLayer

var quit = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label.modulate.a = quit/100
	if Input.is_action_pressed("quit"):
		quit += 1.5
	else:
		quit = 0.0
	if quit >= 100.0:
		get_tree().quit()
