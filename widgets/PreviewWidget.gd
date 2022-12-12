extends Control

onready var previewCanvas: TextureRect = $PreviewCanvas

var textureMap: ImageTexture = null
var frames = []
var currentFrameNumber: int = 0
var currentFrame: Image = Image.new()
var currentTexture: ImageTexture = ImageTexture.new()


func update_texture(imgText: ImageTexture) -> void:
	textureMap = imgText
	previewCanvas.get_material().set_shader_param("textureMap", textureMap)

func _changeFrame(num: int) -> void:
	currentFrameNumber = num
	currentFrame.copy_from(frames[num])
	
	
	currentTexture.create_from_image(currentFrame,3)
	previewCanvas.set_texture(currentTexture)

	$Timer.start(0.2)

func reset() -> void:
	_changeFrame(0)

func _on_Timer_timeout() -> void:
	var num = (currentFrameNumber+1)%frames.size()
	_changeFrame(num)
