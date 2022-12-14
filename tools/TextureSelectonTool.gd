extends DefaultTool

var targetCanvas: DefaultCanvas

var isPressedLeft:bool = false
var directionLeft: Vector2 = Vector2.ZERO

var targetPosStart: Vector2
var targetImageBuffer: Image


func _translate(source: Image, sourceRect: Rect2) -> Image:
	var sourceSize = canvas.image.get_size()
	var sourceRectSize = sourceRect.size
	var sourceRectPos = sourceRect.position
	var translatedImage = Image.new()
	var newU: float
	var newV: float
	translatedImage.copy_from(source)
	translatedImage.fill(Color.transparent)
	translatedImage.lock()
	
	for u in range(sourceRectSize.x):
		for v in range(sourceRectSize.y):
			newU = (u+sourceRectPos.x+1)/sourceSize.x
			newV = (v+sourceRectPos.y+1)/sourceSize.y
			translatedImage.set_pixel(u, v, Color(newU, newV, 0, 1) )
	translatedImage.unlock()
	return translatedImage

func _ready() -> void:
	._ready()
	isActive = false
	isUnique = true

func start(pos:Vector2) -> void:
	posStart = pos

func startTarget(pos:Vector2) -> void:
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
	targetCanvas.change_selection(rect)
	

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
		
		targetCanvas.image.blend_rect_mask(targetImageBuffer,targetImageBuffer,Rect2(Vector2.ZERO,targetCanvas.image.get_size()), rect.position)
		targetCanvas.update()

func save() -> void:
	var imageTemp = Image.new()
	imageTemp.copy_from(targetCanvas.image)
	
	previousImages.push_front(imageTemp)
	
	while previousImages.size() > Global.MAX_IMAGE_BUFFER:
		imageTemp = previousImages.pop_back()

func loadImage() -> void:
	targetCanvas.image.copy_from(previousImages[0])
	targetCanvas.update()

func _input(event: InputEvent) -> void:
	if !isActive:
		return
	if event is InputEventMouseMotion and event.relative and (isPressed or isPressedLeft):
		isMouseMoving = true
		return

func checkInputTexture(coord:Vector2, otherCoord:Vector2) -> void:
	### RIGHT BUTTON ###
	if Input.is_action_just_pressed("right_click"):
		isPressed = true
		start(coord)
		startTarget(otherCoord)

	if Input.is_action_just_released("right_click") and isPressed:
		isPressed = false
		end()
	
	if Input.is_action_just_pressed("left_click"):
		isPressedLeft = true
		
		if !startRect.has_point(coord):
			start(coord)
			startTarget(otherCoord)
			expand(coord)
			end()
		else:
			directionLeft = otherCoord

func checkInputAnimation(coord:Vector2, otherCoord:Vector2) -> void:
	### LEFT BUTTON ###
	if Input.is_action_just_pressed("left_click"):
		isPressedLeft = true
		
		directionLeft = targetPosStart
		rect.position = targetPosStart
		
		move(otherCoord)
		print("pressed: ", targetPosStart, directionLeft)

	if Input.is_action_just_released("left_click"):
		
		print("released: ", targetPosStart, directionLeft)
		
		
		isPressedLeft = false
		move(otherCoord)
		
		apply()
		save()

func checkInput() -> void:
	if not canvas or not isActive:
		return
		
	if Input.is_action_just_pressed("undo"):
		.undo()


	var coord = canvas.mouse_coordinates()
	var otherCoord = targetCanvas.mouse_coordinates()
		
	### MOUSE MOVEMENT ###
	if isMouseMoving:
		if isPressed:
			### RIGHT BUTTON MOVED ###
			expand(canvas.mouse_coordinates())
		elif isPressedLeft:
			### LEFT BUTTON MOVED ###
			move(targetCanvas.mouse_coordinates())
		isMouseMoving = false

	if coord.x in range(canvas.get_size().x) and coord.y in range(canvas.get_size().y):
		checkInputTexture(coord, otherCoord)
	
	if otherCoord.x in range(targetCanvas.get_size().x) and otherCoord.y in range(targetCanvas.get_size().y):
		checkInputAnimation(coord, otherCoord)

	
	
