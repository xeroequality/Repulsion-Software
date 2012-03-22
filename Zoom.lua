--Overlay Variables
		local overlay = false; --Is the Overlay Up?
		local overlay_activity = false; --Is There Overlay Animation Going On?
		
		local play_button = display.newImage("../images/ui_play_button.png");
		play_button.x = 45+30; play_button.y = 35; play_button.static = "Yes";
		local menu_button = display.newImage("../images/ui_menu_button.png");
		menu_button.x = 115+30; menu_button.y = 35; play_button.static = "Yes";
		
		--------------------------------------------
		--             	   Slide UI               --
		--------------------------------------------
		
		-- Event for when open/close button is pressed
			-- If scrollView is "open", close it
			-- If scrollView is "closed", open it
		local function slideUI (event)
			if scrollView.isOpen then
				print("closing scrollView")
				scrollView.isOpen = false
				transition.to(static_menu, {time=300, y=-85} )
				transition.to(scrollView, {time=300, x=-85} )
				transition.to(play_button, {time=300, y=-35} )
				transition.to(menu_button, {time=300, y=-35} )

				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="../images/ui_btn_buildmenu_right.png",
						over="../images/ui_btn_buildmenu_right_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = scroll_bkg.width-45
					transition.to(slideBtn, {time=300, x=-35} )
					transition.to( goodoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )
					transition.to( badoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )

				end
			elseif not scrollView.isOpen then
				print("opening scrollView")
				scrollView.isOpen = true
				transition.to(static_menu, {time=300, y=0} )
				transition.to(scrollView, {time=300, x=0} )
				transition.to(play_button, {time=300, y=35} )
				transition.to(menu_button, {time=300, y=35} )
				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="../images/ui_btn_buildmenu_left.png",
						over="../images/ui_btn_buildmenu_left_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = -35
					transition.to(slideBtn, {time=300, x=scroll_bkg.width-45} )
					transition.to( goodoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
					transition.to( badoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
				end
				--Close Overlay if Up
				if overlay == true and overlay_activity == false then
					overlay = false;
					overlay_activity = true;
					print("Here")
				end
			end
			return true
		end
		
		slideBtn = widget.newButton{
			default="../images/ui_btn_buildmenu_left.png",
			over="../images/ui_btn_buildmenu_left_pressed.png",
			width=35, height=35,
			onRelease=slideUI
		}
		slideBtn.y = H/2
		slideBtn.x = scroll_bkg.width-45
		
		--------------------------------------------
		--             STATIC MENUS               --
		--------------------------------------------
		static_menu = display.newGroup()
		
		-- local static_buttons_bkg = display.newImage("../images/ui_bkg_static_buttons.png")
		-- static_buttons_bkg.x = -2				-- -2 to eliminate gap by the edge of the screen
		-- static_buttons_bkg.y = 75
		-- static_menu:insert(static_buttons_bkg)
		
		local function playUI (event)
			print('clicked play')
		end
		
		local function menuUI (event)
				-- Need to create a overlay and shade effect and pause the game when the menu button is pressed
			if event.phase == "began" then
				if overlay == false and overlay_activity == false then --Put Up the Overlay
					print('clicked menu')
					overlay_activity = true;
					overlay = true;
				end
			end
		end
		
		play_button:addEventListener("tap",playUI);
		menu_button:addEventListener("touch",menuUI);
		
		--Set Up the Width and Height Variables
		local w = display.contentWidth; local h = display.contentHeight;
		--Overlay Animation Variables
		local anim_time = 15; --How Much Time Spent for Overlay Animation (Both Ways)
		local now_time = 0; --The Current Time for the Current Animation
		local b = 25; local iw = 96*(2/3);
		local r_alpha = 0; --Overlay's Starting Alpha Value
		local s_alpha = 0.7; --Shade Final Alpha Value
		local r_scale = 0.75; --Overlay's Starting Scale
		local nr_scale = r_scale; --Overlay's Current Scale
		local once = false; --Preliminary Things Before Animating
		local r_w = (5*iw)+(2*b); --Length of the Overlay Rectangle
		local r_h = 256; --Height of the Overlay Rectangle
		
		--Make the Overlay Rectangle
		local overlayshade = display.newRect(-w,0,w*3,h); --The Shady Part of the Screen
		overlayshade:setFillColor(0,0,0); overlayshade.alpha = 0;
		local overlayrect = display.newImageRect("../images/overlay_grey.png",r_w,r_h);
		overlayrect.alpha = 0; overlayrect.x = (w/2); overlayrect.y = (h/2);
		
		local function overlay_animation(event)
			--Check to See If We Need to Animate
			if overlay_activity == true then			
				--Are We Going Into the Overlay?
				if overlay == true then
					--First Time Things
					if once == false then
						once = true;
						overlayshade.alpha = 0;
						overlayrect.alpha = r_alpha;
						now_time = anim_time;
						overlayrect:scale(r_scale,r_scale);
						nr_scale = (1-r_scale)/anim_time;
						nr_scale = (nr_scale+r_scale)/r_scale;
						
						--Close SlideView
						if scrollView.isOpen == true then
							scrollView.isOpen = false
							transition.to(static_menu, {time=300, y=-85} )
							transition.to(scrollView, {time=300, x=-85} )
							transition.to(play_button, {time=300, y=-35} )
							transition.to(menu_button, {time=300, y=-35} )

							if slideBtn then
								slideBtn:removeSelf()
								slideBtn = widget.newButton{
									default="../images/ui_btn_buildmenu_right.png",
									over="../images/ui_btn_buildmenu_right_pressed.png",
									width=35, height=35,
									onRelease=slideUI
								}
								slideBtn.y = H/2
								slideBtn.x = scroll_bkg.width-45
								transition.to(slideBtn, {time=300, x=-35} )
								transition.to( goodoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=300} )
								transition.to( badoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=300} )

							end
						end
					end
					--Control Visibility of the Overlay Shade
					overlayshade.alpha = overlayshade.alpha + (s_alpha/anim_time)
					--Control Visibility of the Overlay Rectangle
					overlayrect.alpha = overlayrect.alpha + ((1-r_alpha)/anim_time)
					--Control Scaling of the Overlay Rectangle
					overlayrect:scale(nr_scale,nr_scale);
					--Countdown the Timer
					now_time = now_time - 1;
					--Is Time Up?
					if now_time <= 0 then
						overlay_activity = false;
						once = false;
						overlayshade.alpha = s_alpha;
						overlayrect.alpha = 1;
					end				
				else
				--If We Are Leaving
					--First Time Things
					if once == false then
						once = true;
						overlayshade.alpha = s_alpha;
						overlayrect.alpha = 1;
						now_time = anim_time;
						nr_scale = (1-r_scale)/anim_time;
						nr_scale = (nr_scale-r_scale)/r_scale;
					end
					--Control Visibility of the Overlay Shade
					overlayshade.alpha = overlayshade.alpha - (s_alpha/(anim_time+5))
					--Control Visibility of the Overlay Rectangle
					overlayrect.alpha = overlayrect.alpha - ((1-r_alpha)/(anim_time+5))
					--Control Scaling of the Overlay Rectangle
					overlayrect:scale(nr_scale,nr_scale);
					--Countdown the Timer
					now_time = now_time - 1;
					--Is Time Up?
					if now_time <= 0 then
						overlay_activity = false;
						overlayshade.alpha = 0;
						overlayrect.alpha = 0;
						once = false;
						overlayrect:scale((1/r_scale),(1/r_scale));
					end	
				end
			else
				once = false;
			end
		end
		--Runtime Listener at Bottom of enterScene

