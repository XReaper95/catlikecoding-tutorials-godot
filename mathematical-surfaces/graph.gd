extends Node3D

@export_range(10, 100) var resolution: int = 50: set =_set_resolution

@export var _function_library: FunctionLibrary

@onready var _Point: PackedScene = preload("res://point.tscn")
@onready var _step := 2.0 / resolution
@onready var _scale := Vector3.ONE * _step
@onready var _points: Array[CSGBox3D] = []

const MAX_RESOLUTION: int = 100

func _ready():
	for i in range(MAX_RESOLUTION ** 2):	
		var new_point := _Point.instantiate() as CSGBox3D
		new_point.scale = _scale
		_points.append(new_point)
		add_child(new_point)
	
	_set_resolution(MAX_RESOLUTION / 2)

func _process(_delta):
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
			_function_library
				.get_function()
				.call(u, v, elapsed_time)
		)

func _set_resolution(res: int):
	_step = 2.0 / res
	_scale = Vector3.ONE * _step
	
	for point in _points.slice(0, res):
		point.scale = _scale
	
	resolution = res


func _on_ui_resolution_changed(value: float):
	resolution = value
