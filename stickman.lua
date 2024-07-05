-- Stickman class definition
local Stickman = {}
Stickman.__index = Stickman

-- Constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local MAN_WIDTH = 200  -- Desired width of the man images
local MAN_HEIGHT = 200  -- Desired height of the man images
local MOVE_SPEED = 200 -- Speed in pixels per second
local ANIMATION_DELAY = 5  -- Frames per image

local flux = require "flux"

-- Constructor
function Stickman.new()
    local self = setmetatable({}, Stickman)

    -- Load images
    local image_path = "man/"
    self.man_stand_img = display.newImage(image_path .. "man-stand.png")
    self.man_run1_img = display.newImage(image_path .. "man-run1.png")
    self.man_run2_img = display.newImage(image_path .. "man-run2.png")
    self.man_run3_img = display.newImage(image_path .. "man-run3.png")

    -- Scale the images
    self:scaleImage(self.man_stand_img)
    self:scaleImage(self.man_run1_img)
    self:scaleImage(self.man_run2_img)
    self:scaleImage(self.man_run3_img)

    -- Group all images in a table for easy access
    self.man_images = { self.man_run1_img, self.man_run2_img, self.man_run3_img }
    for _, img in ipairs(self.man_images) do
        img.isVisible = false
    end
    self.man_stand_img.isVisible = true

    -- Initial setup
    self.man_img = self.man_stand_img
    self.man_img.x = -450
    self.man_img.y = (SCREEN_HEIGHT / 2) + 50

    self.is_flipped = false  -- Track if image is flipped horizontally
    self.animation_counter = 0
    self.current_frame = 1  -- Start with first running frame

    return self
end

-- Method to scale an image
function Stickman:scaleImage(image)
    image.width = MAN_WIDTH
    image.height = MAN_HEIGHT
end

-- Method to update animation and movement
function Stickman:updateAnimation(dt)
    if self.animation_counter >= ANIMATION_DELAY then
        self.animation_counter = 0
        self.current_frame = self.current_frame % #self.man_images + 1
    end

    self.man_stand_img.isVisible = false
    for i, img in ipairs(self.man_images) do
        img.isVisible = (i == self.current_frame)
        img.x = self.man_img.x
        img.y = self.man_img.y
        img.xScale = self.is_flipped and -1 or 1
    end

    self.animation_counter = self.animation_counter + 1

    -- Move man_img with Flux
    local move_distance = MOVE_SPEED * dt
    if self.is_flipped then
        flux.to(self.man_img, 0.1, { x = self.man_img.x - move_distance })
    else
        flux.to(self.man_img, 0.1, { x = self.man_img.x + move_distance })
    end
end

-- Method to handle key events (removed from here)

-- Method to update the game state
function Stickman:update(dt)
    flux.update(dt)  -- Update Flux with delta time
    self:updateAnimation(dt)
end

-- Cleanup method (if needed)
function Stickman:destroy()
    -- Clean up images or any other resources if necessary
end

return Stickman
