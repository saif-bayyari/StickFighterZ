-- Constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local MAN_WIDTH = 200  -- Desired width of the man images
local MAN_HEIGHT = 200  -- Desired height of the man images
local MOVE_SPEED = 2000 -- Speed in pixels per second

local Stickman = require("stickman")
local flux = require("flux")

-- Create a label for the button
local buttonText = display.newText({
    text = "<=",
    x = -500 + 175 / 2,
    y = 525 + 175 / 2,
    font = native.systemFontBold,
    fontSize = 50
})
buttonText:setFillColor(1, 1, 1)
buttonText.anchorX = 0.5
buttonText.anchorY = 0.5

-- Function to handle button touch events
local function onButtonTouch(event)
    if event.phase == "began" then
        print("Button touched!")
        -- Insert the code you want to trigger when the button is touched
    end
    return true  -- Prevents touch propagation to underlying objects
end

-- Create a button using a rectangle
local button = display.newRect(-500, 525, 175, 175)
button:setFillColor(0.2, 0.5, 0.8)
button.anchorX = 0
button.anchorY = 0
button:addEventListener("touch", onButtonTouch)

-- Initialize Solar2D
display.setStatusBar(display.HiddenStatusBar)
display.setDefault("background", 1, 1, 1)
local composer = require("composer")
local scene = composer.newScene()

-- Group all images in a table for easy access (if needed)

-- Initial setup (if needed)

-- Track key states
local key_states = {
    a = false,
    d = false
}

-- Initialize previous_time (if needed)
local previous_time = system.getTimer()

-- Create a Stickman instance
local person1 = Stickman:new("Saif", 30)

-- Function to handle key events
-- Function to handle key events
local function onKeyEvent(event)
    if event.phase == "down" then
	person1.MOVE_SPEED = 2000
        if event.keyName == "a" then
            person1.is_flipped = true


        elseif event.keyName == "d" then
            person1.is_flipped = false
        end
    elseif event.phase == "up" then
        if event.keyName == "a" or event.keyName == "d" then
            person1.MOVE_SPEED = 0  -- Stop movement
            person1.animation_counter = 0
            person1.current_frame = 1
            person1.man_stand_img.isVisible = true
            for _, img in ipairs(person1.man_images) do
                img.isVisible = false
            end
        end
    end
    return true
end


-- Runtime event listeners
Runtime:addEventListener("key", onKeyEvent)

-- Function to update the game state
local function update(event)
    local current_time = system.getTimer()
    local dt = (current_time - previous_time) / 1000
    previous_time = current_time

    flux.update(dt)  -- Update Flux with delta time

    -- Update the Stickman instance only if moving
    if person1.MOVE_SPEED ~= 0 then
        person1:update(dt)
    else
        -- Handle stand still animation or state
        person1.animation_counter = 0
        person1.current_frame = 1
        person1.man_stand_img.isVisible = true
        for _, img in ipairs(person1.man_images) do
            img.isVisible = false
        end
    end

    -- Additional game logic can be added here
end

-- Event listener for enterFrame event
Runtime:addEventListener("enterFrame", update)

-- Return scene
return scene
