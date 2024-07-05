-- Constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local MAN_WIDTH = 200  -- Desired width of the man images
local MAN_HEIGHT = 200  -- Desired height of the man images
local MOVE_SPEED = 2000 -- Speed in pixels per second
local ANIMATION_DELAY = 5  

local flux = require "flux"

---------------------------------------------------------

-- Function to handle button touch events (unchanged)
local function onButtonTouch(event)
    if event.phase == "began" then
        print("Button touched!")
        -- Insert the code you want to trigger when the button is touched
    end
    return true  -- Prevents touch propagation to underlying objects
end

-- Create a button using a rectangle (unchanged)
local button = display.newRect(-500, 525, 175, 175)
button:setFillColor(0.2, 0.5, 0.8)
button.anchorX = 0
button.anchorY = 0

-- Create a label for the button (unchanged)
local buttonText = display.newText({
    text = "<=",
    x = button.x + button.width / 2,
    y = button.y + button.height / 2,
    font = native.systemFontBold,
    fontSize = 50
})
buttonText:setFillColor(1, 1, 1)
buttonText.anchorX = 0.5
buttonText.anchorY = 0.5

-- Add touch event listener to the button (unchanged)
button:addEventListener("touch", onButtonTouch)

---------------------------------------------------------
local Stickman = require "stickman"

-- Initialize Solar2D (unchanged)
display.setStatusBar(display.HiddenStatusBar)
display.setDefault("background", 1, 1, 1)
local composer = require("composer")
local scene = composer.newScene()

-- Load images (unchanged)

-- Group all images in a table for easy access (unchanged)

-- Track key states (unchanged)
local key_states = {
    a = false,
    d = false
}

-- Initialize stickman instance
local player = Stickman.new()

-- Initialize previous_time
local previous_time = system.getTimer()

-- Function to handle key events (unchanged)
local function onKeyEvent(event)
    if event.phase == "down" then
        key_states[event.keyName] = true
        if event.keyName == "a" then
            player.is_flipped = true
        elseif event.keyName == "d" then
            player.is_flipped = false
        end
    elseif event.phase == "up" then
        key_states[event.keyName] = false
        if event.keyName == "a" or event.keyName == "d" then
            player.animation_counter = 0
            player.current_frame = 1
            player.man_stand_img.isVisible = true
            for _, img in ipairs(player.man_images) do
                img.isVisible = false
            end
            player.man_img.rotation = 0
            player.man_img.xScale = 1
        end
    end
    return true
end

-- Runtime event listeners (unchanged)
Runtime:addEventListener("key", onKeyEvent)

-- Function to update animation and movement with Flux
local function updateAnimation(dt)
    if key_states.a or key_states.d then
        if player.animation_counter >= ANIMATION_DELAY then
            player.animation_counter = 0
            player.current_frame = (player.current_frame % #player.man_images) + 1
        end

        player.man_stand_img.isVisible = false
        for i, img in ipairs(player.man_images) do
            img.isVisible = (i == player.current_frame)
            img.x = player.man_img.x
            img.y = player.man_img.y
            img.xScale = player.is_flipped and -1 or 1
        end

        player.animation_counter = player.animation_counter + 1

        -- Move man_img with Flux
        local move_distance = MOVE_SPEED * dt
        local move_target = player.man_img.x + (player.is_flipped and -move_distance or move_distance)
        flux.to(player.man_img, 0.1, { x = move_target })
    else
        -- Reset to stand position
        player.man_stand_img.isVisible = true
        for _, img in ipairs(player.man_images) do
            img.isVisible = false
        end
    end
end

-- Function to update the game state (unchanged)
local function update(event)
    local current_time = system.getTimer()
    local dt = (current_time - previous_time) / 1000
    previous_time = current_time
    
    flux.update(dt)  -- Update Flux with delta time
    updateAnimation(dt)
end

-- Event listener for enterFrame event (unchanged)
Runtime:addEventListener("enterFrame", update)

-- Return scene (unchanged)
return scene
