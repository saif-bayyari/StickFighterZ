

--NOTE MAKE THIS AN ADULT TOP DOWN GAME
--MAKE THIS A SKELETON FOR YOUR ACTUAL GAMES, MAKE THIS AN ENGINE





-- Constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local MAN_WIDTH = 200  -- Desired width of the man images
local MAN_HEIGHT = 200  -- Desired height of the man images
local MOVE_SPEED = 2000 -- Speed in pixels per second

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

-- Initialize Solar2D (unchanged)
display.setStatusBar(display.HiddenStatusBar)
display.setDefault("background", 1, 1, 1)
local composer = require("composer")
local scene = composer.newScene()

-- Load images (unchanged)
local image_path = "man/"
local man_stand_img = display.newImage(image_path .. "man-stand.png")
local man_run1_img = display.newImage(image_path .. "man-run1.png")
local man_run2_img = display.newImage(image_path .. "man-run2.png")
local man_run3_img = display.newImage(image_path .. "man-run3.png")

-- Scale the images to the desired size (unchanged)
local function scaleImage(image)
    image.width = MAN_WIDTH
    image.height = MAN_HEIGHT
end

scaleImage(man_stand_img)
scaleImage(man_run1_img)
scaleImage(man_run2_img)
scaleImage(man_run3_img)

-- Group all images in a table for easy access (unchanged)
local man_images = { man_run1_img, man_run2_img, man_run3_img }
for _, img in ipairs(man_images) do
    img.isVisible = false
end
man_stand_img.isVisible = true

-- Initial setup (unchanged)
local man_img = man_stand_img
man_img.x = -450
man_img.y = (SCREEN_HEIGHT / 2) + 50

local is_flipped = false  -- Track if image is flipped horizontally
local ANIMATION_DELAY = 5  -- Frames per image
local animation_counter = 0
local current_frame = 1  -- Start with first running frame

-- Track key states (unchanged)
local key_states = {
    a = false,
    d = false
}

-- Initialize previous_time
local previous_time = system.getTimer()

-- Function to handle key events (unchanged)
local function onKeyEvent(event)
    if event.phase == "down" then
        key_states[event.keyName] = true
        if event.keyName == "a" then
            is_flipped = true
        elseif event.keyName == "d" then
            is_flipped = false
        end
    elseif event.phase == "up" then
        key_states[event.keyName] = false
        if event.keyName == "a" or event.keyName == "d" then
            animation_counter = 0
            current_frame = 1
            man_stand_img.isVisible = true
            for _, img in ipairs(man_images) do
                img.isVisible = false
            end
            man_img.rotation = 0
            man_img.xScale = 1
        end
    end
    return true
end

-- Runtime event listeners (unchanged)
Runtime:addEventListener("key", onKeyEvent)

-- Function to update animation and movement with Flux
local function updateAnimation(dt)
    if key_states.a or key_states.d then
        if animation_counter >= ANIMATION_DELAY then
            animation_counter = 0
            current_frame = current_frame % #man_images + 1
        end

        man_stand_img.isVisible = false
        for i, img in ipairs(man_images) do
            img.isVisible = (i == current_frame)
            img.x = man_img.x
            img.y = man_img.y
            img.xScale = is_flipped and -1 or 1
        end

        animation_counter = animation_counter + 1

        -- Move man_img with Flux
        local move_distance = MOVE_SPEED * dt
        if is_flipped then
            flux.to(man_img, 0.1, { x = man_img.x - move_distance })
        else
            flux.to(man_img, 0.1, { x = man_img.x + move_distance })
        end
    else
        -- Reset to stand position
        man_stand_img.isVisible = true
        for _, img in ipairs(man_images) do
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
