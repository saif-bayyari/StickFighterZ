-- Constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local MAN_WIDTH = 200  -- Desired width of the man images
local MAN_HEIGHT = 200  -- Desired height of the man images
local MOVE_SPEED = 0  -- Initialize MOVE_SPEED to 0 initially

local flux = require("flux")

local function scaleImage(image)
    image.width = MAN_WIDTH
    image.height = MAN_HEIGHT
end

local image_path = "man/"

Stickman = {}
Stickman.__index = Stickman

function Stickman:new(name, age)
    local instance = setmetatable({}, Stickman)
    instance.name = name
    instance.age = age
    instance.man_stand_img = display.newImage(image_path .. "man-stand.png")
    instance.man_run1_img = display.newImage(image_path .. "man-run1.png")
    instance.man_run2_img = display.newImage(image_path .. "man-run2.png")
    instance.man_run3_img = display.newImage(image_path .. "man-run3.png")
    scaleImage(instance.man_stand_img)
    scaleImage(instance.man_run1_img)
    scaleImage(instance.man_run2_img)
    scaleImage(instance.man_run3_img)
    instance.man_images = { instance.man_run1_img, instance.man_run2_img, instance.man_run3_img }
    for _, img in ipairs(instance.man_images) do
        img.isVisible = false
    end
    instance.man_stand_img.isVisible = true
    instance.is_flipped = false
    instance.ANIMATION_DELAY = 5
    instance.animation_counter = 0
    instance.current_frame = 1
    instance.MOVE_SPEED = MOVE_SPEED  -- Set MOVE_SPEED to 0 initially
    instance.spawnedIn = false

    return instance
end

function Stickman:spawn(x, y)
    local man_img = self.man_stand_img
    man_img.x = x
    man_img.y = y
    self.spawnedIn = true
end

function Stickman:update(dt)
    if self.MOVE_SPEED ~= 0 then
        if self.animation_counter >= self.ANIMATION_DELAY then
            self.animation_counter = 0
            self.current_frame = (self.current_frame % #self.man_images) + 1
        end

        self.man_stand_img.isVisible = false
        for i, img in ipairs(self.man_images) do
            img.isVisible = (i == self.current_frame)
            img.x = self.man_stand_img.x
            img.y = self.man_stand_img.y
            img.xScale = self.is_flipped and -1 or 1
        end

        self.animation_counter = self.animation_counter + 1

        -- Move man_img with Flux
        local move_distance = self.MOVE_SPEED * dt
        if self.is_flipped then
            flux.to(self.man_stand_img, 0.1, { x = self.man_stand_img.x - move_distance })
        else
            flux.to(self.man_stand_img, 0.1, { x = self.man_stand_img.x + move_distance })
        end
    else
        -- Reset to stand position
        self.man_stand_img.isVisible = true
        for _, img in ipairs(self.man_images) do
            img.isVisible = false
        end
    end
end

return Stickman


