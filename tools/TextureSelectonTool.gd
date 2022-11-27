extends Tool

var targetCanvas: DefaultCanvas

var isPressedLeft:bool = false
var directionLeft: Vector2 = Vector2.ZERO

var targetPosStart: Vector2
var targetImageBuffer: Image

onready var selectionWindow: SelectionWindow = $SelectionWindow

func _translate(source: Image, sourceRect: Rect2) -> Image:
	var sourceSize = canvas.image.get_size()
	var sourceRectSize = sourceRect.size
	var sourceRectPos = sourceRect.position
	var translatedImage = Image.new()
	var newU: float
	var newV: float
	translatedImage.copy_from(source)
	
	translatedImage.lock()
	
	for u in range(sourceRectSize.x):
		for v in range(sourceRectSize.y):
			newU = (u+sourceRectPos.x+0.5)/sourceSize.x
			newV = (v+sourceRectPos.y+0.5)/sourceSize.y
			translatedImage.set_pixel(u, v, Color(newU, newV, 0, 1) )
	translatedImage.unlock()
	return translatedImage

func _ready() -> void:
	._ready()
	isActive = true

func start(pos:Vector2) -> void:
	print("start ", pos)
	posStart = pos

func startTarget(pos:Vector2) -> void:
	print("target ", pos)
	targetPosStart = pos
	directionLeft = pos

func expand(pos:Vector2) -> void:
	startRect = Global.fix_rect(posStart, pos)
	canvas.change_selection(startRect)
	imageBuffer = canvas.image.get_rect(startRect)

func expandTarget(pos: Vector2) -> void:
	#rect = Global.fix_rect(targetPosStart, pos)
	pass

func move(pos:Vector2) -> void:
	var displace = pos-directionLeft
	rect.position += displace
	directionLeft += displace

func end() -> void:
	rect = startRect
	rect.position = targetPosStart
	targetImageBuffer = _translate(imageBuffer, startRect)
	update()

func clear() -> void:
	rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	startRect = Rect2(Vector2.ZERO, Vector2.ZERO)
	
	canvas.change_selection(rect)

func apply() -> void:
	if rect.position.x >= 0.0 and rect.position.y >= 0.0:
		
		print("applied ", rect.position, rect.size)
		targetCanvas.image.blend_rect(targetImageBuffer,Rect2(Vector2.ZERO,targetCanvas.image.get_size()), rect.position)
		targetCanvas.update()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if isPressed:
			### RIGHT BUTTON MOVED ###
			expand(canvas.mouse_coordinates())
			#expandTarget(targetCanvas.mouse_coordinates())
		elif isPressedLeft:
			### LEFT BUTTON MOVED ###
			move(targetCanvas.mouse_coordinates())
	

func checkInput() -> void:
	if canvas and targetCanvas and isActive:
		### RIGHT BUTTON ###
		if Input.is_action_just_pressed("right_click"):
			print("right_click pressed")
			var coord = canvas.mouse_coordinates()
			if coord.x in range(canvas.get_size().x) and coord.y in range(canvas.get_size().y):
				isPressed = true
				apply()
				start(coord)
				
				var otherCoord = targetCanvas.mouse_coordinates()
				startTarget(otherCoord)
	
		if Input.is_action_just_released("right_click") and isPressed:
			isPressed = false
			end()
		
		### LEFT BUTTON ###
		if Input.is_action_just_pressed("left_click"):
			var coord = canvas.mouse_coordinates()
			
			isPressedLeft = true
			if !startRect.has_point(coord):
				
				if coord.x in range(canvas.get_size().x) and coord.y in range(canvas.get_size().y):
					apply()
					start(coord)
					var otherCoord = targetCanvas.mouse_coordinates()
					startTarget(otherCoord)
					expand(coord)
					end()
			else:
				var otherCoord = targetCanvas.mouse_coordinates()
				startTarget(otherCoord)
				end()
	
		if Input.is_action_just_released("left_click"):
			print("left_click released")
			isPressedLeft = false
			var otherCoord = targetCanvas.mouse_coordinates()
			move(otherCoord)
			if otherCoord.x in range(targetCanvas.get_size().x) and otherCoord.y in range(targetCanvas.get_size().y):
				apply()
		
