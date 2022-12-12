extends Node

var ZOOM_MIN:int = 1
var ZOOM_MAX:int = 500

func _ready() -> void:
	pass


func fix_rect(a: Vector2, b: Vector2) -> Rect2:
	var pos = Vector2(min(a.x, b.x), min(a.y, b.y)).floor()
	var size = Vector2(max(a.x, b.x)+1, max(a.y, b.y)+1).ceil()-pos
	return Rect2(pos, size)
	
