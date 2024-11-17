extends Label

func _process(_delta):
	if get_parent().has_node("TextureProgressBar") == true:
		position.x = get_parent().get_node("TextureProgressBar").position.x+(20*(get_parent().get_node("TextureProgressBar").scale.x))+7
	text = str(data.savedata["hp"])+"/"+str(data.savedata["maxhp"])
