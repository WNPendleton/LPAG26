shader_type canvas_item;

struct shape {
	vec2 position;
	vec2 size;
	float rotation;
	float strokeWidth;
	vec4 strokeColor;
	vec4 fillColor;
	float param;
};

//used for graphing function lines. indicates whether this pixel is on the function line
float plot(float y, float v) {
	float lineThickness = 0.02;
	return smoothstep(y - lineThickness, y, v) - smoothstep(y, y + lineThickness, v);
}

vec3 hsv2rgb(vec3 c){
	vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0,4.0,2.0), 6.0)-3.0)-1.0,0.0,1.0);
	rgb = rgb * rgb * (3.0 - 2.0 * rgb);
	return c.z * mix(vec3(1.0), rgb, c.y);
}

float rand(float x) {
	return fract(sin(x)*10000.0);
}

//inverted step function. y is 1 until x reaches end, then y is 0
float inverseStep(float end, float x) {
	return -step(end, x) + 1.0;
}

//combination of step and inverseStep. y is 1 only between start and end
float intervalStep(float start, float end, float x) {
	return step(start, x) * inverseStep(end, x);
}

//inverted interval step, y is 0 between start and end.
float inverseIntervalStep(float start, float end, float x) {
	return -(step(start, x) * inverseStep(end, x)) + 1.0;
}

float boundedSin(float low, float high, float x) {
	return 0.5 * (sin(x) * (high - low) + (high + low));
}

float boundedTriangleWave(float low, float high, float x) {
	float fx = fract(x);
	return (floor(mod(x, 2.0)) * fx + floor(mod(x + 1.0, 2.0)) * (1.0 - fx)) * (high - low) + low;
}

//pow using integer exponent, allows negative base
float ipow(float x, int n) {
	float result = 1.0;
	for (int i = 0; i < n; i++) {
		result *= x;
	}
	return result;
}

//direct linear relationship between x and y
float linear(float x) {
	return x;
}

//plots two lines from (0,0) to (a,b) then to (1,1)
float doubleLinear(float a, float b, float x) {
	return b / a * x * inverseStep(a, x) +
	((1.0 - b) / (1.0 - a) * (x - a) + b) * step(a, x);
}

//fast approximation of -cos(x) + 1 on (0, PI)
float approxCos(float x) {
	float x2 = x * x;
	float x4 = x2 * x2;
	float x6 = x4 * x2;
	return (4.0 / 9.0 * x6) - (17.0 / 9.0 * x4) + (22.0 / 9.0 * x2);
}

//generalized form of doubleCubicSeat for any odd-order polynomial
float doubleOddPolynomialSeat(float a, float b, int n, float x) {
	int ex = 2 * n + 1;
	return (b - b * ipow((1.0 - x / a), ex)) * inverseStep(a, x) +
	(b + (1.0 - b) * ipow((x - a) / (1.0 - a), ex)) * step(a, x);
}

//generalized form of blendedDoubleCubicSeat for any odd-order polynomial
float blendedDoubleOddPolynomialSeat(float a, float b, int n, float x) {
	return b * x + (1.0 - b) * (a + a * ipow(2.0 * (x - 0.5), 2 * n + 1));
}

//two cubic curves joined with a horizontal inflection point at a given control point (a,b)
float doubleCubicSeat(float a, float b, float x) {
	a = clamp(a, 0.0001, 0.9999);
	b = clamp(b, 0.0001, 0.9999);
	return (b - b * ipow(1.0 - x / a, 3)) * inverseStep(a, x) +
	(b + (1.0 - b) * ipow((x - a) / (1.0 - a), 3)) * step(a, x);
}

//two cubic curves joined with an inflection point at (a, a), blended by an amount b
float blendedDoubleCubicSeat(float a, float b, float x) {
	return blendedDoubleOddPolynomialSeat(a, b, 1, x);
}

