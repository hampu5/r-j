extends RefCounted
class_name Set


var arr: Array


func append(element):
	if element not in arr:
		arr.append(element)

func append_array(element_arr: Array):
	for element in element_arr:
		append(element)

func has(element):
	return element in arr

func get_e(index: int):
	return arr[index]

func is_empty():
	return arr.is_empty()

func pop_front():
	return arr.pop_front()

func size():
	return arr.size()

func clear():
	arr.clear()
