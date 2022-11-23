extends Control

signal frame_changed(texture)

onready var canvas: DefaultCanvas = $"%TextureCanvas"


func _ready() -> void:
	pass # Replace with function body.



func _on_TextureCanvas_frame_changed() -> void:
	emit_signal("frame_change", canvas.imageTexture)


func _on_Frame1_pressed() -> void:	
	canvas.change_frame(1)


func _on_Frame2_pressed() -> void:
	canvas.change_frame(2)


func _on_Frame3_pressed() -> void:
	canvas.change_frame(3)
