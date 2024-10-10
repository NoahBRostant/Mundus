extends Node

# ------------------------------------------------------- Changable Variables

@export var verState := "Alpha"
@export var version := "0.2.0"

# --------------------------------------------

var logincounter
func _ready() -> void:
	var loginfile = ConfigFile.new()
	loginfile.load("res://addons/supabase/counter.ini")
	logincounter = loginfile.get_value("counter", "value")

var debug:String = ""
var ECode:String = ""

var save:bool = false

var Projects:Array = []
var projectSelected

var subArray = ["Free", "Tinkerer", "Master"]
var subNameArray = []
var subPriceArray = []

var skiptologin = true

var filetoopen:int

# Global Telementory Data and System Specs

var operatingSystem = OS.get_name()
var hasGlobalMenu = DisplayServer.has_feature(DisplayServer.FEATURE_GLOBAL_MENU)

var tabidint = 0

# ------------------------- for artcle defenitions

var articleDefinitions = {
	"article":"path",
}
