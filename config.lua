--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

application = {
    content = {
        width = 800,
        height = 480,
        scale = "letterbox",  -- Adjust scale mode as needed
        fps = 60,
        
        imageSuffix = {
            ["@2x"] = 1.5,
            ["@4x"] = 3.0,
        },
    },
    orientation = {
        default = "landscapeRight",
        supported = { "landscapeLeft", "landscapeRight" },
    },
}

