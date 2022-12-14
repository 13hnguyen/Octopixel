extends Control

class_name DefaultTool

onready var buffer: TextureRect = $Buffer

var viewport: Viewport
var canvas: DefaultCanvas

var imageBuffer: Image
var textureBuffer: ImageTexture
var rect: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)
var startRect:  Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)
var posStart: Vector2
var posEnd: Vector2

var isActive: bool = false
var isPressed: bool = false
var isMouseMoving: bool = false

var isUnique: bool = false

var previousImages: Array = []

func _ready() -> void:
	viewport = get_viewport()
	imageBuffer = Image.new()
	textureBuffer = ImageTexture.new()

func _physics_process(delta: float) -> void:
	checkInput()

func _draw() -> void:
	textureBuffer.create_from_image(imageBuffer,3)
	buffer.set_texture(textureBuffer)
	buffer.rect_size = imageBuffer.get_size()
	buffer.rect_scale = Vector2.ONE * 50

func unselect() -> void:
	isActive = false
	isPressed = false
	clear()

func clear() -> void:
	rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	startRect = Rect2(Vector2.ZERO, Vector2.ZERO)

func select() -> void:
	isActive = true

func save() -> void:
	var imageTemp = Image.new()
	imageTemp.copy_from(canvas.image)
	
	previousImages.push_front(imageTemp)
	
	while previousImages.size() > Global.MAX_IMAGE_BUFFER:
		imageTemp = previousImages.pop_back()

func undo() -> void:
	if previousImages.size() < 2:
		clear()
		return
	var imageTemp = previousImages.pop_front()
	loadImage()
	clear()

func loadImage() -> void:
	canvas.image.copy_from(previousImages[0])
	canvas.update()

func start(pos: Vector2) -> void:
	pass

func end() -> void:
	pass

func apply() -> void:
	pass

func checkInput() -> void:
	pass
