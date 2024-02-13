extends Area2D


var drag_offset = Vector2.ZERO  # Offset from the mouse to the sprite's position
var dragging = false  # Flag to track dragging
var snap_to_tile_offset = Vector2(0, 20)

var tile_map: TileMap


func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		if event.pressed: # picking up
			drag_offset = global_position - get_global_mouse_position()
			dragging = true
		else: # setting down 
			snap_to_tile_center()
			dragging = false
			
func snap_to_tile_center():
	tile_map = get_node("../../HexTilemap") # Maybe it doesn't like names with spaces?
	# # Get the tilemap coordinate where the mouse is, get the global position of the tile (gives centre), then snap the position to the cenre 
	# Convert the Area2D's global position to the TileMap's local tile coordinate
	var tile_coord = tile_map.local_to_map(to_local(get_global_mouse_position()))
	print(get_global_mouse_position())
	print(tile_coord)
	# Convert the tile coordinate back to a global position, aiming for the center of the tile
	var tile_center_global = to_global(tile_map.map_to_local(tile_coord)) #+ snap_to_tile_offset
	print(tile_center_global)
	global_position = tile_center_global
