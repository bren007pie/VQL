extends TileMap

# Constants for things
const layer_id : int = 0 # Layer 0 is the first layer
const tileset_atlas_id : int = 0 # The ID is the ID of the tileset (atlast)

# TILSET USES OFFSET COORDINATES - “odd-r” horizontal layout, shoves odd rows (right https://www.redblobgames.com/grids/hexagons/#coordinates-offset)
# Convert to cube coordinates asap haha, really makes math dumb

func _input(event): # check for moust event
	if event is InputEventMouseButton: # if the event is mouse 
		if event.is_pressed() and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT ) : # comparing to global scoped variable and boolean function  
			# Converting from Camera position
			var camera : Node = get_node("Camera2D") # get the camera
			var global_clicked_position: Vector2 = get_global_mouse_position() # GDscript using type dectorator which I think is much more gross
			# TODO: convert getting global position to local one to a function 
			
			# Convert from global (in-game) to cell in tiles
			print("Mouse Position: ", global_clicked_position)
			var tile_clicked_position: Vector2i = local_to_map(to_local(global_clicked_position)) #convert from global to local tilemap position
			print(tile_clicked_position)

			# Left mouse button sets a single cell, right mouse button sets a radius 
			if event.button_index == MOUSE_BUTTON_LEFT:
				set_tile(tile_clicked_position)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				set_1_radius(tile_clicked_position)
			

func set_tile(tile_clicked_position: Vector2i) -> void:
	var current_atlas_coords: Vector2i = get_cell_atlas_coords(layer_id,tile_clicked_position) # Get atlas ID and alt ID
	var current_tile_alt_id: int = get_cell_alternative_tile(layer_id,tile_clicked_position) 
	set_cell(layer_id, tile_clicked_position, tileset_atlas_id, current_atlas_coords, (current_tile_alt_id + 1) % 2 )

func set_1_radius(tile_clicked_position: Vector2i) -> void:
	# https://www.redblobgames.com/grids/hexagons/#neighbors-offset
	# Checking if even or odd row
	# PERCENT SIGN % IS THE MODULO OPERATOR NOT & WHICH IS THE AND OPERATOR

	if( tile_clicked_position.y % 2 == 0): # If true it's even row, y % 2 => 0 then y is even
		set_tile(tile_clicked_position)
		set_tile(tile_clicked_position + Vector2i(1,0) )
		set_tile(tile_clicked_position + Vector2i(0,-1) )
		set_tile(tile_clicked_position + Vector2i(-1,-1) )
		set_tile(tile_clicked_position + Vector2i(-1,0) )
		set_tile(tile_clicked_position + Vector2i(-1,1) )
		set_tile(tile_clicked_position + Vector2i(0,1) )
	else: # is an odd row
		set_tile(tile_clicked_position)
		set_tile(tile_clicked_position + Vector2i(1,0) )
		set_tile(tile_clicked_position + Vector2i(+1,-1) )
		set_tile(tile_clicked_position + Vector2i(0,-1) )
		set_tile(tile_clicked_position + Vector2i(-1,0) )
		set_tile(tile_clicked_position + Vector2i(0,1) )
		set_tile(tile_clicked_position + Vector2i(1,1) )
		
		
# TODO: Make a function for spiral rings 
	
	
