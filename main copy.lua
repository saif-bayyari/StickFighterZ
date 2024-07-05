-- Constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local FPS = 60

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

-- Group all images in a table for easy access
local man_images = { man_run1_img, man_run2_img, man_run3_img }
for _, img in ipairs(man_images) do
    img.isVisible = false
end
man_stand_img.isVisible = true

-- Initial setup
local man_img = man_stand_img
man_img.x = SCREEN_WIDTH / 2
man_img.y = SCREEN_HEIGHT / 2

local is_flipped = false  -- Track if image is flipped horizontally
local ANIMATION_DELAY = 5  -- Frames per image
local animation_counter = 0
local current_frame = 1  -- Start with first running frame

-- Function to handle key events
local function onKeyEvent(event)
    if event.phase == "down" then
        if event.keyName == "a" then
            is_flipped = true
        elseif event.keyName == "d" then
            is_flipped = false
        end
    elseif event.phase == "up" then
        -- Reset animation when keys are released
        if event.keyName == "d" or event.keyName == "a" then
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
end

-- Runtime event listeners
Runtime:addEventListener("key", onKeyEvent)

-- Function to update animation
local function updateAnimation()
    if animation_counter >= ANIMATION_DELAY then
        animation_counter = 0
        current_frame = current_frame % #man_images + 1  -- Cycle through frames 1, 2, 3
    end

    -- Update the image based on current frame and direction
    man_stand_img.isVisible = false
    for i, img in ipairs(man_images) do
        img.isVisible = (i == current_frame)
        img.x = man_stand_img.x
        img.y = man_stand_img.y
        img.xScale = is_flipped and -1 or 1
    end

    -- Increment animation counter
    animation_counter = animation_counter + 1
end

-- Function to update the game state
local function update(event)
    updateAnimation()
end

-- Event listener for enterFrame event
Runtime:addEventListener("enterFrame", update)

-- Return scene
return scene
