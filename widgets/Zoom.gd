extends Control

var camera: Camera2D = null


func _on_Up_pressed() -> void:
	if camera:
		camera.offset.y -= 10


func _on_Down_pressed() -> void:
	if camera:
		camera.offset.y += 10


func _on_Left_pressed() -> void:
	if camera:
		camera.offset.x -= 10


func _on_Right_pressed() -> void:
	if camera:
		camera.offset.x += 10


func _on_In_pressed() -> void:
	if camera:
		camera.zoom -= Vector2.ONE * 0.1


func _on_Out_pressed() -> void:
	if camera:
		camera.zoom += Vector2.ONE * 0.1
