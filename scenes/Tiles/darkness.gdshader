shader_type canvas_item;

uniform vec2 player_pos;
uniform float max_distance = 300.0;

void fragment() {
    float dist = distance(SCREEN_UV * vec2(textureSize(TEXTURE, 0)), player_pos);
    float fade = clamp(1.0 - (dist / max_distance), 0.0, 1.0);
    COLOR = texture(TEXTURE, UV) * vec4(1.0, 1.0, 1.0, fade);
}