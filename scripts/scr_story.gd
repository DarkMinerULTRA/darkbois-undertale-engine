extends Node2D

var image = 0
var skip = false

func _ready() -> void:
	while $AudioStreamPlayer.playing != true:
		await get_tree().process_frame
	create_tween().tween_property($image,"modulate:a",1,0.2)
	await type("Long ago^1, two races&ruled over Earth:^1&HUMANS and MONSTERS.^6^1")
	await get_tree().create_timer(1.5).timeout
	fade_image()
	await get_tree().create_timer(0.2).timeout
	await type("One day^1, war broke&out between the two&races.^6^1")
	await get_tree().create_timer(1.5).timeout
	fade_image()
	await get_tree().create_timer(0.2).timeout
	await type("After a long battle^1,&the humans were&victorious.^6^1")
	await get_tree().create_timer(1.5).timeout
	fade_image()
	await get_tree().create_timer(0.2).timeout
	await type("They sealed the monsters&underground with a magic&spell.^6^1")
	await get_tree().create_timer(1.5).timeout
	fade_image()
	await get_tree().create_timer(0.2).timeout
	await type("Many years later.^2.^2.^5^1")
	await get_tree().create_timer(2.25).timeout
	fade_image()
	await get_tree().create_timer(0.2).timeout
	await type("      MT. EBOTT&         201X^9")
	await get_tree().create_timer(1.5).timeout
	fade_image()
	await get_tree().create_timer(0.2).timeout
	await type("Legends say that those&who climb the mountain&never return.^5^3")
	await get_tree().create_timer(1.5).timeout
	fade_image()
	await get_tree().create_timer(1.4).timeout
	fade_image()
	await get_tree().create_timer(1.6).timeout
	fade_image()
	await get_tree().create_timer(1.6).timeout
	fade_image()
	await get_tree().create_timer(0.2).timeout
	$AudioStreamPlayer.stop()
	await type("they died.^9^1&lol^5^5")
	get_tree().change_scene_to_file("res://rooms/room_begin.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select") and not skip:
		skip = true
		fade.fadeOut(0.5)
		await create_tween().tween_property($AudioStreamPlayer,"volume_db",-40,0.5).finished
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://rooms/room_begin.tscn")

func type(text : String):
	$Label.text = ""
	var wait = false
	for i in text:
		if skip:
			$Label.text = ""
			return
		if wait == true:
			wait = false
			await get_tree().create_timer(float(i)/10).timeout
		elif i == "&":
			$Label.text += "\n"
		elif i == "^":
			wait = true
		else:
			$Label.text += i
			if i != " ":
				$txtsound.play()
			await get_tree().create_timer(0.06).timeout

func fade_image():
	await create_tween().tween_property($image,"modulate:a",0,0.2).finished
	image += 1
	$image.texture = load("res://assets/sprites/intro/spr_introimage_"+str(image)+".png")
	create_tween().tween_property($image,"modulate:a",1,0.2)