//two nth order polynomials joined at (0.5, 0.5) to make a sigmoid curve
float symmetricDoublePolynomialSigmoid(int n, float x) {
	float x2 = 2.0 * x;
	float x22 = x2 - 2.0;
	int n2 = 2 * n;
	int n21 = n2 + 1;
	float s = step(0.5, x);
	float is = inverseStep(0.5, x);
	float even = mod(float(n + 1), 2.0);
	float odd = mod(float(n), 2.0);
	return (ipow(x2, n2) / 2.0) * is * even +
	(1.0 - (ipow(x22, n2)) / 2.0) * s * even +
	(ipow(x2, n21) / 2.0) * is * odd +
	(1.0 + (ipow(x22, n21)) / 2.0) * s * odd;
}

//quadratic curve passing through (a,b)
float quadratic(float a, float b, float x) {
	float c = (1.0 - b) / (1.0 - a) - b / a;
	return c * x * x - (a * a * c - b) / a * x;
}

//grows slowly at first, speeds up scaled by a
float exponentialEaseIn(float a, float x) {
	a = clamp(0, 1, a);
	return pow(x, 1.0 / a);
}

//grows quickly at first, slows down scaled by a
float exponentialEaseOut(float a, float x) {
	a = clamp(a, 0, 1);
	return pow(x, a);
}

//double exponential function passing through (0.5, 0.5), a controls curve rate.
//generates seats for a < 1. generates sigmoids for a > 1.
float doubleExponential(float a, float x) {
	return pow(2.0 * x, a) / 2.0 * inverseStep(0.5, x) +
	(1.0 - pow(2.0 * (1.0 - x), a) / 2.0) * step(0.5, x);
}

float logisticCurve(float a, float x) {
	a = clamp(a, 0.0001, 0.9999);
	a = (1.0 / (1.0 - a) - 1.0);
	float p = 1.0 / (1.0 + exp(a));
	float q = 1.0 / (1.0 + exp(-a));
	float r = 1.0 / (1.0 + exp(-2.0 * a * (x - 0.5)));
	return (r - p) / (q - p);
}

float circularEaseIn(float x) {
	return 1.0 - sqrt(1.0 - x * x);
}

float circularEaseOut(float x) {
	return sqrt(1.0 - pow(1.0 - x, 2));
}

float doubleEllipticSeat(float a, float b, float x) {
	float p = pow(x - a, 2);
	return b / a * sqrt(a * a - p) * inverseStep(a, x) +
	(1.0 - ((1.0 - b) / (1.0 - a)) * sqrt(pow(1.0 - a, 2) - p)) * step(a, x);
}

float doubleEllipticSigmoid(float a, float b, float x) {
	return b * (1.0 - sqrt(a * a - x * x) / a) * inverseStep(a, x) +
	(b + ((1.0 - b) / (1.0 - a)) * sqrt(pow(1.0 - a, 2) - pow(x - 1.0, 2))) * step(a, x);
}

float doubleCircleSeat(float a, float x) {
	return doubleEllipticSeat(a, a, x);
}

float doubleCircleSigmoid(float a, float x) {
	return doubleEllipticSigmoid(a, a, x);
}

float semicircle(float a, float b, float r, float x) {
	float h = x - a;
	return sqrt(r * r - h * h) + b;
}

//Displays a graph of the function created by the call assigned to float y
vec4 graphFunction(vec2 uv){
	float u = uv.x;
	float v = uv.y;
	
	float x = u;
	//change this call to change the function being graphed
	float y = doubleCubicSeat(0.9, 0.5, x);
	
	vec3 color = vec3(y);
	float pct = plot(y, v);
	color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);
	return vec4(color, 1.0);
}

vec4 rectFrag(shape r, vec2 uv) {
	float x = r.position.x;
	float y = r.position.y;
	float w = r.size.x / 2.0;
	float h = r.size.y / 2.0;
	float strokeWidth = r.strokeWidth;
	vec4 strokeColor = r.strokeColor;
	vec4 fillColor = r.fillColor;
	
	float inStroke = intervalStep(x - w, x + w, uv.x) * intervalStep(y - h, y + h, uv.y) * clamp(inverseIntervalStep(x - w + strokeWidth, x + w - strokeWidth, uv.x) + inverseIntervalStep(y - h + strokeWidth, y + h - strokeWidth, uv.y), 0.0, 1.0);
	float inFill = intervalStep(x - w + strokeWidth, x + w - strokeWidth, uv.x) * intervalStep(y - h + strokeWidth, y + h - strokeWidth, uv.y);
	return inFill * fillColor + inStroke * strokeColor;
}

