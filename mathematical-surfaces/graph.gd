extends Node3D

@export_range(10, 100) var resolution: int = 10
@export var _function_library: FunctionLibrary

@onready var _Point: PackedScene = preload("res://point.tscn")
@onready var _step := 2.0 / resolution
@onready var _scale := Vector3.ONE * _step
@onready var _points: Array[CSGBox3D] = []


func _ready():
	var pos = Vector3.ZERO
	var x := 0
	var z := 0
	
	for i in range(resolution * resolution):
		if x == resolution:
			x = 0
			z += 1
		
		x = i % resolution + 1
		
		var new_point := _Point.instantiate() as CSGBox3D
		_points.append(new_point)
		
		pos.x = (x + 0.5) * _step - 1.0
		pos.z = (z + 0.5) * _step - 1.0
		new_point.position = pos
		new_point.scale = _scale
		
		add_child(new_point)


func _process(_delta):
	var elapsed_time = Time.get_ticks_msec() / 1000.0
	for point in _points:
		point.position.y = (
			_function_library
				.get_function()
				.call(point.position.x, point.position.z, elapsed_time)
		)
