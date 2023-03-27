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


func morph(u: float, v: float, t: float, from: Callable, to: Callable, progress: float):
	return lerp(from.call(u, v, t), to.call(u, v, t), smoothstep(0.0, 1.0, progress))


var _selected_function: Callable
enum Function {
	Wave, MultiWave, Ripple, Sphere, Torus
}
var _function_map = {
	Function.Wave: _wave,
	Function.MultiWave: _multi_wave,
	Function.Ripple: _ripple,
	Function.Sphere: _sphere,
	Function.Torus: _torus
}

### Functions ###
func _wave(u: float, v: float, t: float) -> Vector3:
	return Vector3(u, sin(PI * (u + v + t)), v)


func _multi_wave(u: float, v: float, t: float) -> Vector3:
	var y = sin(PI * (u + 0.5 * t))
	y += 0.5 * sin(2.0 * PI * (v + t))
	y += sin(PI * (u + v + 0.25 * t))
	y *= (1.0 / 2.5)
	return Vector3(u, y, v)


func _ripple(u: float, v: float, t: float) -> Vector3:
	var d = sqrt(u * u + v * v)
	var y = sin(PI * (4.0 * d - t))
	y /= (1.0 + 10.0 * d)
	return Vector3(u, y, v)


func _sphere(u: float, v: float, t: float) -> Vector3: 
	var r = 0.9 + 0.1 * sin(PI * (6.0 * u + 4.0 * v + t))
	var s = r * cos(0.5 * PI * v)
	return Vector3(s * sin(PI * u), r * sin(PI * 0.5 * v), s * cos(PI * u))


func _torus(u: float, v: float, t: float) -> Vector3: 
	var r1 = 0.7 + 0.1 * sin(PI * (6.0 * u + 0.5 * t))
	var r2 = 0.15 + 0.05 * sin(PI * (8.0 * u + 4.0 * v + 2.0 * t))
	var s = 0.5 + r1 + r2 * cos(PI * v)
	return Vector3(s * sin(PI * u), r2 * sin(PI * v), s * cos(PI * u))
