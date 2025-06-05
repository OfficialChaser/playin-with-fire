shader_type tilemap;

void fragment() {
    float opacity = TILE.custom_data["opacity"];
    COLOR.a *= opacity;
}