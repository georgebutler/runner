shader_type canvas_item;

uniform vec2 motion = vec2(0.0, 0.0);
uniform float time = 0;

void fragment() {
	COLOR = texture(TEXTURE, UV + motion * time);
}
