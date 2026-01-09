shader_type canvas_item;
uniform float progress = 0.0;

struct shape {
	vec2 position;
	vec2 size;
	float rotation;
	float strokeWidth;
	vec4 strokeColor;
	vec4 fillColor;
	float param;
};

//inverted step function. y is 1 until x reaches end, then y is 0
float inverseStep(float end, float x) {
	return -step(end, x) + 1.0;
}

//combination of step and inverseStep. y is 1 only between start and end
float intervalStep(float start, float end, float x) {
	return step(start, x) * inverseStep(end, x);
}

vec4 circleFrag(shape e, vec2 uv) {
	float r = e.size.x;
	float strokeWidth = e.strokeWidth;
	vec4 strokeColor = e.strokeColor;
	vec4 fillColor = e.fillColor;
	float dist = distance(e.position, uv);
	float inStroke = intervalStep(r - strokeWidth, r, dist);
	float inFill = intervalStep(0, r - strokeWidth, dist);
	return inFill * fillColor + inStroke * strokeColor;
}

void fragment() {
	vec2 size = vec2((1.0 - progress) * 0.6);
	float param = 0.0;
	vec2 position = vec2(0.5);
	float rotation = 0.0;
	vec4 strokeColor = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 fillColor = vec4(vec3(0.0), 1.0);
	float strokeWidth = 0.0;
	shape s = shape(position, size, rotation, strokeWidth, strokeColor, fillColor, param);
	vec4 color = circleFrag(s, UV);
	color.a = -(color.a - 1.0);
	COLOR = color;
}
