shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	NORMALMAP = texture(NORMAL_TEXTURE, UV).rgb;
}