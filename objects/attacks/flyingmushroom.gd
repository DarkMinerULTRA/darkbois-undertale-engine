extends Node2D

var velocity1 = Vector2.ZERO

func _ready():
	$Attack.attackType = randi_range(0,2)
	get_tree().create_timer(5).timeout.connect(attackEnd)
	get_tree().create_timer(0.35).timeout.connect(spin)
	while true:
		if playerVariables.soulPos.x > $Attack.position.x+position.x:
			velocity1.x = lerp(velocity1.x,2.0,0.05)
		elif playerVariables.soulPos.x < $Attack.position.x+position.x:
			velocity1.x = lerp(velocity1.x,-2.0,0.05)
		if playerVariables.soulPos.y > $Attack.position.y+position.y:
			velocity1.y = lerp(velocity1.y,2.0,0.05)
		elif playerVariables.soulPos.y < $Attack.position.y+position.y:
			velocity1.y = lerp(velocity1.y,-2.0,0.05)
		$Attack.position += velocity1
		await get_tree().process_frame

func attackEnd():
	queue_free()

func spin():
	$Attack.rotation_degrees += 90
	get_tree().create_timer(0.35).timeout.connect(spin)
