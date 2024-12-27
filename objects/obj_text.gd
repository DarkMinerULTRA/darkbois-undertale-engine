extends Node2D

@export var text : String
var chartypes = ["Normal","Shaky","Wavy"]

func _process(_delta):
	var letter = 0
	var number = 0
	for i in get_children():
		number += 1
		letter += 1
		if text.length() != 1:
			while text[number-1] == "&" or text[number-1] == "\\" or text[number-1] == "$":
				number += 1
		if text.length() < number or text.length() == 0 or text[number-1] != i.character:
			i.queue_free()
	letter = 0
	var pos = Vector2(0,0)
	var color = "ffffff"
	var coloring = 0
	var type = 0
	for i in text:
		match i:
			"&":
				pos.x = 0
				pos.y += 18
			"\\":
				coloring = 6
				color = ""
			"$":
				type += 1
			_:
				letter += 1
				if coloring != 0:
					coloring -= 1
					color += i.to_upper()
				else:
					if !get_node_or_null("chara"+str(letter)):
						var chara = preload("res://objects/obj_txtcharacter.tscn").instantiate()
						chara.name = "chara"+str(letter)
						chara.character = i
						chara.color = Color(color)
						chara.position = pos
						chara.character_type = chartypes[fmod(type,3)]
						add_child(chara)
					pos.x += 8
