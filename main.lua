function love.load()
gamestate = "menu"
menuitem = 0
menuitems = 3

points = {}
gameFont = love.graphics.newFont(20)
menuFont = love.graphics.newFont(60)
love.graphics.setFont(menuFont)
secondspassed = 0
jumped = false
lvljumps = 1
jumpsleft = lvljumps
lvlPoly = 12
NextPoint = 1
love.graphics.setCaption("Game")
love.graphics.setMode( 1600, 900, false, true, 2 )
love.physics.setMeter(100)

PolyCreate = false
polys = {}
polyCount = 0

level1 = love.filesystem.load( "level1.lua" )
level2 = love.filesystem.load( "level2.lua" )

level1()
hitBodies = {}
skipCreate = false

end

function drawLevel() end
function updateLevel() end

function endLevel(nextLevel)
world:destroy()

----

objects = {}
polys = {}
points = {}
hitBodies = {}

---

polyCount = 0
NextPoint = 1
PolyCreate = false

---


drawLevel = function() end
updateLevel = function() end

---
---

nextLevel()
end

function love.update(dt)
if gamestate == "menu" then
if menuitem >= menuitems then
menuitem = 0
elseif menuitem < 0 then
menuitem = menuitems - 1
end

elseif gamestate == "game" then

skipCreate = false

if currentworld ~= nil then
	currentworld:update(dt)
end

--------- Movement


linvelx, linvely = currentball.body:getLinearVelocity()
if linvelx > 500 then currentball.body:setLinearVelocity( 500 , linvely) end
if linvelx < -500 then currentball.body:setLinearVelocity( -500 , linvely ) end


--- Jump




--------- Keys

if love.keyboard.isDown("right") then
	currentball.body:applyForce( 800, 0)
  
	end
if love.keyboard.isDown("left") then
	currentball.body:applyForce( -800 , 0)
end
if jumped then
	secondspassed = secondspassed + dt
end
jumpdelay()



updateLevel()

else
gamestate = "menu"
end
end


function love.keypressed(key)

if gamestate == "menu" then
	if key == "escape" then
		love.event.push("quit")
	end
	if key == "up" then
		menuitem = menuitem - 1
	end
	if key == "down" then
		menuitem = menuitem + 1
	end
	if key == "return" then
		if menuitem == 0 then
		gamestate = "game"
		elseif menuitem == 1 then
		
		elseif menuitem == 2 then
		love.event.push("quit")
		end
	end
