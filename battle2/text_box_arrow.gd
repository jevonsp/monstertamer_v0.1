extends Node2D


func still():
	$Blinking.visible = false
	$Blinking.stop()
	$Still.visible = true
	
func blinking():
	$Still.visible = false
	$Blinking.play()
	$Blinking.visible = true
	
	
