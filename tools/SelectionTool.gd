extends DefaultTool

var isPressedLeft:bool = false
var directionLeft: Vector2 = Vector2.ZERO


func _ready() -> void:
	._ready()
	isActive = false

func start(pos:Vector2) -> void:
	posStart = pos
	directionLeft = pos

func expand(pos:Vector2) -> void:
	startRect = Global.fix_rect(posStart, pos)
	rect = startRect
	canvas.change_selection(startRect)
	imageBuffer = canvas.image.get_rect(startRect)

func moveManhattan(dir: Vector2) -> void:
	rect.position += dir
	canvas.change_selection(rect)


func move(pos:Vector2) -> void:
	var displace = pos-directionLeft
	rect.position += displace
	directionLeft += displace
	canvas.change_selection(rect)

func end() -> void:
	startRect = rect
	update()

func clear() -> void:
	rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	canvas.change_selection(rect)

func apply() -> void:
	canvas.image.fill_rect(startRect, Color(1,1,1,0))
	canvas.image.blit_rect_mask(imageBuffer,imageBuffer,Rect2(Vector2.ZERO,canvas.image.get_size()), rect.position)
	canvas.update()

func _input(event: InputEvent) -> void:
	if !isActive:
		return
	if event is InputEventMouseMotion and event.relative and (isPressed or isPressedLeft):
		isMouseMoving = true
		return

func checkInput() -> void:
	if not canvas or not isActive:
		return

	### RIGHT BUTTON ###
	if Input.is_action_just_pressed("right_click"):
		isPressed = true
		apply()
		start(canvas.mouse_coordinates())

	if Input.is_action_just_released("right_click"):
		isPressed = false
		end()
	
	### LEFT BUTTON ###
	if Input.is_action_just_pressed("left_click"):
		isPressedLeft = true
		
		var coord = canvas.mouse_coordinates()
		if !rect.has_point(coord):
			start(coord)
			expand(coord)
			end()
		else:
			directionLeft = coord

	if Input.is_action_just_released("left_click"):
		isPressedLeft = false
		var coord = canvas.mouse_coordinates()
		apply()
		end()
	
	### ARROWS ###
	var dir: Vector2
	dir.x = int(Input.is_action_just_pressed("ui_right"))-int(Input.is_action_just_pressed("ui_left"))
	dir.y = int(Input.is_action_just_pressed("ui_down"))-int(Input.is_action_just_pressed("ui_up"))
	
	if dir != Vector2.ZERO:
		moveManhattan(dir)
	
	### MOUSE MOVEMENT ###
	if isMouseMoving:
		if isPressed:
			### RIGHT BUTTON MOVED ###
			expand(canvas.mouse_coordinates())
		elif isPressedLeft:
			### LEFT BUTTON MOVED ###
			move(canvas.mouse_coordinates())
		isMouseMoving = false
