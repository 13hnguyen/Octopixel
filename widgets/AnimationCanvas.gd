extends DefaultCanvas

var textureMap: ImageTexture

func update_texture(imgText: ImageTexture) -> void:
	textureMap = imgText
	canvas.get_material().set_shader_param("textureMap", textureMap)

