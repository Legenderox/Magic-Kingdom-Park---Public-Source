local m = {}

           --/\--
         --//  \\--
       --//	    \\-- 
     --//		  \\--
   --//				\\--
 --//Made by Legenderox\\--
--[[====================]]--

-------------
--Variables--
-------------


-------------
--Functions--
-------------

function m.ClearViewportFrame(ViewportFrame)
	local ViewportChildren = ViewportFrame:GetChildren()
	for i = 1, #ViewportChildren do
		if not ViewportChildren[i]:IsA("GuiObject") then
			ViewportChildren[i]:Destroy()
		end
	end
end

function m.LoadViewportFrame(ViewportCamera, ViewportFrame, Handle) --Only Accepts baseparts
	m.ClearViewportFrame(ViewportFrame)
	
	Handle.Parent = ViewportFrame
	ViewportFrame.CurrentCamera = ViewportCamera
	ViewportCamera.CameraType = Enum.CameraType.Scriptable
end

function m.RunViewportFrame(ViewportPart, ViewportCamera, ViewportDistanceMultiplier, RX, RY)
	local Max = math.max(ViewportPart.Size.X, ViewportPart.Size.Y, ViewportPart.Size.Z)
	local Distance = (Max/math.tan(math.rad(ViewportCamera.FieldOfView))) * ViewportDistanceMultiplier
	Distance = (Max/2) + Distance
	ViewportCamera.CFrame = ViewportPart.CFrame:ToWorldSpace(CFrame.Angles(math.rad(RX), math.rad(RY), 0) * CFrame.new(Vector3.new(0, Distance*.8, Distance), Vector3.new(0,0,0)))
end

------------
--Triggers--
------------



-----------
--StartUp--
-----------

return m