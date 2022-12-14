extends Control

var textureCanvas: Control
var animationCanvas: Control
var previewCanvas: Control

func _on_New_pressed() -> void:
	$CanvasSize.visible = true

func _on_CanvasSize_set_size(textureSize, animationSize) -> void:
	textureCanvas.clear(textureSize)
	animationCanvas.clear(animationSize)
	
	previewCanvas.frames = animationCanvas.canvas.frames
	previewCanvas.reset()
