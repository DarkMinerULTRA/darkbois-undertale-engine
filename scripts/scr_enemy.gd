extends Node2D

@export var sprite : Texture2D

signal hurt

func _hurt():
	$Hurt.visible = true
	$Normal.visible = false
	for i in range(8):
		position.x = 155
		await get_tree().create_timer(0.05).timeout
		position.x = 165
		await get_tree().create_timer(0.05).timeout
	position.x = 160

func _ready():
	hurt.connect(_hurt)
