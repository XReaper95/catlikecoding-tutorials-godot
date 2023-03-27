extends Node3D

@export_range(10, 100) var resolution: int = 50: set =_set_resolution

@export var _function_library: FunctionLibrary

@onready var disabled = false

@onready var _Point: PackedScene = preload("res://point.tscn")
@onready var _step := 2.0 / resolution
@onready var _scale := Vector3.ONE * _step
@onready var _points: Array[CSGBox3D] = []
@onready var _function := _function_library.get_function()

# transition
@onready var _from_func: Callable
@onready var _to_func: Callable
@onready var _duration := 0.0
@onready var _transition_duration := 1.0
@onready var _is_transitioning := false

const MAX_RESOLUTION: int = 100

func _ready():
	for i in range(MAX_RESOLUTION ** 2):	
		var new_point := _Point.instantiate() as CSGBox3D
		new_point.scale = _scale
		_points.append(new_point)
		add_child(new_point)
	
	_set_resolution(MAX_RESOLUTION)

func _process(_delta: float):
	if _is_transitioning:
		_duration += _delta
		
	if _is_transitioning and _duration >= _transition_duration:
		_duration = 0.0
		_function = _to_func
		_is_transitioning = false
	
	if _is_transitioning:
		_process_transition()
	else:
		_regular_process()


func _regular_process():
	var elapsed_time = Time.get_ticks_msec() / 1000.0
	var x := 0
	var z := 0
	var v = (z + 0.5) * _step - 1.0
	
	for i in range(_points.size()):
		if x == resolution:
			x = 0
			z += 1
			v = (z + 0.5) * _step - 1.0
		
		x = i % resolution + 1
		
		var u = (x + 0.5) * _step - 1.0
		
		_points[i].position = (
			_function.call(u, v, elapsed_time)
		)
	

func _process_transition():
	var elapsed_time := Time.get_ticks_msec() / 1000.0
	var x := 0
	var z := 0
	var v = (z + 0.5) * _step - 1.0
	var progress := _duration / _transition_duration
	
	for i in range(_points.size()):
		if x == resolution:
			x = 0
			z += 1
			v = (z + 0.5) * _step - 1.0
		
		x = i % resolution + 1
		
		var u = (x + 0.5) * _step - 1.0
		
		_points[i].position = (
			_function_library.morph(
				u, v, elapsed_time, _from_func, _to_func, progress
			)
		)


func _set_resolution(res: int):
	_step = 2.0 / res
	_scale = Vector3.ONE * _step
	
	for point in _points.slice(0, res):
		point.scale = _scale
	
	resolution = res


func _on_ui_resolution_changed(value: int):
	resolution = value


func _on_ui_function_selected():
	_from_func = _function
	_to_func = _function_library.get_function()
	_is_transitioning = true
