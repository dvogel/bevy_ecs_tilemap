struct Output {
    world_position: vec4<f32>,
};

let DIAMOND_BASIS_X: vec2<f32> = vec2<f32>(0.5, -0.5);
let DIAMOND_BASIS_Y: vec2<f32> = vec2<f32>(0.5, 0.5);

// Gets the screen space coordinates of the bottom left of an isometric tile position.
fn diamond_tile_pos_to_world_pos(pos: vec2<f32>, grid_width: f32, grid_height: f32) -> vec2<f32> {
    let unscaled_pos = pos.x * DIAMOND_BASIS_X + pos.y * DIAMOND_BASIS_Y;
    return vec2<f32>(grid_width * unscaled_pos.x, grid_height * unscaled_pos.y);
}

// Gets the screen space coordinates of the bottom left of an isometric tile position.
fn staggered_tile_pos_to_world_pos(pos: vec2<f32>, grid_width: f32, grid_height: f32) -> vec2<f32> {
    return diamond_tile_pos_to_world_pos(vec2<f32>(pos.x, pos.y + pos.x), grid_width, grid_height);
}

fn get_mesh(v_index: u32, vertex_position: vec3<f32>) -> Output {
    var out: Output;

    var bot_left = staggered_tile_pos_to_world_pos(vertex_position.xy, tilemap_data.grid_size.x, tilemap_data.grid_size.y);
    var tile_z = staggered_tile_pos_to_world_pos(tilemap_data.chunk_pos + vertex_position.xy, tilemap_data.grid_size.x, tilemap_data.grid_size.y);
    var top_right = vec2<f32>(bot_left.x + tilemap_data.tile_size.x, bot_left.y + tilemap_data.tile_size.y);

    var positions = array<vec2<f32>, 4>(
        bot_left,
        vec2<f32>(bot_left.x, top_right.y),
        top_right,
        vec2<f32>(top_right.x, bot_left.y)
    );

    out.world_position = mesh.model * vec4<f32>(vec3<f32>(positions[v_index % 4u], 1.0 - (tile_z.y / tilemap_data.map_size.y)), 1.0);

    return out;
}