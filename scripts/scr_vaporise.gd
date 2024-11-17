extends Node2D

@onready var sprite = get_parent().get_node("Hurt/Sprite2D").texture
@export_range(0,100) var progress : float = 0
var vaporSprite : Array = []
@onready var startPos :Vector2 = get_parent().get_node("Hurt/Sprite2D").position-Vector2(sprite.get_width()/2,sprite.get_height()/2)

func _draw():
	var pos : Vector2 = startPos
	print((progress/100)*sprite.get_height()/2)
	for i in vaporSprite:
		var startX = pos.x
		for j in i:
			pos.x+=1
			if j == 1:
				var newPos = pos
				var mod = abs(pos.y-sprite.get_height()/2)
				newPos.y -= (mod*((abs(pos.y)-(-sprite.get_height()/2))/50))*(progress/100)
				draw_rect(Rect2(newPos,Vector2(1,1)),Color(1,1,1,1-snappedf((newPos.distance_to(pos)/5),0.2)))
		pos.x = startX
		pos.y+=1

func _ready():
	var image = sprite.get_image()
	#image.lock()
	for i in range(sprite.get_height()):
		var Xline = []
		for j in range(sprite.get_width()):
			if	image.get_pixel(j, i) == Color.WHITE:
				Xline.append(1)
			else:
				Xline.append(0)
		vaporSprite.append(Xline)

func _process(_delta):
	queue_redraw()
