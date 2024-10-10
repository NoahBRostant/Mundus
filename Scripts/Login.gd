extends Control

var has_child : bool = false
var port = 8060
var tcp_server : TCPServer = TCPServer.new()
var tcp_timer : Timer = Timer.new()
var tcp_timeout : float = 0.5

func _ready():
	set_process(false)
	tcp_timer.wait_time = tcp_timeout
	#get_window().size = Vector2i(576,648)
	#get_window().initial_position = Window.WINDOW_INITIAL_POSITION_ABSOLUTE
	#get_window().position = getS_window().position+Vector2i(288,0)
	#get_window().borderless = false
	#get_window().title = "Mundus - Project List"
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#Supabase.auth.signed_in.connect(_on_Supabase_auth_signed_in)
	#Supabase.auth..Auth.connect("login_failed", _on_FirebaseAuth_login_failed)
	#Firebase.Auth.connect("signup_succeeded", _on_FirebaseAuth_signup_succeeded)
	#Firebase.Auth.connect("signup_failed", _on_FirebaseAuth_signup_failed)
	pass


func _on_login_button_up():
	var email = %LEmail.text
	var password = %LPassword.text
	if email == "" and password == "admin":
		get_parent().get_parent()._admin()
	if email != "":
		var signtask : AuthTask = Supabase.auth.sign_in(email, password)
		if signtask.error == null:
			_on_Supabase_auth_signed_in(signtask.data)
		else:
			%Loginerrors.text = "[center][color=#FE8B68]"+str(signtask.error.code)+": "+str(signtask.error.message)+"[/color][/center]"
			get_parent().hide()
			%LPassword.text = ""
			get_parent().get_parent().retry(signtask.error.code, signtask.error.message)
	else:
		%Loginerrors.text = "[center][color=#FE8B68]You must enter your email[/color][/center]"

func _on_register_button_up():
	var email = %REmail.text
	var password = %RPassword.text
	var confirmation = %RConfirm.text
	if email != "":
		if password.length() > 5:
			if password == confirmation and $ColorRect/MarginContainer/VBoxContainer/Panel/HBoxContainer/MarginContainer2/TabContainer/Register/VBoxContainer/CheckBox.button_pressed == true:
				var signtask : AuthTask = Supabase.auth.sign_up(email, password)
				if signtask.error == null:
					print("Success!")
					%Loginerrors.text = "[center]Successfuly Created Account[/center]"
					%Registererrors.text = "[center]Fill your details to Register"
					$ColorRect/MarginContainer/VBoxContainer/Panel/HBoxContainer/MarginContainer2/TabContainer.current_tab = 0
				else:
					%Registererrors.text = "[center][color=#FE8B68]"+str(signtask.error.code)+": "+str(signtask.error.message)+"[/color][/center]"
		else:
			%Registererrors.text = "[center][color=#FE8B68]Invalid Password: Password must be more than 6 characters.[/color][/center]"
	else:
		%Loginerrors.text = "[center][color=#FE8B68]You must enter your email[/color][/center]"

func _on_Supabase_auth_signed_in(user : SupabaseUser):
	var empty = ""
	var loginfile = ConfigFile.new()
	loginfile.load("res://addons/supabase/counter.ini")
	loginfile.set_value("counter", "value", 10)
	loginfile.save("res://addons/supabase/counter.ini")
	print("Success!")
	get_parent().hide()
	get_parent().get_parent().retry(user, empty)


func _on_button_button_up():
	Supabase.auth.sign_in_with_provider("google")
	await get_tree().create_timer(0.5).timeout
	start_server(port)
	#provider = Firebase.Auth.get_GoogleProvider()
	#Firebase.Auth.get_auth_localhost(provider, port)


func _on_github_button_up():
	Supabase.auth.sign_in_with_provider("github")
	await get_tree().create_timer(0.5).timeout
	start_server(port)
	#check_localhost("github", port)
	#provider = Firebase.Auth.get_GitHubProvider()
	#Firebase.Auth.get_auth_localhost(provider, port)
	

func start_server(port):
	if has_child == false:
		add_child(tcp_timer)
		has_child = true
		tcp_timer.start()
		var result = tcp_server.listen(port, "*")  # Listen on all interfaces (i.e., 0.0.0.0)
		
		if result != OK:
			print("Failed to listen on port ", port)
		else:
			print("Server is listening on port ", port)
			set_process(true)  # Enable _process() to handle incoming connections

func _process(_delta):
	# Accept a connection when one arrives
	if tcp_server.is_connection_available():
		var client = tcp_server.take_connection()
		handle_client(client)

func handle_client(client: StreamPeerTCP):
	var line = client.get_utf8_string()  # Read the request from the browser
	if line:
		if line.find("GET /") != -1:
			var url = line.split(" ")[1]  # Extract the part of the request after "GET"
			
			# Example: /?code=AUTH_CODE
			if url.find("?code=") != -1:
				var code = url.split("=")[1]  # Extract the authorization code
				print("OAuth authorization code: ", code)
				# You can now proceed to exchange this code for a token
				# (in the OAuth flow, using the provider's token endpoint)

	#client.close()  # Close the connection after processing


func _on_l_password_text_submitted(_new_text: String) -> void:
	_on_login_button_up()
