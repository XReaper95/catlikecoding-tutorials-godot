extends Control

signal resolution_changed(value: int)
signal function_selected()

@export var _function_library: FunctionLibrary
@onready var _function_picker: OptionButton = $"FunctionPicker/PanelContainer/HBoxContainer/MarginContainer/OptionButton"
@onready var _resolution_slider: HSlider = $"FunctionPicker/PanelContainer/HBoxContainer/MarginContainer2/HBoxContainer/HSlider"
@onready var _max_resolution_label: Label = $"FunctionPicker/PanelContainer/HBoxContainer/MarginContainer2/HBoxContainer/ResMaxLabel"
@onready var _fps_label: Label = $"FunctionPicker/PanelContainer/HBoxContainer/MarginContainer3/Label"
@onready var _fps_radiob: CheckBox = $FunctionPicker/PanelContainer/HBoxContainer/MarginContainer4/HBoxContainer/CheckBox
@onready var _ms_radiob: CheckBox = $FunctionPicker/PanelContainer/HBoxContainer/MarginContainer4/HBoxContainer/CheckBox2
@onready var _best_fps: int = 0
@onready var _worst_fps: int = 10000

func _ready():
	_populate_func_picker()
	
	_function_picker.item_selected.connect(
		_on_option_button_item_selected
	)
	
	_resolution_slider.value_changed.connect(
		_on_resolution_slider_value_changed
	)

func _process(_delta):
	var current_fps = Engine.get_frames_per_second()
	_best_fps = max(_best_fps, current_fps)
	_worst_fps = min(_worst_fps, current_fps)
	
	if _fps_radiob.button_pressed:
		_fps_label.text = "FPS: %s\nBEST: %s\nWORST: %s" % [
			current_fps, _best_fps, _worst_fps
		]
	else:
		_fps_label.text = "MS: %s\nBEST: %s\nWORST: %s" % [
			1.0 / current_fps, 1.0 / _best_fps, 1.0 / _worst_fps
		]


func _populate_func_picker():
		# clear function picker tests items
	_function_picker.clear()
	for function_name in _function_library.Function:
		_function_picker.add_item(function_name)
	
	_function_picker.select(_function_library.function)


func _on_option_button_item_selected(index: int):
	_function_library.set_function_from_index(index)
	function_selected.emit()


func _on_resolution_slider_value_changed(value: int):
	_max_resolution_label.text = str(value)
	resolution_changed.emit(value)
