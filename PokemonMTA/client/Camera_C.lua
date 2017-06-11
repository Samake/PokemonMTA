--[[
	Filename: Camera_C.lua
	Authors: Sam@ke
--]]

Camera_C = {}

function Camera_C:constructor(parent)

	self.coreClass = parent
	
	self.player = getLocalPlayer()
	
	self.isRotatingCamera = false
	
	self.x = 0
	self.y = 0
	self.z = 0
	self.lx = 0
	self.ly = 0
	self.lz = 0
	self.distance = 0
	self.angle = 0
	self.height = 0
	self.speed = 0
			
	self:init()
	
	mainOutput("Camera_C was started.")
end


function Camera_C:init()
	self.m_RotateCamera = bind(self.rotateCamera, self)
	self.m_ResetCamera = bind(self.resetCamera, self)
	
	addEvent("CLIENTROTATECAMERA", true)
	addEventHandler("CLIENTROTATECAMERA", root, self.m_RotateCamera)
	
	addEvent("CLIENTRESETCAMERA", true)
	addEventHandler("CLIENTRESETCAMERA", root, self.m_ResetCamera)
	
	self:resetCamera()
end


function Camera_C:update(delta)
	if (self.isRotatingCamera == true) then
		self.angle = (self.angle + self.speed)%360
		self.x, self.y, self.z = getAttachedPosition(self.lx, self.ly, self.lz, 0, 0, 0, self.distance, self.angle, self.height)
		setCameraMatrix(self.x, self.y, self.z, self.lx, self.ly, self.lz)
	end
end


function Camera_C:rotateCamera(cameraSettings)
	if (cameraSettings) then
		self.lx = cameraSettings.lookAtX
		self.ly = cameraSettings.lookAtY
		self.lz = cameraSettings.lookAtZ
		self.distance = cameraSettings.distance
		self.angle = 0
		self.height = cameraSettings.height
		self.speed = cameraSettings.speed
		
		self.isRotatingCamera = true
	end
end 


function Camera_C:resetCamera()
	if (self.player) then
		if (isElement(self.player)) then
			setCameraTarget(self.player)
			self.isRotatingCamera = false
		end
	end
end


function Camera_C:clear()
	removeEventHandler("CLIENTROTATECAMERA", root, self.m_RotateCamera)
	removeEventHandler("CLIENTRESETCAMERA", root, self.m_ResetCamera)
end


function Camera_C:destructor()
	self:clear()
	
	mainOutput("Camera_C was deleted.")
end
