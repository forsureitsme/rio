local pieces = {

	upleft = {
		croptop = 0;
		cropbottom = .66;
		cropleft = 0;
		cropright = .66;
		wind = -10;
	};

	up = {
		croptop = 0;
		cropbottom = .66;
		cropleft = .33;
		cropright = .33;
		wind = math.random(-5,5);
	};

	upright = {
		croptop = 0;
		cropbottom = .66;
		cropleft = .66;
		cropright = 0;
		wind = 10;
	};

	left = {
		croptop = .33;
		cropbottom = .33;
		cropleft = 0;
		cropright = 0.66;
		wind = -10;
	};

	center = {
		croptop = .33;
		cropbottom = .33;
		cropleft = .33;
		cropright = .33;
		wind = math.random(-5,5);
	};

	right = {
		croptop = .33;
		cropbottom = .33;
		cropleft = .66;
		cropright = 0;
		wind = 10;
	};

	downleft = {
		croptop = .66;
		cropbottom = 0;
		cropleft = 0;
		cropright = .66;
		wind = -10;
	};

	down = {
		croptop = .66;
		cropbottom = 0;
		cropleft = .33;
		cropright = .33;
		wind = math.random(-5,5);
	};

	downright = {
		croptop = .66;
		cropbottom = 0;
		cropleft = .66;
		cropright = 0;
		wind = 10;
	};

};

local t = Def.ActorFrame{};

for key,piece in pairs(pieces) do
	-- Rotating the actor also rotates wind, so:
	if Var "Button" == 'UpRight'
	or Var "Button" == 'DownRight'
	then
		piece.wind = -piece.wind;
	end
	--

	t[#t+1] = NOTESKIN:LoadActor(Var "Button", "Tap Note")..{
		InitCommand=cmd(
			-- animate,false;
			-- setstate,3;
			diffusealpha,0;
			croptop,piece.croptop;
			cropbottom,piece.cropbottom;
			cropleft,piece.cropleft;
			cropright,piece.cropright;
		);
		W1Command=cmd(playcommand,"Crack");
		W2Command=cmd(playcommand,"Crack");
		W3Command=cmd(playcommand,"Crack");
		W4Command=cmd();
		W5Command=cmd();

		--HitMineCommand=cmd(playcommand,"Crack");
		--HeldCommand=cmd(playcommand,"Crack");
		CrackCommand=function(self)
			(cmd(
				finishtweening;
				y,0;
				rotationx,0;
				rotationy,0;
				rotationz,0;
				diffusealpha,1;

				decelerate,.2;

				y,-45;
				rotationz,math.random(0,90);

				accelerate,.2;

				y,-10;
				diffusealpha,0;
				rotationz,90;
			))(self);
			(cmd(
				x,piece.wind * 2;
				linear,4;
				x,0;
			))(self);
		end
	};
end;

	--explosion
t[#t+1] = Def.Sprite{
 	Texture=NOTESKIN:GetPath( 'Explosion', 'Spark' );
	InitCommand=cmd(blend,"BlendMode_Add";pause;diffusealpha,0);
	W1Command=cmd(playcommand,"NewExplosion");
	W2Command=cmd(playcommand,"NewExplosion");
	W3Command=cmd(playcommand,"NewExplosion");
	HoldingOnCommand=cmd(playcommand,"NewExplosion");
	-- HitMineCommand=cmd(playcommand,"NewExplosion");
	HeldCommand=cmd(playcommand,"NewExplosion");
	
	NewExplosionCommand=function(self)
		self:finishtweening();
		self:rotationz(math.random(0,360));
		self:aux(0);
		self:playcommand("Advance");
	end;

	AdvanceCommand=function(self)
		if self:getaux() < self:GetNumStates()-1 then
			self:queuecommand("Advance");
		else
			self:diffusealpha(0);
			return;
		end

		self:aux(self:getaux()+1);
		self:setstate(self:getaux());
		self:diffusealpha(1);
		self:linear(0.01);
	end;
};


t[#t+1] = Def.Sprite{
	Texture=NOTESKIN:GetPath( 'Explosion', 'Glow' );
	InitCommand=cmd(
		blend,"BlendMode_Add";
		diffusealpha,0;
	);
	W1Command=cmd(playcommand,"Glow");
	W2Command=cmd(playcommand,"Glow");
	W3Command=cmd(playcommand,"Glow");
	HoldingOnCommand=cmd(playcommand,"Glow");
	HeldCommand=cmd(playcommand,"Glow");
	GlowCommand=cmd(
		finishtweening;
		rotationz,math.random(0,360);
		zoom,.9;
		diffusealpha,1;
		decelerate,.3;
		diffusealpha,0;
		zoom,.75;
	);
};


return t;