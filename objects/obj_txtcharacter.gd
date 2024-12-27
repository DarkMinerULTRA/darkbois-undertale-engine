extends Node2D

@export var character  : String
@export var font : String = "dtm"
@export var color : Color = Color(1,1,1)
@export var fontsize : int = 16
@export_enum("Normal","Shaky","Wavy") var character_type = "Normal"

var timer : float = 0


var charlist = [
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',' ','0','1','2','3','4','5','6','7','8','9','.',',','\'','"','_','+','-','=','?',"/","!","$","&","(",")","#","%","*",":",";","<",">","[","]","\\","^"
]

func _process(_delta):
	timer += _delta
	$Sprite2D.modulate = color
	$Sprite2D.scale = Vector2((0.5/16)*fontsize,(0.5/16)*fontsize)
	match character_type:
		"Shaky":
			$Sprite2D.position = Vector2(randf_range(-1,1)*0.25,randi_range(-1,1)*0.25)
		"Wavy":
			$Sprite2D.position = Vector2((cos(timer*2)*2),(sin(timer*2)*2))
		"Normal":
			$Sprite2D.position = Vector2.ZERO
	if charlist.find(character)+1 <= 9:
		if $Sprite2D.texture != load("res://assets/sprites/fonts/dtm/ch_0"+str(charlist.find(character)+1)+".png"):
			$Sprite2D.texture = load("res://assets/sprites/fonts/dtm/ch_0"+str(charlist.find(character)+1)+".png")
	else:
		if $Sprite2D.texture != load("res://assets/sprites/fonts/dtm/ch_"+str(charlist.find(character)+1)+".png"):
			$Sprite2D.texture = load("res://assets/sprites/fonts/dtm/ch_"+str(charlist.find(character)+1)+".png")
