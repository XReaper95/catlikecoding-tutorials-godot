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
	Wave, MultiWave, MorphingWave, Ripple
}
var _function_map = {
	Function.Wave: _wave_function,
	Function.MultiWave: _multiwave_function,
	Function.MorphingWave: _morphing_wave_function,
	Function.Ripple: _ripple_function
}

### Functions ###
func _wave_function(x: float, z: float, t: float) -> float:
	return sin(PI * (x + t))
	
	
func _multiwave_function(x: float, z: float, t: float) -> float:
	var wave = _wave_function(x, z, t)
	wave += 0.5 * sin(2.0 * PI * (x + t))
	return wave * (2.0 / 3.0)


func _morphing_wave_function(x: float, z: float, t: float) -> float:
	var half_period_wave = sin(PI * (x + 0.5 * t))
	half_period_wave += 0.5 * sin(2.0 * PI * (x + t))
	return half_period_wave * (2.0 / 3.0)


func _ripple_function(x: float, z: float, t: float) -> float:
	var d = abs(x)
	var y = sin(PI * (4.0 * d - t))
	return y / (1.0 + 10.0 * d)
