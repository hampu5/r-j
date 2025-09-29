class_name Cell extends Area2D


@onready var button: MyButton = $MyButton
@onready var number_sprite: Sprite2D = $Number

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
	button.clicked.connect(_on_clicked)

func _on_clicked() -> void:
	button.disabled = true
