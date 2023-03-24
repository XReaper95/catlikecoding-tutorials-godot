extends Node3D

@export_range(10, 100) var resolution: int = 10
@export var function_library: FunctionLibrary

@onready var _Point: PackedScene = preload("res://point.tscn")
@onready var _step := 2.0 / resolution
@onready var _scale := Vector3.ONE * _step
@onready var _points: Array[CSGBox3D] = []
@onready var _function: Callable


func _ready():
	var pos = Vector3.ZERO
	
	for i in range(resolution):
		var new_point := _Point.instantiate() as CSGBox3D
		_points.append(new_point)
		
		pos.x = (i + 0.5) * _step - 1.0
		new_point.position = pos
		new_point.scale = _scale
		
		add_child(new_point)


func _process(_delta):
	var elapsed_time = Time.get_ticks_msec() / 1000.0
	for point in _points:
		point.position.y = (
			function_library
				.get_function()
				.call(point.position.x, elapsed_time)
		)