elseif gamestate == "game" then
	if key == "escape" then
		gamestate = "menu"
	end
	
	if key == "backspace" then
	if PolyCreate == true then
	if points ~= {} then
	table.remove(points, #points)
	NextPoint = NextPoint - 1
	if NextPoint == 1 then
	points = {}
    PolyCreate = false
	end
	end
	end
	end
	
	if key == "r" then
	PolyCreate = false
	points = {}
	NextPoint = 1
	polyCount = 0
	for i = 1 ,#polys do
	polys[i].fixture:destroy()
	polys[i].body:destroy()
	end
	polys = {}
	end
	
	if key == "up" then
	if jumpsleft > 0 then
		currentball.body:applyForce( 0, -10000 )
		secondspassed = 0
		jumped = true
		jumpsleft = jumpsleft - 1
	end
	end
end
end


function jumpdelay()
if secondspassed > 1 then
jumpsleft = lvljumps
jumped = false
end


end

function love.mousepressed(x, y, button)

	if gamestate == "menu" then
		
	elseif gamestate == "game" then
		
		newpoint = {}
		newpoint.x , newpoint.y = x, y 
		
		if polyCount < lvlPoly then
		
		--[[
			if #points > 2 and points[1].x  + 10 > newpoint.x and points[1].x - 10 < newpoint.x and points[1].y + 10 > newpoint.y and points[1].y - 10 < newpoint.y then
				points[NextPoint] = {}
				points[NextPoint].x, points[NextPoint].y = newpoint.x , newpoint.y
				createPoly()
				NextPoint = 1
				PolyCreate = false
				points = {}
			elseif NextPoint == 4 and points[3].x  + 10 > newpoint.x and points[3].x - 10 < newpoint.x and points[3].y + 10 > newpoint.y and points[3].y - 10 < newpoint.y then
				createPoly()
				NextPoint = 1
				PolyCreate = false
				points = {} 
				
				]]--
		
			hitWorld = false
		
			for i = 1 , #hitBodies do
				if hitBodies[i].getFixtureList()[1].getShape().getType() == "polygon" then
					bodyx, bodyy ,bodyx2, bodyy2= hitBodies[i].getFixtureList()[1].getShape():getPoints()
					if bodyx  - 10 > newpoint.x and bodyx2 + 10 < newpoint.x and bodyy - 10 > newpoint.y and bodyy2 + 10 < newpoint.y then
						hitWorld = true
					end
				end
			end
			
			
			ballx, bally = currentball.body:getPosition()
			
			for i = 1, NextPoint - 1, 1 do
				if 	ballx  + 40 > newpoint.x and ballx - 40 < newpoint.x and bally + 40 > newpoint.y and bally - 40 < newpoint.y or hitWorld == true then
					hitWorld = true
				end
			end
		
		
			if hitWorld == false then
			
				if NextPoint == 3 then
					for i = 1, NextPoint - 1, 1 do
						if points[i].x  + 10 > newpoint.x and points[i].x - 10 < newpoint.x and points[i].y + 10 > newpoint.y and points[i].y - 10 < newpoint.y or 
							ballx  + 40 > newpoint.x and ballx - 40 < newpoint.x and bally + 40 > newpoint.y and bally - 40 < newpoint.y or hitWorld == true then
							skipCreate = true	
						end
					end
					
					if skipCreate == false then
						points[NextPoint] = {}
						points[NextPoint].x, points[NextPoint].y = newpoint.x , newpoint.y
						createPoly()
						NextPoint = 1
						PolyCreate = false
						points = {}
					end
					
				elseif NextPoint < 4  then
					if NextPoint ~= 0 then
						PolyCreate = true
						points[NextPoint] = {}
						points[NextPoint].x, points[NextPoint].y = newpoint.x , newpoint.y
					end
				end
				NextPoint = NextPoint + 1
			end
		end
	end
end

function orderCW(pointTable)
	newpoints = {}
	if #pointTable == 3 then
		xpoints = {}
		ypoints = {}
		for i = 1 , #points do
			xpoints[#xpoints + 1] = pointTable[i].x
			ypoints[#ypoints + 1] = pointTable[i].y
		end
		for i = 1, #ypoints do
			if ypoints[i] == math.min(unpack(ypoints)) then
				table.insert(newpoints, 1, pointTable[i])
				table.remove(ypoints, i)
				table.remove(xpoints, i)
				table.remove(pointTable, i)
				break
			end
		end
		for i = 1, #xpoints do
			if xpoints[i] == math.min(unpack(xpoints)) then
				table.insert(newpoints, 2, pointTable[i])
				table.remove(ypoints, i)
				table.remove(xpoints, i)
				table.remove(pointTable, i)
				break
			end
		end
		for i = 1, #xpoints do
			if xpoints[i] == math.max(unpack(xpoints)) then
				table.insert(newpoints, 3, pointTable[i])
				table.remove(ypoints, i)
				table.remove(xpoints, i)
				table.remove(pointTable, i)
				break
			end
		end
		return newpoints
	elseif #points == 4 then
xpoints = {}
ypoints = {}
for i = 1 , #points do
xpoints[#xpoints + 1] = pointTable[i].x
ypoints[#ypoints + 1] = pointTable[i].y
end
for i = 1, #ypoints do
if ypoints[i] == math.min(unpack(ypoints)) then
table.insert(newpoints, 1, pointTable[i])
table.remove(ypoints, i)
table.remove(xpoints, i)
table.remove(pointTable, i)
break
end
end
for i = 1, #ypoints do
if ypoints[i] == math.max(unpack(ypoints)) then
table.insert(newpoints, 3, pointTable[i])
table.remove(ypoints, i)
table.remove(xpoints, i)
table.remove(pointTable, i)
break
end
end
for i = 1, #xpoints do
if xpoints[i] == math.min(unpack(xpoints)) then
table.insert(newpoints, 2, pointTable[i])
table.remove(ypoints, i)
table.remove(xpoints, i)
table.remove(pointTable, i)
break
end
end
for i = 1, #xpoints do
if xpoints[i] == math.max(unpack(xpoints)) then
table.insert(newpoints, 4, pointTable[i])
table.remove(ypoints, i)
table.remove(xpoints, i)
table.remove(pointTable, i)
break
end
end
return newpoints
end
end



function createPoly()
points = orderCW(points)
newpolypoints = {}
for  i = 1, table.getn(points) do
newpolypoints[#newpolypoints + 1] = points[i].x
newpolypoints[#newpolypoints + 1] = points[i].y
end
newNr = table.getn(polys) + 1
polys[newNr] = {}
polys[newNr].body = love.physics.newBody(world,  0 , 0, "dynamic")
polys[newNr].shape = love.physics.newPolygonShape(unpack(newpolypoints))
polys[newNr].fixture = love.physics.newFixture(polys[newNr].body, polys[newNr].shape, 1)
polyCount = polyCount + 1
end

function love.draw()

if gamestate == "menu" then
love.graphics.setFont(menuFont)
if menuitem == 0 then
love.graphics.setColor( 229, 50, 50 )
else
love.graphics.setColor( 229, 235, 192 )
end
love.graphics.printf( "Resume game" , 0, 200 , 1600, "center")
if menuitem == 1 then
love.graphics.setColor( 229, 50, 50 )
else
love.graphics.setColor( 229, 235, 192 )
end
love.graphics.printf( "herpderp" , 800, 400 , 0, "center")
if menuitem == 2 then
love.graphics.setColor( 229, 50, 50 )
else
love.graphics.setColor( 229, 235, 192 )
end
love.graphics.printf( "Exit" , 800, 600 , 0, "center")

elseif gamestate == "game" then
love.graphics.setFont(gameFont)




if debugg ~= nil then
love.graphics.print( debugg , 100, 300 )
end

if PolyCreate == true then


love.graphics.setColor(255,255,255)
newdrawpoints = {}
for  i = 1, table.getn(points) do
newdrawpoints[#newdrawpoints + 1] = points[i].x
newdrawpoints[#newdrawpoints + 1] = points[i].y
end
newdrawpoints[#newdrawpoints + 1] = love.mouse.getX()
newdrawpoints[#newdrawpoints + 1] = love.mouse.getY()
love.graphics.line(unpack(newdrawpoints))
if #points >= 2 then
love.graphics.polygon("fill", unpack(newdrawpoints))
end

for  i = 1, table.getn(points) do
love.graphics.setColor( 249, 255, 212 )
love.graphics.circle("fill", points[i].x, points[i].y, 5)
end
love.graphics.print( "Creating Polygon" , 50, 100 )
end

love.graphics.setColor(255,255,255)
love.graphics.print( "Jumps: " .. jumpsleft .. "/" .. lvljumps , 50, 50 )
love.graphics.print( "Points: " .. polyCount .. "/" .. lvlPoly , 50, 75 )

if table.getn(polys) > 0 then
for i = 1 , table.getn(polys) do
love.graphics.setColor(245,245,245)
	love.graphics.polygon("fill", polys[i].body:getWorldPoints(polys[i].shape:getPoints()))
end
end

drawLevel()
end
end