vec4 circleFrag(shape e, vec2 uv) {
	float x = e.position.x;
	float y = e.position.y;
	float r = e.size.x;
	float strokeWidth = e.strokeWidth;
	vec4 strokeColor = e.strokeColor;
	vec4 fillColor = e.fillColor;
	vec2 disp = uv - e.position;
	float dist = distance(e.position, uv);
	float inStroke = intervalStep(r - strokeWidth, r, dist);
	float inFill = intervalStep(0, r - strokeWidth, dist);
	return inFill * fillColor + inStroke * strokeColor;
}

vec4 ellipseFrag(shape e, vec2 uv) {
	float x = e.position.x;
	float y = e.position.y;
	float a = e.size.x;
	float b = e.size.y;
	float t = min(a, b);
	a = max(a, b);
	b = t;
	float c = sqrt(a * a - b * b);
	vec2 f1 = e.position - vec2(c, 0);
	vec2 f2 = e.position + vec2(c, 0);
	float r = 2.0 * a;
	float strokeWidth = e.strokeWidth;
	vec4 strokeColor = e.strokeColor;
	vec4 fillColor = e.fillColor;
	float dist = distance(f1, uv) + distance(f2, uv);
	float inStroke = intervalStep(r - strokeWidth / 2.0, r, dist);
	float inFill = intervalStep(0, r - strokeWidth / 2.0, dist);
	return inFill * fillColor + inStroke * strokeColor;
}

//draws a rounded rectangle, param controls corner radius.
vec4 squircleFrag(shape s, vec2 uv) {
	s.param = max(s.param, 0.06);
	uv = uv * 2.0 - 1.0;
	vec2 pos = -s.position * 2.0 + 1.0;
	float dist = length(max(abs(uv + pos) - (s.size - s.param), 0.0));
	float inFill = inverseStep(s.param - s.strokeWidth, dist);
	float inStroke = intervalStep(s.param - s.strokeWidth, s.param, dist);
	return s.strokeColor * inStroke + s.fillColor * inFill;
}

//draws a polygon. param is number of sides.
vec4 polygonFrag(shape s, vec2 uv) {
	uv = (uv - s.position) * 2.0;
	s.param = max(floor(s.param), 3.0);
	float a = atan(uv.x, uv.y) + PI + s.rotation;
	float r = TAU / float(s.param);
	float dist = cos(floor(0.5 + a / r) * r - a) * length(uv);
	float inFill = inverseStep(s.size.x - s.strokeWidth, dist);
	float inStroke = intervalStep(s.size.x - s.strokeWidth, s.size.x, dist);
	return s.fillColor * inFill + s.strokeColor * inStroke;
}

float rDistance(vec2 xy, vec2 uv) {
	vec2 dist = xy - uv;
	return 2.0 * dot(dist, dist);
}

float altTime(float eo) {
	return floor(mod(TIME + eo, 2.0));
}

void fragment() {
	vec2 size = vec2(0.2 + 0.2 * (sin(TIME * 1.5) / 3.0 + 0.5));
	float param = boundedTriangleWave(3.0, 20.0, TIME * 0.5);
	vec2 position = vec2(0.5 * (sin(TIME) / 2.0 + 1.0), 0.5 * (sin(TIME * 2.0) / 2.0 + 1.0));
	float rotation = TIME;
	vec4 strokeColor = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 fillColor = vec4(vec3(rand(TIME + rand(UV.x) * UV.y), rand(TIME + rand(UV.x) * rand(UV.y)), rand(TIME - UV.x * UV.y)), 1.0);
	float strokeWidth = size.x / 10.0;
	shape s = shape(position, size, rotation, strokeWidth, strokeColor, fillColor, param);
	vec4 color = polygonFrag(s, UV);
	COLOR = color;
}
