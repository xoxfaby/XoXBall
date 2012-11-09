
---------- World Generation

world = love.physics.newWorld( 0, 10 * 100, false )
currentworld = world

---------- Level Parameters

love.graphics.setCaption("Game")
lvljumps = 2
jumpsleft = lvljumps
lvlPoly = 10





---------- Objects

	
objects = {}

---- Ball 

objects.ball = {}
objects.ball.body = love.physics.newBody(world, 200, 600, "dynamic")
objects.ball.shape = love.physics.newCircleShape(30)
objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 0)
objects.ball.fixture:setRestitution( 0.1 )
currentball = objects.ball

---- World

objects.block1 = {}
objects.block1.body = love.physics.newBody(world, 800, 850 )
objects.block1.shape = love.physics.newRectangleShape( 10000, 100 )
objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape)
	
objects.block2 = {}
objects.block2.body = love.physics.newBody(world, 1450, 700 )
objects.block2.shape = love.physics.newRectangleShape( 100, 300 )
objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape)

hitBodies = world:getBodyList()
---- Dynamic



----

	love.graphics.setBackgroundColor( 75, 171, 245 )

function updateLevel()
if love.keyboard.isDown("m") then
endLevel(level2)
end
end
	
function drawLevel()

	love.graphics.setColor(180,0 , 0)
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

	love.graphics.setColor(0, 160, 0)
	love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))
	
	love.graphics.setColor(0, 160, 0)
	love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
end
