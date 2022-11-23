extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DuplicateTool.canvas = $AnimationWidget.canvas
	
	yield(get_tree(), "idle_frame")
	
	$AnimationWidget.update_texture($TextureWidget.canvas.imageTexture)


func _on_TextureWidget_frame_changed(texture) -> void:
	$AnimationViewport/Viewport/AnimationCanvas.update_texture(texture)
