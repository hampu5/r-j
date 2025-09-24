extends Node2D


func _ready():
	var board = Board.create(9, 9, 16)
	board.position = Vector2i(320/2, 180/2)
	add_child(board)
	board.owner = self
