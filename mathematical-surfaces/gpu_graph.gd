extends Node3D

@export_range(10, 100) var resolution: int = 50: set =_set_resolution

@export var _function_library: FunctionLibrary

@onready var disabled = false
@onready var _function := _function_library.get_function()

# transition
@onready var _from_func: Callable
@onready var _to_func: Callable
@onready var _duration := 0.0
@onready var _transition_duration := 1.0
@onready var _is_transitioning := false

const MAX_RESOLUTION: int = 100

func _ready():
	pass

func _process(_delta: float):
	if _is_transitioning:
		_duration += _delta
		
	if _is_transitioning and _duration >= _transition_duration:
		_duration = 0.0
		_function = _to_func
		_is_transitioning = false
	

func _set_resolution(res: int):
	pass


func _on_ui_resolution_changed(value: int):
	resolution = value


func _on_ui_function_selected():
	_from_func = _function
	_to_func = _function_library.get_function()
	_is_transitioning = true
