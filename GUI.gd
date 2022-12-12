extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$DuplicateTool.canvas = $AnimationWidget.canvas
	#$TextureSelectonTool.canvas = $TextureWidget.canvas
	$ToolbarWidget.update_animation_canvas($AnimationWidget.canvas)
	$ToolbarWidget.update_texture_canvas($TextureWidget.canvas)
	
	$NavbarWidget.textureCanvas = $TextureWidget
	$NavbarWidget.animationCanvas = $AnimationWidget
	$NavbarWidget.previewCanvas = $PreviewWidget
	
	yield(get_tree(), "idle_frame")
	
	$AnimationWidget.update_texture($TextureWidget.canvas.imageTexture)
	
	$PreviewWidget.update_texture($TextureWidget.canvas.imageTexture)
	$PreviewWidget.visible = true
	_sync_preview_animation()

func _sync_preview_animation()->void:
	$PreviewWidget.frames = $AnimationWidget.canvas.frames
	$PreviewWidget.reset()

func _on_TextureWidget_frame_changed(texture) -> void:
	$AnimationViewport/Viewport/AnimationCanvas.update_texture(texture)
	$PreviewWidget.update_texture($TextureWidget.canvas.imageTexture)


func _on_AnimationWidget_frame_number_modified() -> void:
	_sync_preview_animation()
