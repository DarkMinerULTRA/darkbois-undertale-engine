@tool
extends Node2D

@export var size = Vector2(100,100)

# Called when the node enters the scene tree for the first time.
func _ready():
	$box.size.x = size.x
	$box.size.y = size.y
	$box.position.x = -size.x/2
	$box.position.y = -size.y/2
	$box/ColorRect2.size.x = size.x - 6
	$box/ColorRect2.size.y = size.y - 6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$box.size.x = lerp($box.size.x,size.x,0.2)
	$box.size.y = lerp($box.size.y,size.y,0.2)
	$box.position.x = -$box.size.x/2
	$box.position.y = -$box.size.y/2
	$box/ColorRect2.size.x = $box.size.x-6
	$box/ColorRect2.size.y = $box.size.y-6
