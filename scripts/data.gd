extends Node

var savefile_exists = FileAccess.file_exists("user://data.save")

var soulcolors = [
	Color(1,0,0,1),
	Color(1,0.6,0,1),
	Color(0.9,1,0,1)
]

var rooms = [
	"room_overworldtest",
	"room_test2"
]

var room_names = {
	"room_overworldtest":"Ruins - Room 1"
}

var room_encounters = {
	"room_overworldtest":["Shroomy"]
}

var areas = {
	"ruins":{
		"rooms":["room_overworldtest","room_test2"],
		"population":10
	}
}

var items = {
	"Stick":{
		"name":"Stick", # has to be filled for the drop message to work
		"short":"Stick", # in-battle name
		"type":"weapon", # can be "weapon", "armor", "special", or "item". special does nothing but do dialogue. e.g. the Annoying Dog.
		"value":0, # weapon = atk bonus, armor = def bonus, item = hp recovered, special = does nothing. if special this value can be removed.
		"info":["* \"Stick\" - +3 ATK&* Stick."], # text when using info in menu
		"equip":["* You equipped the Stick."] # Pick a random string from this list to display upon using the item.
	},
	"Toy Knife":{
		"name":"Toy Knife",
		"short":"Toy Knife",
		"type":"weapon",
		"value":3,
		"info":["* \"Toy Knife\" - +3 ATK&* Made of plastic.^5&  A rarity nowadays."],
		"equip":["* You threw the stick away.^5&  Then picked it back up."]
	},
	"Bandage":{
		"name":"Bandage",
		"short":"Bandage",
		"type":"armor",
		"value":0,
		"info":["* \"Bandage\" - +0 DEF&* It has already been used&  many times."],
		"equip":["* You reapply the Bandage.^5&  Still kind of gooey."]
	},
	"Monster Candy":{
		"name":"Monster Candy",
		"short":"MnstrCandy",
		"type":"item",
		"value":10,
		"info":["* \"Monster Candy\" - Heals 10 HP&* Has a distinct, non-licorice&  flavor."],
		"equip":["* You ate the Monster Candy.^5&  Very un-licorice-like.","* You ate the Monster Candy.^5&  ... tastes like licorice."]
	},
	"Butterscotch Pie":{
		"name":"Butterscotch Pie",
		"short":"ButtsPie",
		"type":"item",
		"value":100,
		"equip":["* You ate the Butterscotch Pie."]
	},
}

var calls = {}

var savedata = {
	"curScene":0, # current scene. used for loading. used as index for list "rooms" (see line 11)
	"name":"Chara", # name.
	"lv":1, # LOVE value.
	"exp":0, # exp.
	"maxhp":20, # max hp. e.g. lv 1 = 20, lv 2 = 24, lv 3 = 28, etc.
	"hp":20, # current hp.
	"at":0, # atk value.
	"def":0, # defense.
	"weapon":"Stick", # current weapon.
	"armor":"Bandage", # current armor.
	"g":0, # monies.
	"items":["Monster Candy","Monster Candy","Monster Candy","Monster Candy"], # your inventory. all items must be defined in "items" dictionary (see line 15)
	"cell":["Toriel"], # people you can call. defined in calls (see line 49)
	"npc_state":{},
	"time":0,
	"kills":0
}

var battledata = [
	{
		"encounter":"* You encountered a very&  mushroomy Shroomy.",
		"name":"Shroomy", # name in menu
		"obj":"shroomy", # loads obj_[obj].tscn
		"hp":20, # enemy hp
		"exp":50, # exp on kill
		"gold":50, # gold on win
		"atk":3, # atk
		"def":1, # def
		"fake_stats":false, # if true, displays fake stats
		"fake_atk":20,
		"fake_def":20,
		"check":"* A simple mushroom.^5&* With a face.", # check message.
		"acts":["Check","Say Hi","telekenothing"], # acts. define these in battleHandler's "_action" function.
		"flavTexts":["* Smells like mushroom stew.^5&  Gross.","* Smells like mushroom stew.^5&  Delicious!"], # random texts.
		"attacks":["mushroom","flyingmushroom"], # loads "objects/attacks/[random attack name].tscn". if attacks_in_order is true, it will play these in order. if attacks_in_order and loop_attacks is on, these will repeat.
		"spare":false, # if you can spare the enemy at the start. example: you can spare whimsun and moldsmal instantly
		"lines_in_order":false, # use for boss battles where you have to wait out the boss, like papyrus, and sans. if loop_lines is false, will repeat last line. else repeat from beginning.
		"attacks_in_order":true, # ditto. if loop_attacks is false, will skip monster turn and make monster sparable like papyrus.
		"loop_lines":false, # only required if lines_in_order is true. if so, will repeat lines from beginning
		"loop_attacks":false, # ditto but with attacks.
		"dialogs":[["Dialogue 1."],["Dialogue 2."],["Dialogue 3."]] # random dialogs. if lines_in_order is true, it will play these in order. if lines_in_order and loop_lines is on, these will repeat.
	}
]

var spawnpositions = {
	"room_overworldtest":Vector2(160,120)
}

func save_file():
	var file = FileAccess.open("user://data.save", FileAccess.WRITE)
	var json_string = JSON.stringify(savedata)
	file.store_line(json_string)
	print("Successfully saved game")

func get_savedata():
	if savefile_exists == false:
		return
	var file = FileAccess.open("user://data.save", FileAccess.READ)
	var json = JSON.new()
	var to_parse = file.get_line()
	var parse_result = json.parse(to_parse)
	if parse_result == OK:
		return json.get_data()
	else:
		return

func load_file():
	playerVariables.position = Vector2.ZERO
	if get_savedata():
		savedata = get_savedata()
		get_tree().change_scene_to_file("res://rooms/"+rooms[savedata["curScene"]]+".tscn")
		print(savedata)
		print("Successfully loaded save game")
	else:
		print("JSON parse failed")

func _process(_delta):
	savefile_exists = FileAccess.file_exists("user://data.save")
