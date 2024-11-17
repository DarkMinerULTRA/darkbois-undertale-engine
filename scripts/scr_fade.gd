extends CanvasLayer

func fadeIn(time : float):
	$fade.color.a = 1
	var tween = create_tween()
	tween.tween_property($fade,"color:a",0.0,time)

func fadeOut(time : float):
	$fade.color.a = 0
	var tween = create_tween()
	tween.tween_property($fade,"color:a",1.0,time)

func setFade(fade : float):
	$fade.color.a = fade
