extends BaseView

var timer = 0.0

func on_opening(_args):
	timer = 0.0
	
func process(delta):
	var tmp = timer
	timer += delta
	if int(tmp) != int(timer):
		Sound.play("Beep")
	$Center/Label.text = "%04.2f" % timer
	
	if Input.is_action_just_pressed("ui_cancel"):
		View.close("ExampleView")
