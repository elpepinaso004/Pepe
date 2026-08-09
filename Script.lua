

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Estados
local movementEnabled = true
local bodyFrozen = false

-- Referencias a la GUI (ajusta los nombres según tu jerarquía real)
local gui = player:WaitForChild("PlayerGui"):WaitForChild("MovementGui")
local toggleMoveButton = gui:WaitForChild("ToggleMoveButton")
local freezeBodyButton = gui:WaitForChild("FreezeBodyButton")

-- Guardamos la velocidad original para restaurarla luego
local ORIGINAL_WALKSPEED = humanoid.WalkSpeed
local ORIGINAL_JUMPPOWER = humanoid.JumpPower

------------------------------------------------
-- BOTÓN: Encender / Apagar movimiento
------------------------------------------------
toggleMoveButton.MouseButton1Click:Connect(function()
	movementEnabled = not movementEnabled

	if movementEnabled then
		humanoid.WalkSpeed = ORIGINAL_WALKSPEED
		humanoid.JumpPower = ORIGINAL_JUMPPOWER
		toggleMoveButton.Text = "Movimiento: ON"
	else
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		toggleMoveButton.Text = "Movimiento: OFF"
	end
end)

------------------------------------------------
-- BOTÓN: Congelar torso pero dejar libres las piernas
-- (útil para mecánicas tipo "atrapado en barro/arena movediza")
------------------------------------------------
freezeBodyButton.MouseButton1Click:Connect(function()
	bodyFrozen = not bodyFrozen

	if bodyFrozen then
		-- Ancla la parte raíz para que el cuerpo no se traslade,
		-- pero el Humanoid sigue procesando la animación de piernas
		rootPart.Anchored = true
		freezeBodyButton.Text = "Cuerpo: Congelado"
	else
		rootPart.Anchored = false
		freezeBodyButton.Text = "Cuerpo: Libre"
	end
end)

------------------------------------------------
-- Reasignar referencias si el personaje respawnea
------------------------------------------------
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")

	ORIGINAL_WALKSPEED = humanoid.WalkSpeed
	ORIGINAL_JUMPPOWER = humanoid.JumpPower

	movementEnabled = true
	bodyFrozen = false
	toggleMoveButton.Text = "Movimiento: ON"
	freezeBodyButton.Text = "Cuerpo: Libre"
end)
