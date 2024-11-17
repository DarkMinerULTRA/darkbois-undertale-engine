extends CharacterBody2D

@export var moveSpeed = 50
@export var safe = false
@export var can_move = false

func _ready():
	playerVariables.soul = self

func _physics_process(_delta):
	modulate = data.soulcolors[battleHandler.soulMode]
	if can_move == true:
		$CollisionShape2D.disabled = false
		playerVariables.soulPos = position
		var dir = Vector2.ZERO
		match battleHandler.soulMode:
			0:
				dir = Vector2(Input.get_axis("move_left","move_right"),Input.get_axis("move_up","move_down"))
		velocity = dir*moveSpeed
		move_and_slide()
		for i in $Area2D.get_overlapping_areas():
			if battleHandler.safe == false:
				match i.name:
					"attack0":
						var HPmod : int
						if data.savedata["hp"] and data.savedata["hp"] <= 20:
							HPmod = 0
						if 20 < data.savedata["hp"] and data.savedata["hp"] < 30:
							HPmod = 1
						if 30 <= data.savedata["hp"] and data.savedata["hp"] < 40:
							HPmod = 2
						if 40 <= data.savedata["hp"] and data.savedata["hp"] < 50:
							HPmod = 3
						if 50 <= data.savedata["hp"] and data.savedata["hp"] < 60:
							HPmod = 4
						if 60 <= data.savedata["hp"] and data.savedata["hp"] < 70:
							HPmod = 5
						if 70 <= data.savedata["hp"] and data.savedata["hp"] < 80:
							HPmod = 6
						if 80 <= data.savedata["hp"] and data.savedata["hp"] < 90:
							HPmod = 7
						if 90 <= data.savedata["hp"]:
							HPmod = 8
						battleHandler._hurt(round((data.battledata[battleHandler.battleId]["atk"]) + HPmod - ((data.savedata["def"]+data.items[data.savedata["armor"]]["value"]) / 5)))
					"attack1":
						if dir == Vector2.ZERO:
							return
						var HPmod : int
						if data.savedata["hp"] and data.savedata["hp"] <= 20:
							HPmod = 0
						if 20 < data.savedata["hp"] and data.savedata["hp"] < 30:
							HPmod = 1
						if 30 <= data.savedata["hp"] and data.savedata["hp"] < 40:
							HPmod = 2
						if 40 <= data.savedata["hp"] and data.savedata["hp"] < 50:
							HPmod = 3
						if 50 <= data.savedata["hp"] and data.savedata["hp"] < 60:
							HPmod = 4
						if 60 <= data.savedata["hp"] and data.savedata["hp"] < 70:
							HPmod = 5
						if 70 <= data.savedata["hp"] and data.savedata["hp"] < 80:
							HPmod = 6
						if 80 <= data.savedata["hp"] and data.savedata["hp"] < 90:
							HPmod = 7
						if 90 <= data.savedata["hp"]:
							HPmod = 8
						battleHandler._hurt(round((data.battledata[battleHandler.battleId]["atk"]) + HPmod - ((data.savedata["def"]+data.items[data.savedata["armor"]]["value"]) / 5)))
					"attack2":
						if dir != Vector2.ZERO:
							return
						var HPmod : int
						if data.savedata["hp"] and data.savedata["hp"] <= 20:
							HPmod = 0
						if 20 < data.savedata["hp"] and data.savedata["hp"] < 30:
							HPmod = 1
						if 30 <= data.savedata["hp"] and data.savedata["hp"] < 40:
							HPmod = 2
						if 40 <= data.savedata["hp"] and data.savedata["hp"] < 50:
							HPmod = 3
						if 50 <= data.savedata["hp"] and data.savedata["hp"] < 60:
							HPmod = 4
						if 60 <= data.savedata["hp"] and data.savedata["hp"] < 70:
							HPmod = 5
						if 70 <= data.savedata["hp"] and data.savedata["hp"] < 80:
							HPmod = 6
						if 80 <= data.savedata["hp"] and data.savedata["hp"] < 90:
							HPmod = 7
						if 90 <= data.savedata["hp"]:
							HPmod = 8
						battleHandler._hurt(round((data.battledata[battleHandler.battleId]["atk"]) + HPmod - ((data.savedata["def"]+data.items[data.savedata["armor"]]["value"]) / 5)))
					"attack3":
						battleHandler._heal(1)
	else:
		$CollisionShape2D.disabled = true
