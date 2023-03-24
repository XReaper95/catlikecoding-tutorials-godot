class_name FunctionLibrary
extends Resource

@export var function: _Function = _Function.Wave:
	set(value):
		_selected_function = _function_map.get(value)
		function = value


func get_function():
	return _selected_function


var _selected_function: Callable
enum _Function {
	Wave, MultiWave, MorphingWave, Ripple
}
var _function_map = {
	_Function.Wave: _wave_function,
	_Function.MultiWave: _multiwave_function,
	_Function.MorphingWave: _morphing_wave_function,
	_Function.Ripple: _ripple_function
}

### Functions ###
func _wave_function(x: float, t: float) -> float:
	return sin(PI * (x + t))
	
	
func _multiwave_function(x: float, t: float) -> float:
	var wave = _wave_function(x, t)
	wave += 0.5 * sin(2.0 * PI * (x + t))
	return wave * (2.0 / 3.0)


func _morphing_wave_function(x: float, t: float) -> float:
	var half_period_wave = sin(PI * (x + 0.5 * t))
	half_period_wave += 0.5 * sin(2.0 * PI * (x + t))
	return half_period_wave * (2.0 / 3.0)


func _ripple_function(x: float, t: float) -> float:
	var d = abs(x)
	var y = sin(PI * (4.0 * d - t))
	return y / (1.0 + 10.0 * d)
