local ver = ""
if ThemePrefs.Get("SV") == "onepointzero" then
  ver = "1_"
end

local t = Def.ActorFrame{
	Def.ActorFrame{
		OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(1) end,
		OffCommand=function(s) s:finishtweening():sleep(0.2):accelerate(0.2):diffusealpha(0) end,
		loadfile(THEME:GetPathB("","_Logo/default.lua"))()..{
			InitCommand=function(s) s:Center() end,
		};
		Def.Sprite{
			Texture=THEME:GetPathB("","_Logo/project_xxlogo.png"),
			InitCommand=function(s)
			  s:xy(_screen.cx+80,_screen.cy+16):blend(Blend.Add):diffusealpha(0):queuecommand("Anim")
			end,
			AnimCommand=function(s) s:diffusealpha(0):sleep(1):linear(0.75):diffusealpha(0.3):sleep(0.1):linear(0.4):diffusealpha(0):queuecommand("Anim") end,
			OffCommand=function(s) s:stoptweening() end,
		  };
		loadfile(THEME:GetPathB("","_Dancer/default.lua"))()..{
			InitCommand = function(s) s:xy(_screen.cx-540,_screen.cy+30) end,
		};
	}
}

if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then
--XXX: it's easier to have it up here

local heardBefore = false

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:zoom(1)
	end;
	Def.Sound{
		File=GetMenuMusicPath "title",
		OnCommand=function(s) s:play() end,
	};
	Def.Quad{
		InitCommand=function(s) s:FullScreen():diffuse(color("0,0,0,0")) end,
		OnCommand=function(s) s:decelerate(0.2):diffusealpha(0.75) end,
		OffCommand=function(s) s:accelerate(0.4):diffusealpha(0) end,
	};
	Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx-435,_screen.cy-10) end,
		OnCommand=function(s) s:addx(-SCREEN_WIDTH):sleep(0.2):decelerate(0.2):addx(SCREEN_WIDTH) end,
		OffCommand=function(s) s:linear(0.2):addx(-SCREEN_WIDTH) end,
		Def.Sprite{
			Texture=ver.."windowmid",
			TitleSelectionMessageCommand=function(self, params)
				self:finishtweening()
				if heardBefore then
					self:accelerate(0.1);
				else heardBefore = true end
				self:croptop(0.5):cropbottom(0.5):sleep(0.1):accelerate(0.2):croptop(0):cropbottom(0)
			end;
		};
		Def.Sprite{
			Name="ImageLoader";
			TitleSelectionMessageCommand=function(self, params)
				choice = string.lower(params.Choice)
				self:stoptweening()
				if heardBefore then
					self:accelerate(0.1);
				else heardBefore = true end
				self:croptop(0.5):cropbottom(0.5)
				self:queuecommand("TitleSelectionPart2")
			end;
			TitleSelectionPart2Command=function(self, params)
				self:Load(THEME:GetPathB("ScreenSelectMode","decorations/Images/"..choice))
				self:sleep(0.1)
				self:accelerate(0.2);
				self:croptop(0):cropbottom(0)
			end;
			OffCommand=function(s) s:accelerate(.4):croptop(0.5):cropbottom(0.5) end,
		};
		Def.Sprite{
			Texture=ver.."windowtop",
			InitCommand=function(s) s:y(-172):valign(1) end,
			TitleSelectionMessageCommand=function(self, params)
				self:finishtweening()
				if heardBefore then
					self:accelerate(0.1);
				else heardBefore = true end
				self:y(0):sleep(0.1):accelerate(0.2):y(-172)
			end;
		};
		Def.Sprite{
			Texture=ver.."windowbottom",
			InitCommand=function(s) s:y(172):valign(0); end,
			TitleSelectionMessageCommand=function(self, params)
				self:finishtweening()
				if heardBefore then
					self:accelerate(0.1);
				else heardBefore = true end
				self:y(0):sleep(0.1):accelerate(0.2):y(172)
			end;
		};
	};
	Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx,_screen.cy+276) end,
		OnCommand=function(s) s:zoomy(0):sleep(0.1):accelerate(0.3):zoomy(1) end,
		OffCommand=function(s) s:linear(0.2):zoomy(0) end,
		Def.Sprite{Texture=ver.."exp.png",};
		Def.Sprite{
			Condition=ver == "",
			Texture="expglow.png",
			InitCommand=function(s) s:diffuseramp():effectcolor1(color("1,1,1,0.5")):effectcolor2(color("1,1,1,1")):effectperiod(1.5) end,
		};
		Def.BitmapText{
			Font="_avenirnext lt pro bold/36px";
			Text="";
			InitCommand=function(self) self:hibernate(0.4):zoom(0.7):maxwidth(570):wrapwidthpixels(570):vertspacing(2) end;
			TitleSelectionMessageCommand=function(self, params)
				local text = THEME:GetString("ScreenTitleMenu","DescriptionFallback")
				if THEME:HasString("ScreenTitleMenu","Description"..params.Choice) then
					if params.Choice == "GameStart" and DayOfMonth() == 1 and MonthOfYear() == 3 then
						text = THEME:GetString("ScreenTitleMenu","DescriptionGameStartEE")
					else
						text = THEME:GetString("ScreenTitleMenu","Description"..params.Choice)
					end
				end
				if params.Choice == "Exit" then
					self:settext(THEME:GetString("ScreenTitleMenu","DescriptionExitProject"))
				else
					self:settext(text)
				end
			end;
			OnCommand=function(s) s:cropbottom(1):sleep(0.1):accelerate(0.3):cropbottom(0) end,
		};
	}
};
end

t[#t+1] = Def.ActorFrame {
	Def.BitmapText{
	Font="Common normal",
	Text=themeInfo["Name"] .. " " .. themeInfo["Version"] .. " by " .. themeInfo["Author"] .. (SN3Debug and " (debug mode)" or "") ,
	InitCommand=function(s) s:halign(1):xy(SCREEN_RIGHT-10,SCREEN_TOP+90):diffusealpha(0):wrapwidthpixels(400) end,
	OnCommand=function(s) s:sleep(0.3):decelerate(0.6):diffusealpha(0.5) end,
  };}

t[#t+1] = StandardDecorationFromFileOptional("Header","Header");
t[#t+1] = StandardDecorationFromFileOptional("Footer","Footer");

t[#t+1] = Def.Actor{
	CodeMessageCommand=function(s,p)
		if p.PlayerNumber == PLAYER_1 then
			if p.Name == 'BackgroundTest' then
		  		SCREENMAN:GetTopScreen():SetNextScreenName("ScreenBackgroundTest"):StartTransitioningScreen("SM_GoToNextScreen")
			end
		end
	end,
}

return t
