extends Control

signal resolution_changed(value: float)

@export var _function_library: FunctionLibrary
@onready var _function_picker: OptionButton = $"FunctionPicker/PanelContainer/HBoxContainer/MarginContainer/OptionButton"
@onready var _resolution_slider: HSlider = $"FunctionPicker/PanelContainer/HBoxContainer/MarginContainer2/HBoxContainer/HSlider"
@onready var _max_resolution_label: Label = $"FunctionPicker/PanelContainer/HBoxContainer/MarginContainer2/HBoxContainer/ResMaxLabel"

func _ready():
	_populate_func_picker()
	
	_function_picker.item_selected.connect(
		_on_option_button_item_selected
	)
	
	_resolution_slider.value_changed.connect(
		_on_resolution_slider_value_changed
	)

func _populate_func_picker():
		# clear function picker tests items
	_function_picker.clear()
	for function_name in _function_library.Function:
		_function_picker.add_item(function_name)
	
	_function_picker.select(_function_library.function)


func _on_option_button_item_selected(index: int):
	_function_library.set_function_from_index(index)


func _on_resolution_slider_value_changed(value: float):
	_max_resolution_label.text = str(value)
	resolution_changed.emit(value)
