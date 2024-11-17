extends Node2D

var timer = 0
var timer2 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(4).timeout
	flip()
	await get_tree().create_timer(4).timeout
	sway()
	await get_tree().create_timer(12).timeout
	sway2()
	await get_tree().create_timer(8).timeout
	spin()

func flip():
	$dog.scale.x = $dog.scale.x*-1
	await $dog.frame_changed
	await $dog.frame_changed
	flip()

func sway():
	timer += 1
	$dog.position.x = 160+(sin(timer/2)*10)
	await get_tree().process_frame
	sway()
func sway2():
	timer2 += 1
	$dog.position.y = 120+(sin(timer2/2)*10)
	await get_tree().process_frame
	sway2()

func spin():
	$dog.rotation_degrees += 1
	await get_tree().process_frame
	spin()
