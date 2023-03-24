class_name FunctionLibrary
extends Resource

@export var function: Function = Function.Wave:
	set(value):
		_selected_function = _function_map.get(value)
		function = value


func get_function() -> Callable:
	return _selected_function


func set_function_from_index(index: int):
	_selected_function = _function_map.get(index)


var _selected_function: Callable
enum Function {
	Wave, MultiWave, Ripple
}
var _function_map = {
	Function.Wave: _wave_function,
	Function.MultiWave: _multi_wave_function,
	Function.Ripple: _ripple_function
}

### Functions ###
func _wave_function(x: float, z: float, t: float) -> float:
	return sin(PI * (x + z + t))


func _multi_wave_function(x: float, z: float, t: float) -> float:
	var wave = _wave_function(x, z, t)
	wave += 0.5 * sin(2.0 * PI * (z + t))
	wave += sin(PI * (x + z + 0.25 * t))
	return wave * (1.0 / 2.5)


func _ripple_function(x: float, z: float, t: float) -> float:
	var d = sqrt(x * x + z * z)
	var y = sin(PI * (4.0 * d - t))
	return y / (1.0 + 10.0 * d)
