shader_type spatial;

// use uniforms to pass values between code and shaders
uniform float min_height;
uniform float max_height;
// gradient texture to assign colours to planet regions
uniform sampler2D height_colour;

// variable interpolated between vertices
varying float height;

void vertex() {
	// given the origin of the mesh is the centre of the planet,
	// the height is just the length of the current vertex in local space
	height = length(VERTEX);

}

void fragment() {
	// Called for every pixel the material is visible on.
	// linear interpolation of current height between min and max height
	// gives a value for the current height between 0 and 1
	float t = (height - min_height)/(max_height - min_height);
	
	// sample the height_colour texture - because it's a 1D gradient, always use y=0 and set x = t
	// get rgb to remove any alpha channel
	vec3 colour = texture(height_colour, vec2(t, 0.0)).rgb;
	
	// set colour
	ALBEDO = colour;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
