#[compute]
#version 450

#define PI 3.1415926535897932384626433832795

// Invocations in the (x, y, z) dimension
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

// A binding to the buffer we create in our script
layout(set = 0, binding = 0, std430) restrict buffer _positions {
  vec3 data[];
}
my_data_buffer;

layout(set = 0, binding = 1) uniform uint _resolution;
layout(set = 0, binding = 2) uniform float _step;
layout(set = 0, binding = 3) uniform float _time;

vec2 get_uv (vec3 id) {
	return (id.xy + 0.5) * _Step - 1.0;
}

void set_position (uvec3 id, vec3 position) {
  if (id.x < _resolution && id.y < _resolution) {
	  _positions[id.x + id.y * _resolution] = position;
  }
}

vec3 wave (float u, float v, float t) {
	vec3 p;
	p.x = u;
	p.y = sin(PI * (u + v + t));
	p.z = v;
	return p;
}

// The code we want to execute in each invocation
void main() {
  // gl_GlobalInvocationID.x uniquely identifies this invocation across all work
  // groups
    my_data_buffer.data[gl_GlobalInvocationID.x] *= 2.0;
}