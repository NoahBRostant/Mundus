extends Node3D

var rings: int = 4
var radius: float = 2

var angle_offset = PI / 6  # 30 degrees in radians

static func get_arithmetic_progression_sum(a: int, d: int, n: int) -> int:
	# Formula for the sum of the first n terms of an arithmetic progression: n/2 * (2a + (n - 1) * d)
	return n * (2 * a + (n - 1) * d) / 2

static func hex_point(radius: float, point_i: int) -> Vector3:
	var angle = -PI / 2.0 + PI / 3.0 * point_i
	var x = radius * cos(angle)
	var y = radius * sin(angle)
	return Vector3(x, 0, y)

static func generate_hex_grid_vertices(ring_count: int, ring_radius: float) -> Array:
	# Assuming GetArithmeticProgressionSum is a function that calculates the sum of an arithmetic progression
	var point_count = get_arithmetic_progression_sum(1, 6, ring_count - 1) + 1  # Including first one-point ring
	var points = []
	points.append(Vector3.ZERO)  # The center point
	var point_index = 1

	for ring_i in range(1, ring_count + 1):
		var r = ring_radius * ring_i
		for point_i in range(6):  # Main loop for each side of the hexagon
			var start_point = hex_point(r, point_i)
			var end_point = hex_point(r, point_i + 1)
			var side_point_count = ring_i
			var side_step = 1.0 / side_point_count
			for side_point_i in range(side_point_count):
				points.append(linear_interpolate(start_point, end_point, side_step * side_point_i))
	return points

static func linear_interpolate(start_point: Vector3, end_point: Vector3, t: float) -> Vector3:
	return start_point + (end_point - start_point) * t

func find_closest_vertex(vert_array, target_vertex, tolerance):
	var closest_index = -1
	var min_distance = tolerance
	for idx in range(vert_array.size()):
		var distance = vert_array[idx].distance_to(target_vertex)
		if distance < min_distance:
			min_distance = distance
			closest_index = idx
	return closest_index

func arrays_have_same_content(array1, array2):
	for item in array1:
		if !array2.has(item):
			return false
	return true

func _ready():
	var hex_vert = generate_hex_grid_vertices(rings, radius)
	#print(hex_vert)
	#for i in hex_vert:
		#var sphere = MeshInstance3D.new()
		#var sphere_mesh = SphereMesh.new()  # Create a new SphereMesh
		#sphere_mesh.radius = 0.2
		#sphere.mesh = sphere_mesh  # Assign the SphereMesh to the MeshInstance3D
		#sphere.transform.origin = i  # Set the position using the Vector3 from hex_verts
		#self.add_child(sphere)
	
	var mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertices = PackedVector3Array(hex_vert)
	var indices = PackedInt32Array()

	#var i = hex_vert[6]
	for i in hex_vert:
		var north_vertex = Vector3(i.x,i.y,i.z - radius)
		if find_closest_vertex(hex_vert, north_vertex, 0.01) != -1:
			indices.append(hex_vert.find(i))
			var north_vertex_index = find_closest_vertex(hex_vert, north_vertex, 0.01)
			indices.append(north_vertex_index)

		var north_east_vertex = Vector3(i.x + radius * cos(angle_offset), i.y, i.z - radius * sin(angle_offset))
		if find_closest_vertex(hex_vert, north_east_vertex, 0.01) != -1:
			indices.append(hex_vert.find(i))
			var north_east_vertex_index = find_closest_vertex(hex_vert, north_east_vertex, 0.01)
			indices.append(north_east_vertex_index)

		var south_west_vertex = Vector3(i.x - radius * cos(7 * angle_offset), i.y, i.z + radius * sin(angle_offset))
		if find_closest_vertex(hex_vert, south_west_vertex, 0.01) != -1:
			indices.append(hex_vert.find(i))
			var south_west_vertex_index = find_closest_vertex(hex_vert, south_west_vertex, 0.01)
			indices.append(south_west_vertex_index)

	#print(indices)
	
	var lines_list : Dictionary = lines(indices)
	
	var faces_list : Array = faces(hex_vert)

	var faces_tmp : Array = faces_list

	var indices_to_remove = []

	for i in range(0, indices.size(), 2):
		var pair = [indices[i], indices[i+1]]
		for o in faces_tmp:
			# print("Face: "+o)
			if arrays_have_same_content(pair,o):
				faces_tmp.erase(o)
				faces_list.erase(pair[0])
				faces_list.erase(pair[1])
				if indices.find(i) != -1:  # Check if i is in indices
					indices_to_remove.append(indices.find(i))
				if indices.find(i+1) != -1:  # Check if i+1 is in indices
					indices_to_remove.append(indices.find(i+1))

	# Remove elements from indices
	for index in indices_to_remove:
		indices.remove_at(index)


	
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	self.add_child(mesh_instance)

func lines(indices):
	var lines_list = {}
	var iteration = 0
	for i in range(0, indices.size(), 2):
		lines_list["line"+str(iteration)] = [indices[i],indices[i+1]]
		iteration += 1
	return lines_list

func faces(hex_vert):
	var faces_list = []
	var iteration = 0
	for i in hex_vert:
		var north_vertex = Vector3(i.x,i.y,i.z - radius)
		var north_east_vertex = Vector3(i.x + radius * cos(angle_offset), i.y, i.z - radius * sin(angle_offset))
		if find_closest_vertex(hex_vert, north_vertex, 0.01) != -1 and find_closest_vertex(hex_vert, north_east_vertex, 0.01) != -1:
			var start = hex_vert.find(i)
			var north_vertex_index = find_closest_vertex(hex_vert, north_vertex, 0.01)
			var north_east_vertex_index = find_closest_vertex(hex_vert, north_east_vertex, 0.01)
			faces_list.append([start,north_vertex_index])
			faces_list[iteration].append_array([start,north_east_vertex_index])
			faces_list[iteration].append_array([north_vertex_index,north_east_vertex_index])
			iteration += 1
		
		var south_vertex = Vector3(i.x,i.y,i.z + radius)
		var south_west_vertex = Vector3(i.x - radius * cos(angle_offset), i.y, i.z + radius * sin(angle_offset))
		if find_closest_vertex(hex_vert, south_vertex, 0.01) != -1 and find_closest_vertex(hex_vert, south_west_vertex, 0.01) != -1:
			var start = hex_vert.find(i)
			var south_vertex_index = find_closest_vertex(hex_vert, south_vertex, 0.01)
			var south_west_vertex_index = find_closest_vertex(hex_vert, south_west_vertex, 0.01)
			faces_list.append([start,south_vertex_index])
			faces_list[iteration].append_array([start,south_west_vertex_index])
			faces_list[iteration].append_array([south_vertex_index,south_west_vertex_index])
			iteration +=1
	# printerr(faces)
	return faces_list
