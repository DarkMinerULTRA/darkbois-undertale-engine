extends Sprite2D
class_name DustedEnemy

var started : bool = false

var pixel_color : Array = [] #Properties for dust particles
var dust_finished : bool = false
var ylevel : float = 0
var timer : float = 0
var selected_texture : Texture2D = null
var image_width : float = 0
var image_height : float = 0

@onready var particle = $GPUParticles2D

var dust_speed = 0.5

signal done

func _ready():
	battleHandler.endBattle.connect(_BattleEnd)
	
func _BattleEnd(end):
	if end == 1:
		Start()

func Start():
	image_height = texture.get_height()
	image_width = texture.get_width()
	particle.process_material.set("shader_param/sprite", texture)
	var emission_box_entents = particle.process_material.get("shader_parameter/emission_box_extents")
	emission_box_entents[0] = image_width / 2
	particle.process_material.set("shader_parameter/emission_box_extents",emission_box_entents)
	particle.emitting = true

func _process(delta):
	if ylevel < image_height:
		ylevel += (image_height * delta * dust_speed)*2
		particle.position.y = int(ylevel) - (image_height / 2)
		particle.process_material.set("shader_parameter/scrolly",(1.0/image_height)*int(ylevel))
		self.material.set("shader_parameter/sensitivity",(1.0/image_height)*int(ylevel))
	elif started:
		particle.emitting = false
		await get_tree().create_timer(50).timeout
		queue_free()
