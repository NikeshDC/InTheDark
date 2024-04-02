//blends the color of texture with a parameter color based on alpha of the parameter
shader_type canvas_item;

uniform vec4 blend_color : hint_color = vec4(1.0, 1.0, 1.0, 0.0);

void fragment()
{
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR.rgb = mix(texture_color.rgb, blend_color.rgb, blend_color.a);
	COLOR.a = texture_color.a;
}