EffectManager_C = inherit(Singleton)

function EffectManager_C:constructor()

	self.singleEffects = {}
	self.massEffects = {}
	self.currentTime = 0
	
	self:initManager()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("EffectManager_C was started.")
	end
end


function EffectManager_C:initManager()
	self.m_AddEffect = bind(self.addEffect, self)
	self.m_AddMassEffects = bind(self.addMassEffects, self)
	self.m_DeleteMassEffects = bind(self.deleteMassEffects, self)

	addEvent("DOCLIENTEFFECT", true)
	addEventHandler("DOCLIENTEFFECT", root, self.m_AddEffect)
	
	addEvent("DOCLIENTMASSEFFECT", true)
	addEventHandler("DOCLIENTMASSEFFECT", root, self.m_AddMassEffects)
	
	addEvent("DELETECLIENTMASSEFFECT", true)
	addEventHandler("DELETECLIENTMASSEFFECT", root, self.m_DeleteMassEffects)
end


function EffectManager_C:addEffect(effectSettings)
	if (effectSettings) then
		local id = self:getFreeEffectID()
		
		if (not self.singleEffects[id]) then
			self.singleEffects[id] = {}
			self.singleEffects[id].effect = createEffect(effectSettings.name, effectSettings.x, effectSettings.y, effectSettings.z, effectSettings.rx, effectSettings.ry, effectSettings.rz, 100)
			self.singleEffects[id].start = getTickCount()
			self.singleEffects[id].duration = effectSettings.duration
		end
	end
end


function EffectManager_C:addMassEffects(effectsTable)
	if (effectsTable) then
		if (effectsTable.id) and (effectsTable.effects) and (effectsTable.name) then
			if (not self.massEffects[effectsTable.id]) then
				self.massEffects[effectsTable.id] = {}
				
				for index, effect in pairs(effectsTable.effects) do
					if (effect) then
						self.massEffects[effectsTable.id][index] = createEffect(effectsTable.name, effect.x, effect.y, effect.z, 0, 0, 0, 100)
					end
				end
			end
		end
	end
end


function EffectManager_C:deleteMassEffects(id)
	if (id) then
		if (self.massEffects[id]) then
			for index, effect in pairs(self.massEffects[id]) do
				if (isElement(effect)) then
					effect:destroy()
					effect = nil
				end
			end
			
			self.massEffects[id] = nil
		end
	end
end


function EffectManager_C:update(delta)
	self.currentTime = getTickCount()
	
	for index, effectSlot in pairs(self.singleEffects) do
		if (effectSlot) then
			if (effectSlot.start) and (effectSlot.duration) then
				if (self.currentTime > effectSlot.start + effectSlot.duration) then
					if (effectSlot.effect) then
						if (isElement(effectSlot.effect)) then
							effectSlot.effect:destroy()
							effectSlot.effect = nil
							effectSlot = nil
						end
					end
				end
			end
		end
	end
end


function EffectManager_C:getFreeEffectID()
	for index, effectSlot in pairs(self.singleEffects) do
		if (not effectSlot) then
			return index
		end
	end
	
	return #self.singleEffects + 1
end


function EffectManager_C:clear()
	removeEventHandler("DOCLIENTEFFECT", root, self.m_AddEffect)
	removeEventHandler("DOCLIENTMASSEFFECT", root, self.m_AddMassEffects)
	removeEventHandler("DELETECLIENTMASSEFFECT", root, self.m_DeleteMassEffects)
	
	for index, effectSlot in pairs(self.singleEffects) do
		if (effectSlot) then
			if (effectSlot.effect) then
				if (isElement(effectSlot.effect)) then
					effectSlot.effect:destroy()
					effectSlot.effect = nil
					effectSlot = nil
				end
			end
		end
	end
	
	
	for id, massEffect in pairs(self.massEffects) do
		if (massEffect) then
			for index, effect in pairs(massEffect) do
				if (isElement(effect)) then
					effect:destroy()
					effect = nil
				end
			end
			
			massEffect = nil
		end
	end
	
	sendMessage("EffectManager_C was deleted.")
end


function EffectManager_C:destructor()
	self:clear()
	
	if (Settings.showManagerDebugInfo == true) then
		sendMessage("EffectManager_C was deleted.")
	end
end
