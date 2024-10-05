extends Node3D

var size := Vector2(20, 15)
var random = RandomNumberGenerator.new()

func _ready():
    var mesh_instance = MeshInstance3D.new()
    var st = SurfaceTool.new()

    st.begin(Mesh.PRIMITIVE_TRIANGLES)

    for x in range(0, size.x, 10):
        for y in range(0, size.y, 10):
            var random_x = random.randf_range(-5, 5)
            var random_y = random.randf_range(-5, 5)
            st.add_vertex(Vector3(x + random_x, 0, y + random_y))

    st.index()
    var mesh = st.commit()
    mesh_instance.mesh = mesh

    add_child(mesh_instance)  # Add the mesh instance as a child of the current node