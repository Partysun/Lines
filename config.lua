-- config.lua

application =
{
		android =
        {
                versionCode = "3"
        },
    
        androidPermissions =
        {
                "android.permission.ACCESS_FINE_LOCATION",
                "android.permission.INTERNET"
        },
    
        content =
        {
        		width = 320,
                height = 480,
                scale = "Letterbox",
                fps = 30,
                antialias = true
        },
}