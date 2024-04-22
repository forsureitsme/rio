local ret = ... or {}

ret.Redir = function(sButton, sElement)
	if sElement:find('Body') == nil and sElement:find('Bottomcap') == nil then
		if sButton == "UpRight" 	then sButton = "UpLeft" end
		if sButton == "DownRight" 	then sButton = "DownLeft" end
	end
	--
	if sElement == "Tap Fake" 					then sElement = "Tap Note" end
	if sElement == "Tap Lift"					then sElement = "Tap Note" end
	if sElement == "Hold Head Active" 			then sElement = "Tap Note" end
	if sElement == "Hold Head Inactive" 		then sElement = "Tap Note" end
	if sElement == "Hold Body Inactive" 		then sElement = "Hold Body Active" end
	if sElement == "Hold Bottomcap Inactive" 	then sElement = "Hold Bottomcap Active" end
	if sElement == "Roll Head Inactive"	 		then sElement = "Roll Head Active" end
	if sElement == "Roll Body Inactive" 		then sElement = "Roll Body Active" end
	if sElement == "Roll Bottomcap Inactive" 	then sElement = "Roll Bottomcap Active" end
	--
	if sElement == "Explosion"
	or sElement == "Tap Mine"
	or sElement == "Receptor"
	-- or sElement == "Roll Head Active"
	then
		sButton = "UpLeft"
	end
	--
	return sButton, sElement;
end

ret.Rotate =
{
	["Center"]    = 0;
	["UpLeft"]    = 0;
	["UpRight"]   = 180;
	["DownLeft"]  = 0;
	["DownRight"] = 180;
};

ret.PartsToRotate =
{
	["Tap Note"]         = true;
	["Receptor"]         = true;
	["Roll Head Active"] = true;
};

ret.Blank =
{
	["Hold Topcap Active"]   = true;
	["Hold Topcap Inactive"] = true;
	["Roll Topcap Active"]   = true;
	["Roll Topcap Inactive"] = true;
	["Hold Tail Active"]     = true;
	["Hold Tail Inactive"]   = true;
	["Roll Tail Active"]     = true;
	["Roll Tail Inactive"]   = true;
};

local function func()
	local sButton = Var "Button";
	local sElement = Var "Element";

	if ret.Blank[sElement] then
		-- Return a blank element.  If SpriteOnly is set,
		-- we need to return a sprite; otherwise just return
		-- a dummy actor.
		local t;
		if Var "SpriteOnly" then
			t = LoadActor( "_blank" );
		else
			t = Def.Actor {};
		end
		return t .. {
			cmd(visible,false);
		};
	end

	local sButtonToLoad, sElementToLoad = ret.Redir(sButton, sElement);
	-- Cannot rotate these, load the right actors then
	if sElementToLoad == "Hold Body Active"
	or sElementToLoad == "Hold Bottomcap Active"
	then
		sButtonToLoad = sButton
	end

	assert( sButtonToLoad );
	assert( sElementToLoad );

	local t = LoadActor( NOTESKIN:GetPath( sButtonToLoad, sElementToLoad ) );

	if ret.PartsToRotate[sElementToLoad] and ret.Rotate[sButton] ~= 0 then
		t.BaseRotationY = ret.Rotate[sButton];
	end


	return t;
end

-- This is the only required function.
ret.Load = func;

-- Use this to override the game types' default Load() functions.
ret.CommonLoad = func;

return ret;