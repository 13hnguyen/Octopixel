extends WindowDialog

signal set_size(textureSize, animationSize)

func _ready() -> void:
	visible = true



func _on_OKButton_pressed() -> void:
	var textureSize: Vector2
	
	textureSize.x = $VBoxContainer/HBoxTexture/VBoxContainer/HBoxWidth/Width.value
	textureSize.y = $VBoxContainer/HBoxTexture/VBoxContainer/HBoxHeight/Height.value

	var animationSize: Vector2
	
	animationSize.x = $VBoxContainer/HBoxAnimation/VBoxContainer/HBoxWidth/Width.value
	animationSize.y = $VBoxContainer/HBoxAnimation/VBoxContainer/HBoxHeight/Height.value

	emit_signal("set_size", textureSize, animationSize)
	
	visible = false
