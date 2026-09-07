shader_type canvas_item;

uniform vec3 Color: source_color;
uniform float Mix: hint_range(0.0, 1.0);
uniform float Alpha: hint_range(0.0, 1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (texture_color.a != 0.0)
		COLOR = vec4(mix(texture_color.rgb, vec3(Color.rgb), Mix), Alpha);
}