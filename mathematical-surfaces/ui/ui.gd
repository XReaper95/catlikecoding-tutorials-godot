extends Control

@export var _function_library: FunctionLibrary

@onready var _function_picker: OptionButton = $"FunctionPicker/PanelContainer/HBoxContainer/MarginContainer/OptionButton"

func _ready():
	_populate_func_picker()
	
	_function_picker.item_selected.connect(
		_on_option_button_item_selected
	)

func _populate_func_picker():
		# clear function picker tests items
	_function_picker.clear()
	for function_name in _function_library.Function:
		_function_picker.add_item(function_name)
	
	_function_picker.select(_function_library.function)


func _on_option_button_item_selected(index: int):
	_function_library.set_function_from_index(index)
