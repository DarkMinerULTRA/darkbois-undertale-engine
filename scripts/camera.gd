extends Camera2D

@export var OBJECT_TO_FOLLOW : Node2D
@export var bias = 1
@export_group("Camera Bounds (Optional)")
@export var active = true
@export var clamp_1 : Vector2 = Vector2(0,0)
@export var clamp_2 : Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	position = OBJECT_TO_FOLLOW.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	playerVariables.camPosition = position
	if OBJECT_TO_FOLLOW:
		var targetPos = OBJECT_TO_FOLLOW.position
		if active:
			targetPos = targetPos.clamp(clamp_1+Vector2(160,120),clamp_2+Vector2(160,120))
		position = lerp(position,targetPos,1)
