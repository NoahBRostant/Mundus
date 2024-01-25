extends Node

var debug:String = ""
var ECode:String = ""

var save:bool = false

var Projects:Array = []
var projectSelected

var subArray = ["Free", "Tinkerer", "Master"]
var subNameArray = []
var subPriceArray = []

var skiptologin = true

# Global Telementory Data and System Specs

var operatingSystem = OS.get_name()
var hasGlobalMenu = DisplayServer.has_feature(DisplayServer.FEATURE_GLOBAL_MENU)
