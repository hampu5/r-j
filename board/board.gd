extends Node2D
class_name Board


var cell_scene: PackedScene = preload("res://board/cell_big.tscn")
var cell_down: Cell = null
var cell_current: Cell = null

var all_cells: Array[Cell]
var mine_cells: Array[Cell]

var width: int
var height: int
var mines: int

var board_instance: Array

var neighbors_3x3: Array[Vector2i] = [
	Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1),
	Vector2i(-1, 0),                 Vector2i(1, 0),
	Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)
]


static func create(width_p: int, height_p: int, mines_p: int) -> Board:
	var board: Board = preload("res://board/board.tscn").instantiate()
	board.width = width_p
	board.height = height_p
	board.mines = mines_p
	return board


func get_neighbors_from_board(cell: Cell) -> Array:
	return neighbors_3x3 \
		.filter(is_within_board.bind(cell)) \
		.map(to_neighbor.bind(cell))

func to_neighbor(cell_pos: Vector2i, cell: Cell) -> Cell:
	return board_instance[cell.x + cell_pos.x][cell.y + cell_pos.y]

func is_within_board(cell_pos: Vector2i, cell: Cell) -> bool:
	return not cell.x + cell_pos.x < 0 and not cell.x + cell_pos.x >= width \
		and not cell.y + cell_pos.y < 0 and not cell.y + cell_pos.y >= height

func set_number_sprite(cell: Cell):
	if cell.is_mine:
		cell.number_sprite.texture.region = Rect2i(16, 27, 5, 5)
		return
	cell.number_sprite.texture.region.position.x = ((cell.number - 1) * 5) % 25
	cell.number_sprite.texture.region.position.y = 32 + (5 if cell.number > 5 else 0)


func chord_cells(cell: Cell) -> void:
	if not cell.is_flipped:
		return
	var cells_to_flip_opening: Array
	var neighbors = cell.neighbors
	if neighbors.filter(Cell.is_flagged_or_is_flipped_mine).size() != cell.number: # Not correct number of mines + flags
		return
	var cells_to_be_chorded: Array = neighbors.filter(Cell.is_not_flipped_and_is_not_flagged)
	if cells_to_be_chorded.is_empty():
		return
	#board.chorded_cells += cells_to_be_chorded.size()
	for n: Cell in cells_to_be_chorded:
		if n.number == 0 and n not in cells_to_flip_opening:
			cells_to_flip_opening.append_array(get_opening_cells_to_flip(n).filter(func(c: Cell): return c not in cells_to_be_chorded))
	for c: Cell in cells_to_be_chorded:
		c.button.set_pressed_no_signal(true)
		_on_cell_left_clicked(c)

func get_opening_cells_to_flip(cell: Cell) -> Array:
	var cells_to_flip: Set = Set.new()
	var blank_cells: Set = Set.new()
	blank_cells.append(cell)
	while not blank_cells.is_empty():
		var blank_cell: Cell = blank_cells.pop_front()
		cells_to_flip.append(blank_cell)
		for n: Cell in blank_cell.neighbors.filter(Cell.is_not_flipped_and_is_not_flagged):
			if cells_to_flip.has(n):
				continue
			cells_to_flip.append(n)
			if n.number == 0:
				blank_cells.append(n)
	return cells_to_flip.arr


func _ready() -> void:
	for x in width:
		board_instance.append([])
		for y in height:
			var cell: Cell = cell_scene.instantiate()
			add_child(cell)
			cell.owner = self
			cell.x = x
			cell.y = y
			cell.position = Vector2i((10.0 + 0) * (x - width / 2), (10.0 + 0) * (y - height / 2))
			cell.cell_left_clicked.connect(_on_cell_left_clicked)
			cell.cell_right_clicked.connect(_on_cell_right_clicked)
			board_instance[x].append(cell)
			all_cells.append(cell)
	for c: Cell in all_cells:
		c.neighbors = get_neighbors_from_board(c)
	var all_cells_shuffled: Array[Cell] = all_cells.duplicate()
	all_cells_shuffled.shuffle()
	mine_cells = all_cells_shuffled.slice(-mines)
	for c: Cell in mine_cells:
		c.is_mine = true
		for n: Cell in c.neighbors:
			n.number += 1
	for c: Cell in all_cells:
		if c.is_mine:
			c.number_sprite.texture.region = Rect2i(16, 27, 5, 5)
			continue
		if c.number == 0:
			c.number_sprite.texture.region = Rect2i(16 + 5, 27, 5, 5)
			continue
		set_number_sprite(c)

func _on_cell_left_clicked(cell: Cell):
	if cell.is_flagged:
		return
	if cell.is_flipped:
		chord_cells(cell)
	cell.is_flipped = true
	cell.number_sprite.show()
	if cell.is_mine:
		pass
	elif cell.number == 0:
		for n: Cell in cell.neighbors:
			if n.is_mine or n.is_flipped or n.is_flagged:
				continue
			n.button.set_pressed_no_signal(true)
			_on_cell_left_clicked(n)

func _on_cell_right_clicked(cell: Cell):
	if cell.is_flipped:
		return
	if cell.is_flagged:
		cell.is_flagged = false
		cell.number_sprite.hide()
		set_number_sprite(cell)
		return
	cell.is_flagged = true
	cell.number_sprite.texture.region = Rect2i(16, 22, 5, 5)
	cell.number_sprite.show()