----------------------------------------------
		--              ZOOM FEATURE                --
		----------------------------------------------
		local zoom = 100; --100% Zoom
		local s;
		function zoomTo(z)
			--Zoom to a Scale of Z
			s = (z/zoom);
			for i=2,group.numChildren do
				local child = group[i]
				child:scale(s);
			end
			zoom = z;
		end
		
		--Zoom Buttons
		local zoom_out = display.newImage("../images/background_minus.png");
		local zoom_in = display.newImage("../images/background_plus.png");
		local maxx = display.newImage(group,"../images/cannon_sm.png");
		maxx.x =  100; maxx.y = 50;
		zoom_out.x = 100; zoom_out.y = 20; zoom_out:scale(0.75,0.75); zoom_out.zoomy = "Yes";
		zoom_in.x = 150; zoom_in.y = 20; zoom_in:scale(0.75,0.75); zoom_in.zoomy = "Yes";
		--Zoom Out Button
		function Zoom_Out(event)
			--When the event starts
			if event.phase == "began" then
				--Zoom to a Scale of Z
				zoom_scale = 1;
				z = zoom-(zoom_scale);
				s = (z/zoom);
				for i=2,group.numChildren do
					local child = group[i]
					if child.zoomy == nil then
						--Adjust the X and Y
						child.y = child.y + ((child.height*child.yScale)*((zoom_scale)/100));
						child.x = child.x - ((child.width*child.xScale)*((zoom_scale)/100));
						child:scale(s,s);
					end
				end
				zoom = z;
				print(maxx.height);
			end
		end
		--Zoom In Button
		function Zoom_In(event)
			--When the event starts
			if event.phase == "began" then
				--Zoom to a Scale of Z
				zoom_scale = 1;
				z = zoom+(zoom_scale);
				s = (z/zoom);
				for i=2,group.numChildren do
					local child = group[i]
					if child.zoomy == nil then
						--Adjust the X and Y
						child.y = child.y + (child.height*((zoom_scale)/100));
						child.x = child.x + (child.width*((zoom_scale)/100));
						child:scale(s,s);
					end
				end
				zoom = z;
				print(maxx.y);
			end
		end
		zoom_out:addEventListener("touch",Zoom_Out)
		zoom_in:addEventListener("touch",Zoom_In)