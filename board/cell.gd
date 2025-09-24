extends Node2D
class_name Cell


@onready var button: TextureButton = $Button
@onready var number_sprite: Sprite2D = $Button/Number
@onready var mouse_area: Area2D = $MouseArea

var x: int
var y: int
var is_mine: bool = false
var is_flagged: bool = false
var is_flipped: bool = false
var number: int = 0
var neighbors: Array

var mouse_inside: bool = false
static var left_mouse_down: bool = false
static var right_mouse_down: bool = false

signal cell_left_clicked(cell: Cell)
signal cell_right_clicked(cell: Cell)


static func is_flagged_or_is_flipped_mine(cell: Cell):
	return cell.is_flagged or (cell.is_flipped and cell.is_mine)

static func is_not_flipped_and_is_not_flagged(cell: Cell):
	return not cell.is_flipped and not cell.is_flagged


func _ready():
	mouse_area.input_event.connect(_on_input_event)
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not (is_flipped and (left_mouse_down or right_mouse_down)) and mouse_inside and event is InputEventMouseMotion:
		var local_pos = event.global_position - button.global_position
		button.material.set_shader_parameter("mouse_position", local_pos)
	elif Input.is_action_just_pressed("mouse_left"):
		_on_left_button_down()
	elif Input.is_action_just_pressed("mouse_right"):
		_on_right_button_down()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_released("mouse_left"):
		_on_left_mouse_up()
	if Input.is_action_just_released("mouse_right"):
		_on_right_mouse_up()

func _on_left_button_down():
	left_mouse_down = true
	if is_flagged:
		return
	button.set_pressed_no_signal(true)
	if is_flipped:
		button.material.set_shader_parameter("mouse_position", Vector2.ZERO)
		button.scale *= 0.9

func _on_left_mouse_up():
	left_mouse_down = false
	button.scale = Vector2.ONE
	if mouse_inside:
		cell_left_clicked.emit(self)

func _on_right_button_down():
	right_mouse_down = true
	if not is_flipped:
		#material.set_shader_parameter("mouse_position", Vector2.ZERO)
		button.scale *= 0.9

func _on_right_mouse_up():
	right_mouse_down = false
	button.scale = Vector2.ONE
	if mouse_inside:
		cell_right_clicked.emit(self)

func _on_mouse_entered():
	mouse_inside = true
	z_index = 5
	if left_mouse_down:
		if is_flipped:
			button.scale *= 0.9
		if not is_flagged:
			button.set_pressed_no_signal(true)
	if right_mouse_down:
		if not is_flipped:
			button.scale *= 0.9
		

func _on_mouse_exited():
	mouse_inside = false
	z_index = 0
	if not is_flipped:
		button.set_pressed_no_signal(false)
	button.material.set_shader_parameter("mouse_position", Vector2.ZERO)
	button.scale = Vector2.ONE
