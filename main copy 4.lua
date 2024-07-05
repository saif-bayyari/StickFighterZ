-- Constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local FPS = 60
local MAN_WIDTH = 200  -- Desired width of the man images
local MAN_HEIGHT = 200  -- Desired height of the man images
local MOVE_SPEED = 10 -- Speed in pixels per second
flux = require "flux"


---------------------------------------------------------

-- Function to handle button touch events
local function onButtonTouch(event)
    if event.phase == "began" then
        print("Button touched!")
        -- Insert the code you want to trigger when the button is touched
    end
    return true  -- Prevents touch propagation to underlying objects
end

-- Create a button using a rectangle
local button = display.newRect(-500, 525, 175, 175)  -- Adjusted for a better centered position within the button
button:setFillColor(0.2, 0.5, 0.8)  -- Set the button color
button.anchorX = 0
button.anchorY = 0

-- Create a label for the button
local buttonText = display.newText({
    text = "<=",
    x = button.x + button.width / 2,  -- Centered horizontally within the buttonad
    y = button.y + button.height / 2,  -- Centered vertically within the button
    font = native.systemFontBold,
    fontSize = 50
})
buttonText:setFillColor(1, 1, 1)  -- Set the text color
buttonText.anchorX = 0.5
buttonText.anchorY = 0.5

-- Add touch event listener to the button
button:addEventListener("touch", onButtonTouch)


------------------------------------------------------------------------------------------------
















-- Initialize Solar2D
display.setStatusBar(display.HiddenStatusBar)
display.setDefault("background", 1, 1, 1)
local composer = require("composer")
local scene = composer.newScene()

-- Load images
local image_path = "man/"  -- Adjust this to the actual relative path to your images directory
local man_stand_img = display.newImage(image_path .. "man-stand.png")
local man_run1_img = display.newImage(image_path .. "man-run1.png")
local man_run2_img = display.newImage(image_path .. "man-run2.png")
local man_run3_img = display.newImage(image_path .. "man-run3.png")

-- Scale the images to the desired size
local function scaleImage(image)
    image.width = MAN_WIDTH
    image.height = MAN_HEIGHT
end

scaleImage(man_stand_img)
scaleImage(man_run1_img)
scaleImage(man_run2_img)
scaleImage(man_run3_img)

-- Group all images in a table for easy access
local man_images = { man_run1_img, man_run2_img, man_run3_img }
for _, img in ipairs(man_images) do
    img.isVisible = false
end
man_stand_img.isVisible = true

-- Initial setup
local man_img = man_stand_img
--man_img.x = SCREEN_WIDTH / 2
man_img.x = -450
man_img.y = (SCREEN_HEIGHT / 2) + 50

local is_flipped = false  -- Track if image is flipped horizontally
local ANIMATION_DELAY = 2  -- Frames per image
local animation_counter = 0
local current_frame = 1  -- Start with first running frame
local is_running = false  -- Flag to check if running






-- Track key states
local key_states = {
    a = false,
    d = false
}

-- Function to handle key events
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

-- Runtime event listeners
Runtime:addEventListener("key", onKeyEvent)

-- Function to update animation
local function updateAnimation()
    if key_states.a or key_states.d then
        if animation_counter >= ANIMATION_DELAY then
            animation_counter = 0
            current_frame = current_frame % #man_images + 1  -- Cycle through frames 1, 2, 3
            
            if is_flipped then
                man_img.x = man_img.x - 100
            else 
                man_img.x = man_img.x + 100
            end
            
        
        end

        man_stand_img.isVisible = false
        for i, img in ipairs(man_images) do
            img.isVisible = (i == current_frame)
            img.x = man_stand_img.x
            img.y = man_stand_img.y
            img.xScale = is_flipped and -1 or 1
        end

        animation_counter = animation_counter + 1



        
        if is_flipped then
            --man_img.x = man_img.x - move_distance
            flux.to(man_img, 0.5, { x = man_img.x - MOVE_SPEED, y = man_img.y})
        else
           -- man_img.x = man_img.x + move_distance

           flux.to(man_img, 0.5, { x = man_img.x + MOVE_SPEED, y = man_img.y})
        end




    else
        man_stand_img.isVisible = true
        for _, img in ipairs(man_images) do
            img.isVisible = false
        end
    end
end
local previous_time = system.getTimer()
-- Function to update the game state
local function update(event)
   
    local current_time = system.getTimer()
    local dt = (current_time - previous_time) / 1000  -- Delta time in seconds
    previous_time = current_time
    flux.update(dt)
    updateAnimation()
end
-- Event listener for enterFrame event
Runtime:addEventListener("enterFrame", update)

-- Return scene
return scene