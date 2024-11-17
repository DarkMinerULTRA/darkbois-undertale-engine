extends Node2D

@export var text : String
var velocity = 2
const GRAVITY = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = text
	var startingPos = position
	position.y -= velocity
	velocity -= GRAVITY
	while position.y < startingPos.y:
		position.y -= velocity
		velocity -= GRAVITY
		await get_tree().process_frame
	position = startingPos
	await get_tree().create_timer(0.2).timeout
	queue_free()
