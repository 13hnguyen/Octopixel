extends DefaultTool

onready var colorPicker: ColorPicker

var isPressedLeft:bool = false
var directionLeft: Vector2 = Vector2.ZERO
var chosenColor: Color = Color.transparent

func _ready() -> void:
	._ready()
	isActive = false

func select() -> void:
	.select()
	colorPicker.visible = true
	colorPicker.connect("color_changed",self,"_on_ColorPicker_color_changed")

func unselect() -> void:
	.unselect()
	colorPicker.visible = false


func start(pos:Vector2) -> void:
	posStart = pos
	directionLeft = pos

func expand(pos:Vector2) -> void:
	startRect = Global.fix_rect(posStart, pos)
	rect = startRect
	canvas.change_selection(startRect)
	imageBuffer = canvas.image.get_rect(startRect)

func moveManhattan(dir: Vector2) -> void:
	#rect.position += dir
	#canvas.change_selection(rect)
	pass


func move(pos:Vector2) -> void:
	var displace = pos-directionLeft
	rect.position += displace
	directionLeft += displace
	apply()
	canvas.change_selection(rect)

func end() -> void:
	startRect = rect
	update()

func clear() -> void:
	rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	canvas.change_selection(rect)

func apply() -> void:
	canvas.image.fill_rect(rect, chosenColor)
	#canvas.image.blend_rect(imageBuffer,Rect2(Vector2.ZERO,canvas.image.get_size()), rect.position)
	canvas.update()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if isPressed:
			### RIGHT BUTTON MOVED ###
			expand(canvas.mouse_coordinates())
		elif isPressedLeft:
			### LEFT BUTTON MOVED ###
			move(canvas.mouse_coordinates())
	

func checkInput() -> void:
	if canvas and isActive:
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
				apply()
				start(coord)
				expand(coord)
				end()
	
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


func _on_ColorPicker_color_changed(color: Color) -> void:
	chosenColor = color
	print(chosenColor)
	
	
