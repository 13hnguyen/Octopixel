extends Button

signal change_button(button_pressed, leftHand, isUnique, toolObject, button)

export var myToolPath:NodePath
export var isLeftHand: bool

var myTool: DefaultTool

func _ready() -> void:
	myTool = get_node(myToolPath)
	connect("pressed",self,"_button_clicked")


func _button_clicked() -> void:
	print("hi")
	emit_signal("change_button", true, isLeftHand, myTool.isUnique, myTool, self)



