--night ride
--vlad-constantin comarlau
--august 2020

function _init()
	init()
	reset()
end

----------------------------

function _update()

--title
if level==0 then
	car_x=1
	if time()<0.1 then
		music(2)
	end
	if ty1>20 then ty1=11 end
	if ty2>20 then ty2=11 end
	if (btn(4) or btn(5)) 
	and time()>4 then
		trans=1
		music(-1,400,3)
		sfx(15)
	end
	if trans_e>0.9 then
		level=1
		reset()
	end
end

if level==7 then
	if level_p>-1.2 and level_p<-1 then
			music(47,3000,2)
	end
	if level_p>70 and level_p<71 then
			music(-1,8000,2)
	end
end

	if level==8 and level_p > -9 and level_p < -8 then
		music(51,0,3)
	end
	
	if level>7 and level_p>247 and level_p<266 then
		music(0,0,3)
	end
	
if level_p>1 and level_p<2 then
	if	 level==1 then
		music(4,3000,2)
	end
end
if level==9 and level_p>304 and level_p<305 then
	music(23)
end
if col_d then
	music(-1)
end

--car
--horizontal movement
if btn(0) then
	if not s_disable then
		car_r_target = 10
	end
elseif btn(1) then
	if not s_disable then
		car_r_target = -10
	end
else
 car_r_target = 0
end
--shooting
if (level==5 and level_p>30) 
or level>5
then
	shoot_enabled=true
end
shoot_x+=((car_x*0.6-shoot_x)/7)+2

if shoot>0 then
	shoot-=1
end
if level>4 and not hit
and (btn(4) or btn(5))
and shoot<1
and level_p > 2
then
	if shoot_enabled then
		shoot=15
	end
end

--vertical movement
add_speedometer = 0
if   btn(2) 
and  c_disable==0
and  not hit
and  not (level==8 and level_p>240)
then
	car_y_target = 
	-10*((5-abs(rotation*1.3))*0.4)
	
	add_speedometer = -3
elseif btn(3) and c_disable==0 then
	car_y_target = 175
else
	car_y_target = 100
end
c_disable=0

if hit then
	car_y+=car_s*1.3
	for i=1,3 do
		add_spark(car_x*0.6+27,car_y*0.7-5,
												8,level_p-0.1,0)
	end
	add_explosion(car_x*0.6+17,car_y*0.7-10,
												20,0.7,level_p-0.1)
--e=x, r=y, l=life, s=size, t=time 
end

if level>0 then
	car_s=150/(car_y+195) * 10
else
	car_s=0
end
if hit then
	car_s=4
end
--road
lines_y  -= car_s*v_speed
walls_y  -= car_s*v_speed
lights_y -= car_s*v_speed
bridge_y -= car_s*v_speed

if lines_y < 30 then
	lines_y = 54
end

if walls_y < 30 then
	walls_y = 45
end

if lights_y < -8 then
	lights_y = 90
end

if bridge_y < -2000 then
	bridge_y = 90
end

car_x -= rotation*0.7

--limits horizontal sidewalls 
if sidewall_y > 80 and
			sidewall_y < 220 
			then
				steer_limit=-1
elseif sidewall_y2 > 80 and
			sidewall_y2 < 220 
			then
				steer_limit=1
else
				steer_limit=0
end

if steer_limit==-1 then
	if car_x<70 then 
		car_x,car_r_target=70,-20
		sfx(2)
		add_spark(car_x*0.05+62,car_y*0.7+12,
												8,level_p-0.1,0)
	end
else
	if car_x<-37 then 
		car_x,car_r_target=-37,-20
		sfx(2)
		for i=1,2 do
			add_spark(car_x*0.05+4,car_y*0.7+12,
												8,level_p-0.1,0)
		end
	end
end
if steer_limit==1 then
	if car_x>55 then 
		car_x,car_r_target=55,20
		sfx(2)
		add_spark(car_x*0.77+20,car_y*0.7+12,
												8,level_p-0.1,0)
	end
else
	if car_x>162 then 
		car_x,car_r_target=162,20
		sfx(2)
		for i=1,2 do
			add_spark(car_x*0.77+2,car_y*0.7+12,
												8,level_p-0.1,0)
		end
	end
end

--limits vertical
if  not hit 
and not (level==8 and level_p>240)
then
	if car_y>135 then 
		car_y,car_y_target=135,135 
	end
	if car_y<-10 then 
		car_y,car_y_target=-9,-9
	end
	
	if  limit_v==1 
	and car_y<30
	then
		car_y,car_y_target=30,30
	end
end

--traffic collisions
if col_l and rotation<0 then
	car_r_target=20
	add_spark(car_x*0.5+37,car_y*0.7+12,
												8,level_p-0.1,0)
end
if col_r and rotation>0 then
	car_r_target=-20
	add_spark(car_x*0.5+32,car_y*0.7+12,
												8,level_p-0.1,0)
end
if col_d
and not hit
then
	hit = true
	sfx(3)
end
rotation+=(car_r_target-rotation)/12

collide_sw()

-- heli
move_heli()

--vertical movement
car_y+=(car_y_target-car_y)/50

--collision with traffic
col_l,col_r,col_u,col_d 
= false,false,false,false

--traffic
	for car in all(cars) do
		if car.y > 128 then
			del(cars,car)
		end
		
		--ai
		if not hit then
			car.y += car_s*0.5+level*0.2
			if car.y>20 and car.y<23 then
				sfx(0)
			end
		else
			car.y -= 2
		end
		car.nearby=-1
		--check other cars nearby
		for v=1,count(cars) do
			if  cars[v].x>car.x-30
			and	cars[v].x<car.x+30
			and cars[v].y>car.y-20
			and	cars[v].y<car.y+20
			then
					car.nearby+=1
			end
		end
		--check player collision
		if  car_x*0.6+26>car.x-8
		and car_x*0.6+26<car.x+20
		and car_y*0.6+32>car.y
		and car_y*0.6+32<car.y+40
		then
			if car_x*0.6+26<car.x+8 then
				col_l=true
			else
				col_r=true
			end
			sfx(2)
			if car_y*0.6+32>car.y+35 then
				if  car_x*0.6+26>car.x-4
				and car_x*0.6+26<car.x+15
				then
					col_d=true
				end
			else
				col_u=true
			end
		end
		
		--lane switching
		if time()%(ceil(car.random))
					+ceil(rnd(2)) == 1
					and car.y       <  40
					and car.y							> -28
					and car.nearby  ==  0
					and steer_limit ==  0
					and level       !=  6
					then
							car.v=true
		end
		if car.v==true then
			car.timer=21
			car.v=false
		end
		if car.timer>0 then
			if car.random >0.5 then
				if car.x>4 then
					car.x-=0.7
				end
			else
				if car.x<110 then
					car.x+=0.7
				end
			end
			car.timer-=0.7
		end
	end
	
	--effects
	sparks()
	explosions()										
		
	--level logic
	if level>0 then
		level_p+=0.114
		level_percent=max(1-level_p
																			/100,0)
	end
	
	if level_p>100 and level<8 then
		level+=1
		level_p=-10
	end
	
	if level>6 then
		boss_fight()
	
  rt  += 0.05
		rt2 += 0.05
		if  rt>100 then  rt = 0 end
		if rt2>100 then rt2 = 0 end
		
		heli_s_c = 0
		
		cir_col()
		
		if	 heli_s   == 2
		and heli_s_c == 1
		then
			col_d = 1
		end
	end
	if heli_hit>0 then
		heli_hit-=1
	end
	limit_v=0
	
	--game over
	if car_y>100
	and hit then
		if car_y>280 then
			reset()
		end
	end
	--◆maps	
	levels()
end

function _draw()
	cls()
	
	--title
	if level==0 then
		fillp(0b101101001011010.1)
		draw_title_anim()
		fillp()
		palt()
		palt(0b0000000000000001)
		draw_title()
		transition(trans,64,64)
		palt()
	end
	
	if  level>0 
	and	level<9
	then
		rectfill(0,0,128,128,0)
			
		col=1
		--road
		line(0,0,0,128,col)
		line(127,0,127,128,col)
		
		--center
		line(63,0,63,128,col)
		line(62,0,62,128,col)
		line(65,0,65,128,col)
		line(66,0,66,128,col)
		
		--lanes
		for i=1, 10 do
	 	--right lanes
		 	line(105,25*i-5-lines_y,
		 						105,25*i+5-lines_y,col)
				line(106,25*i-5-lines_y,
									106,25*i+5-lines_y,col)			
			
				line(86,25*i-5-lines_y,
									86,25*i+5-lines_y,col)
				line(87,25*i-5-lines_y,
									87,25*i+5-lines_y,col)

			--left lanes
				line(19,25*i-5-lines_y,
									19,25*i+5-lines_y,col)
				line(20,25*i-5-lines_y,
									20,25*i+5-lines_y,col)		
			
				line(40,25*i-5-lines_y,
									40,25*i+5-lines_y,col)
				line(41,25*i-5-lines_y,
									41,25*i+5-lines_y,col)
		end	
		
		--walls
		if level==1 then
			for i=1, 12 do
				spr(49,1,15*i-walls_y)
				spr(49,119,15*i-walls_y,1,1,true,false)
			end
		end
		if level==2 then
			for i=1, 12 do
				spr(0,1,15*i-walls_y)
				spr(0,119,15*i-walls_y,1,1,true,false)
			end
		end
		if level==3 or 6 then
			for i=1, 12 do
				spr(16,1,15*i-walls_y)
				spr(16,119,15*i-walls_y,1,1,true,false)
			end
		end
		if level==4 then
			for i=1, 12 do
				spr(19,1,15*i-walls_y)
				spr(19,119,15*i-walls_y,1,1,true,false)
			end
		end
		if level==5 then
			for i=1, 12 do
				spr(35,1,15*i-walls_y)
				spr(35,119,15*i-walls_y,1,1,true,false)
			end
		end
		
		--traffic
		palt(0b0000000000000001)
		for  car in all(cars) do
			a,b = car.x,car.y
			 draw_traffic(car.k)
			--rect(car.x,car.y,
					--			car.x+12,car.y+25,6)
		end
		--bikers
		draw_biker(biker1_y,1)
		draw_biker(biker2_y,1)
		draw_biker_s()
		
		--barrel car
		for i=1,6 do
			if barrel_c_y[i]>-20 then
				draw_barrel_c(
									barrel_c_x[i],
									barrel_c_y[i],
									barrel_x[i],
									barrel_y[i])
			end
		end
		palt()
		
		draw_sparks()
		
		--draw car	
			for i=1,2 do
				if i>1 then
					drawsprite(sprite1,
					car_x+2*(rotation*0.1),
					car_y-3.5,
					4,
					7,
					rotation*0.5
					*(car_y/128+0.5),
					car_scale)
					
				else
				drawsprite(sprite,
					car_x,
					car_y-i*4,
					4,
					7,
					rotation*0.5
					*(car_y/128+0.5),
					car_scale)
				end
			end
		draw_explosion()
		
		--driver hands
		hands_x=car_x*0.6+15+rotation*0.2
		hands_y=car_y*0.57+25.5-rotation*-0.2
		
		if shoot>0 then
			spr(32,hands_x,hands_y)
		end
			
		--shooting
		if shoot>14.99 then
			line(hands_x+12-6,hands_y+1,
							shoot_x+12,hands_y-100,8)
			pset(hands_x+6,hands_y+2,10)
			pset(hands_x+6,hands_y+1,8)
			sfx(1)
		end
		
		--lights
		draw_lights()
		
		--side walls
		wall=0
		sidewall()
		sidewall2()
		
		--bridges
		if finished == false then
			draw_bridge()
		end
		--finish line----------
			draw_finish(93)
			
		--heli
		draw_heli
		(
			heli_x,
			heli_y,
			heli_f,
			heli_s,
			heli_ts
		)

		--hud
		--speed-o-meter
		if not hit then
			if  car_x >113 
			and car_y > 90
			then
				move+=0.35-move/10
				fillp(0b101101001011010.1)
			else
				move+=0-move/10
			end
			offset,offset_y=
			0,car_y*-0.08+5+move*2.5
			pal(13,8)
			circ(110+offset,112+offset_y,12,2)
			circ(110+offset,111+offset_y,12,8)
			circ(110+offset,110+offset_y,1,8)
			--meter
				pal(13,2)
				drawsprite(sprite2,
				142+offset*1.4,
				147.5+offset_y*1.5,
				0,
				0,
				max((time()%0.14*7)+car_s*-16+102+add_speedometer,-7),
				0.6)
				
				pal(13,8)
				
				drawsprite(sprite2,
				142+offset*1.4,
				145+offset_y*1.5,
				0,
				0,
				max((time()%0.14*7)+car_s*-16+102+add_speedometer,-7),
				0.6)
				--graded lines
				for i=1,12 do
					drawsprite(sprite3,
					130+offset*2,
					146+offset_y*1.5,
					14,
					0,
					4*i+16,
					0.6)
				end
				fillp()
				pal()
				--progress bar
				if level < 8 then
					fillp(0b1000000000000)
					line(127,128*level_percent,
										127,128,2)
					fillp()
					pset(125,128*level_percent,8)
					pset(127,128*level_percent,8)
					pset(124,128*level_percent,8)
				end
	 	end
			--messages
 		if level_p > 0 
 		and	level_p < 6 
 		then
				text_center(level)
	 	end
	 	if (level_p > 95
	 	or level_p < 0)
	 	and level<8
	 	then
	 		text_center(-1)
		 end
			--shoot tutorial
			if level==5 then	
				if tut==1 then
					text_center(-2)
				end
			end
			
			--boss health
			if 	level == 8 
			and	level_p>10
			then
				?"boss",10,1,8
				fillp(0b1010101010101010)
				rect(29,2,121,5,8)
				local h=heli_h/75
				line(30,3,91*h+30,3,14)
				line(30,4,91*h+30,4,14)
				fillp()
			end
	end
	if level==9 then
		if level_p<326 then
			end_screen()
		else
			draw_end(30,20)
		end
	end
	if level>0 and level_p<10 then
		palt(0b0000000000000001)
			transition(0,64,64)
		palt()
	end
	if hit and car_y>250 then
		transition(80,64,64)
	end
end
-->8
--functions

function reset()
	level_p,tut,finished,ty1,ty2,
	trans,trans_e,
	car_x,car_y,car_r_target,
	car_v_target,car_s,c_disable,
	steer_limit,car_scale,rotation,
	scale,limit_v,v_speed,shoot,
	shoot_enabled,hit,
	col_l,c0l_r,col_u,col_d,lines_y,
	walls_y,lights_y,bridge_y,
	sidewall_y,sidewall_y2,wall,e,
	q,k,l,r,t,car,cars,biker1_y,
	biker2_y,biker1_s,biker2_s,
	barrel_c_x,barrel_c_y,barrel_x,
	barrel_y,heli_h,heli_x,heli_y,
	heli_t_x,heli_t_y,heli_f,heli_s,
	heli_ts,rt,rt2,heli_s_c,heli_hit,
	move,level_percent,sparks_obj,
	spark,explosion_obj,explosion,
	circles,t,logo_f
	= 0,0,false,11,8,0,0.9,85,100,0,
	0,2,0,0,0.6,0.1,0,0,1.6,0,false,false,false,false,false,
	false,12,12,12,12,513,513,0,4,24,
	46,70,90,110,{},{},-20,128,false,
	false,{5,25,45,70,90,110},{-30,-30,-30,-30,-30,-30},
	{5,25,45,70,90,110},{-30,-30,-30,-30,-30,-30},
	74,30,150,30,150,1,0,0,0,0,0,0,4,
	10,{},{x=0,y=0,life=20},{},{x=0,y=0,life=20},
	{},0,500
	
	if level==2 then
		music(9,3000,2)
	end
	if level==3 then
		music(16,3000,2)
	end
	if level==4 then
		music(23,3000,2)
	end
	if level==5 then
		music(31,3000,2)
	end
	if level==6 then
		music(41,3000,2)
	end
	if level==7 and level_p<1 then
		music(47,3000,2)
	end
	if level==8 then
		music(51,0,3)
	end
	
	shoot_x=car_x
	
	for i=-5,5 do
		circle=
		{
			x=0,
			y=0,
			n=i	
		}
		add(circles,circle)
	end
end

function drawsprite
			(sprite,
			x,y,
			centerx,centery,
			angle,scale)
		--origin
		center_x,center_y = 
		x+centerx, y+centery
		
		--angle
		unghi=angle*(3.1/180)
		
		for i=1,#sprite do
			u=flr((i-1)/15)
			
			--original coords
			initial_x,initial_y = 
			x+i-15*u-4, y+u
			
			--rotated coords
			r_x,r_y=
							cos(unghi)*(initial_x-center_x)-
							sin(unghi)*(initial_y-center_y)+center_x
					,	sin(unghi)*(initial_x-center_x)+
							cos(unghi)*(initial_y-center_y)+center_y
			pixel = sub(sprite,i,i)
			
			if pixel == "a" then
				converted_pixel=-1
			end
			if pixel == "b" then
				converted_pixel=0
			end
			if pixel == "c" then
				converted_pixel=1
			end
			if pixel == "d" then
				converted_pixel=7
			end
			if pixel == "e" then
				converted_pixel=8
			end
			if pixel == "f" then
				converted_pixel=13
			end
			
			if  converted_pixel!=-1 then
				rectfill(r_x*scale-scale*68+64+0.9,
												r_y*scale-scale*71+64+0.9,
												r_x*scale-scale*68+64+scale*1.35,
												r_y*scale-scale*71+64+scale*1.35,
												converted_pixel)
			end
		end
end

function add_car(timee,a)
--add_car(time,x)
	if level_p > timee and 
	level_p < timee+0.114
	then
		car={x=a,
							y=car_s*0.5-100,
							k=2*flr(rnd(4)),
							v=false,
							timer=0,
							random=rnd(1),
							nearby=0,
						}
		add(cars,car)
	end
end
function add_truck(timee,a)
--add_car(time,x)
	if level_p > timee and 
	level_p < timee+0.114
	then
		car={x=a,
							y=car_s*0.5-100,
							k=8,
							v=false,
							timer=0,
							random=rnd(1),
							nearby=0,
						}
		add(cars,car)
	end
end

function draw_finish(timee)
	if level_p > timee and 
				level_p < timee + 40 then
			
			finished = true
			
			y-=4.5*1.5
			
			spr(33, 3,100-y-60)
			spr(18, 3,100-y+8-60)
			
			for i=1,15 do
				spr(34, 8*i-4,100-y-60)
				spr(34, 8*i-4,100-y-56)
			end
			line(8,y*-1+40,120,y*-1+40,13)
			line(3,y*-1+39,125,y*-1+39,13)

			spr(33, 118,100-y-60,1,1,true,false)
			spr(18, 118,100-y+8-60,1,1,true,false)
	else
		finished = false
		y = 70
	end
end

function text_center(x)
	c_disable=1
	nr=x
	if x>0 then
		rectfill(48,59,80,69,0)
		rect(48,59,80,69,8)
		?"level "..x,51,62
	end
	if x==-1 then
		rect(36,55,92,74,8)
		?"great job!",46,58
		?"level cleared",39,66
	end
	if x==-2 then
		a=64
		b=0
		fillp(0b1100110000110011.1)
		rectfill(66-a,56-b,
							126-a,73-b,0)
		fillp()
		rect(66-a,56-b,
							126-a,73-b,8)
		?"press ❎ or z",69-a,58-b
		?"to shoot",80-a,66-b
	end
end

function draw_traffic(s)
			sspr(32+s*8,0,16,16,a,b)
			if s!=8 then
				sspr(32+s*8,16,16,8,a,b+16)
			end
			if s==8 then
				sspr(96,0,16,32,a,b,16,42)
			end			
			--warning
			if b<8 then
			line_y = 3
			 line(a,line_y,a+11,line_y,8)
			 line(a+4,line_y+2,a+7,line_y+2,8)
			end
end

function draw_bridge()
			fillp(0b1010010110100101.1)
				rectfill(-3,102-bridge_y-30,129,100-bridge_y-30+8,0)
			fillp()
			spr( 2, 3,40-bridge_y)
			spr(18, 3,48-bridge_y)
			
			for i=1,15 do
				spr( 3, 8*i-4,40-bridge_y)
			end
			
			spr( 2, 118,40-bridge_y,1,1,true,false)
			spr(18, 118,48-bridge_y,1,1,true,false)
end

function draw_lights()
	for i=1, 2 do
			--right
			if wall!=-1 then
				spr( 1,115,100*i-lights_y-60)
				line(122,100*i-lights_y-58,128,100*i-lights_y-58,1)
	 		line(117,100*i-lights_y-59,128,100*i-lights_y-59,1)
			end
			--left
			if wall!=1 then
				spr( 1,5,100*i-lights_y-60,1,1,true,false)
				line(-5,100*i-lights_y-58,4,100*i-lights_y-58,1)
				line(-5,100*i-lights_y-59,9,100*i-lights_y-59,1)
			end		
			--shadows
			for a=0,15 do
				pal(a,0)
			end
			--right
			fillp(0b1010010110100101.1)
			rectfill(109,100*i-lights_y-40,
												125,100*i-lights_y-35,0)
			--left
			rectfill(4,100*i-lights_y-40,
												16,100*i-lights_y-35,0)
			fillp()
			pal()
			end
end

function sidewall()
	fillp(0b1000111100101111)
	rectfill( 0,sidewall_y-128,
										63,sidewall_y+18,1)
	
	if sidewall_y <512 then
		sidewall_y-=car_s*-1.5
		wall=1
		for x=0,63 do
			line(x,sidewall_y-128,
								x,sidewall_y-320-(64-x*4),1)
			
			line(x,257-x*4+sidewall_y,
								x,sidewall_y,1)
		end
		for a=2,6 do
				spr(48,
							10*a-10,
							sidewall_y+315-40*a,
							1,1,true,false)
		end
	end
	fillp()
end

function sidewall2()
	fillp(0b1000111100101111)
	rectfill( 65,sidewall_y2-128,
										128,sidewall_y2+18,1)
	
	if sidewall_y2 <512 then
		sidewall_y2-=car_s*-1.5
		wall=-1
		for x=0,63 do
			line(x+65,sidewall_y2-128,
								x+65,sidewall_y2-64-(64+x*4),1)

			line(x+65,1+x*4+sidewall_y2,
								x+65,sidewall_y2,1)
		end
		for a=2,6 do
				spr(48,
								130-10*a,
								sidewall_y2+300-40*a,
								1,1,false,false)
		end
	end
	fillp()
end

function spawn_sw_l(start,finish)
	if ceil(level_p)==start then
			sidewall_y=-256
		end
		if sidewall_y   > 113 and
					sidewall_y	  < 512 and
					ceil(level_p)<finish 
			then
				sidewall_y=110
		end
end

function spawn_sw_r(start,finish)
		if ceil(level_p)==start then
			sidewall_y2=-256
		end
		if sidewall_y2  > 113 and
					sidewall_y2  < 512 and
					ceil(level_p)<finish 
			then
				sidewall_y2=110
		end
end

function collide_sw()
	local d_x = 1-(car_x/64+0.5)

	if  car_x < 64
	and sidewall_y > car_y-135-60*(0.8-car_s/5)-d_x*150
	and sidewall_y < 115
	then
		rotation = -4.4*(car_s/5)
		add_spark(car_x*0.6+28,car_y*0.7+12,
												8,level_p-0.1,0)
												sfx(2)
	end
	
	if  car_x > 64
	and sidewall_y2 > car_y-132-60*(0.8-car_s/5)-(1-d_x-2)*150
	and sidewall_y2 < 115
	then
		rotation = 4.4*(car_s/5)
		add_spark(car_x*0.6+25,car_y*0.7+12,
												8,level_p-0.1,0)
												sfx(2)
	end
end

function draw_vehicle(a,b,s)
	sspr(32+s*8,0,16,24,a,b)
end

function draw_biker(y,f)
	if y>-10 and y<128 then	
		--biker
		draw_vehicle(0,y,4)
		--hand
		line(8,y+10,12,y+10,13)
		line(8,y+9,8,y+7,0)
	end
end

function draw_biker_s()
	if biker1_s then
		if time()%0.2>0.15 then
		--shoot
		 sfx(1)
			line(16,biker1_y+9,
								128,biker1_y+9,9)
			pset(16,biker1_y+9,7)
			pset(15,biker1_y+9,10)
			if  car_y*0.6+23>biker1_y-5
			and car_y*0.6+20<biker1_y+5
			then
				col_d=true
			end
		end
	else
			--target
			line(13,biker1_y+10,
							128,biker1_y+10,2)
	end
	if biker2_s then
		--shoot
			if time()%0.2>0.15 then
				sfx(1)
				line(16,biker2_y+9,
								128,biker2_y+9,9)
				pset(16,biker2_y+9,7)
				pset(15,biker2_y+9,10)
				if  car_y*0.6+23>biker2_y-5
				and car_y*0.6+20<biker2_y+5
				then
					col_d=true
				end
			end
		else
			--target
			line(13,biker2_y+10,
							128,biker2_y+10,2)
		end
end

function add_biker(t,n,y)
--time, number, height
	if level_p>t	then
	--upper biker
		if n == 1 then
			--show
			if level_p<t+10 then
				if biker1_y < y then
					biker1_y+=(y-biker1_y)/20+0.2
				end
			end
			--shoot
			if  level_p>t+10
			and level_p<t+15
			then
				biker1_s=true
			else
				biker1_s=false
			end
			--disappear
			if (level_p>t+15
			and level_p<t+24)
			or heli_h==0 
			then
					biker1_y+=(-40-biker1_y)/40+0.2
			end
		end
		
		--lower biker
		if n == 2 then
			--show
			if level_p<t+10 then
				if biker2_y > y then
					biker2_y+=(y-biker2_y)/20+0.2
				end
			end
			--shoot
			if  level_p>t+10
			and level_p<t+15
			then
				biker2_s=true
			else
				biker2_s=false
			end	
			--disappear
			if  (level_p>t+15
			and level_p<t+24)
			or heli_h==0
			then
					biker2_y+=(140-biker2_y)/40+0.2
			end
		end
		
		if heli_h==0 then
			biker1_s,biker2_s = false,false
		end
	end
end

function draw_title_anim()
 color(1)
	line(64,55,-128,120)
	line(64,55, 256,120)
	line(64,55,-128,123)
	line(64,55, 256,123)
	for i=-20,20 do
		line(64,60,64+i,158,1)
	end
	ty1*=1.04
	ty2*=1.04
	rectfill(64-ty1*0.7,8*ty1-51,
										64+ty1*0.7,15*ty1-150,
										0)
	rectfill(64-ty2*0.7,8*ty2-51,
										64+ty2*0.7,15*ty2-150,
										0)
end

function draw_title()
	sspr(8,64,128,32,8,0)
	sspr(0,96,128,32,0,32)
	--press to start
	x=35
	if time()>4 then
		t_y-=(t_y-100)/15
	end
	for v=0,6 do
		for i=0,60 do
			a=sget(24+i,24+v)
			pset(
			x+i,
			t_y+v-cos((60-i)*0.02+time()/3)*2,a)
		end
	end
	--title shine effect
	for t_y=37,63 do
		for x=6,123 do
			a,m,t,f=
			pget(x+1,t_y),--position
			5,
			(time()+13)*-16,--speed
			(t_y+t)%24-x*0.01--mod=thickness
			if f<20 and f>-1 then--length
				if a==2 then
					if f<7 or f>13 then--fade
						fillp(▒)--fade pattern
					else
						fillp()
					end
					pset(x,t_y,8)--color
				end
			end
		end
	end
end

function draw_barrel_c(x,y,bx,by)
	pal(13,2)
		draw_vehicle(x,y,6)
	pal()
palt(0b0000000000000001)

	--barrel
	spr(50,bx+2,by+9)
	line(bx+10,by+11,bx+10,by+14,13)
	line(bx+1,by+11,bx+1,by+14,13)
end

function add_barrel_car(t,n)
	--reset positions
	if  level_p>t
	and level_p<t+1
	then
		barrel_c_y[n],barrel_y[n]=
		-30,-30
	end
	
	if level_p>t and level_p<t+20 
	then
		limit_v = 1
	end
	
	--appear
	if 	level_p>t+1
	and level_p<t+5
	then
		if barrel_c_y[n] < 15 then
					barrel_c_y[n]+=(15-barrel_c_y[n])/20+0.2
		end
		if barrel_y[n] < 15 then
					barrel_y[n]+=(15-barrel_y[n])/20+0.2
		end
	end
	--throw_barrel
	if level_p>t+7
	and level_p<t+14
	and barrel_y[n]>10
	and barrel_y[n]<128
	then
		barrel_y[n]+=1.7*(v_speed-0.1)
		if  car_x*0.6+27>barrel_x[n]
		and car_x*0.6+27<barrel_x[n]+15
		and car_y*0.6+27>barrel_y[n]+5
		and car_y*0.6+27<barrel_y[n]+15
		then
			col_d=true
		end
	end
	--disappear
	if		(level_p>t+9
	and level_p<t+14)
	or hit
	then
		barrel_c_y[n]-=1
	end
	if  shoot_x>barrel_x[n]-20
	and shoot_x<barrel_x[n]+10
	and shoot>10
	and barrel_y[n]>20
	and barrel_y[n]<130
	and barrel_y[n]<car_y*0.6+30
	then	
		add_explosion
		(
			barrel_x[n],
			barrel_y[n],
			25,
			1,
			level_p-1
		)
		add_explosion
		(
			barrel_x[n],
			barrel_y[n],
			25,
			1,
			level_p-1
		)
		barrel_y[n]=-30
	end
end

function tutorial()
		if  level_p>15
		and level_p<30
		then
			car_x-=(car_x-120)/25
			car_r_target,s_disable,c_disable=
			0,true,1
		else
			s_disable,c_disable = false,0
		end
		if  level_p>27.5
		and level_p<28
		and tut==0 then
			tut=1
		end
		if tut==1 then
			shoot_enabled,level_p,v_speed
			=true,27.5,0.1
				if btn(❎)or btn(🅾️) then
				tut,v_speed=0,1.6
				level_p+=1
				music(35,3000,2)
			end
		end
end

function transition(t,x,y)
		if trans_e>t	then
			trans_e-=0.03
		end
		if trans_e<t	then
			trans_e+=0.03
		end
 t=60*trans_e+20
 effect_x,effect_y = x,y
 palt(0b0010000000000000)
 if level<1 and time()<4 then
 	pal(1,0)
 else
 	pal(1,1)
 end
 fillp(0b1111111111111110.1)
 circfill(effect_x,effect_y,t*7-200,1)
 fillp(0b1111101111111110.1)
 circfill(effect_x,effect_y,t*7-210,1)
 fillp(0b101101101011110.1)
 circfill(effect_x,effect_y,t*7-220,1)
 fillp(0b100100001010010.1)
 circfill(effect_x,effect_y,t*7-230,1)
 fillp(0b1000000000100000.1)
 circfill(effect_x,effect_y,t*7-250,1)
 fillp()
	pal()
	fillp()
end

function add_spark(e,r,l,t,u)
--e=x, r=y, l=life, t=time
	for i=1,4+(car_s-5) do
		if level_p > t 
		and count(sparks_obj) < 150
		and level_p < t+0.114+i*0.1
		then
			if u==0 then
				spark =
				{
					x     = e+rnd(4)-2,
					y     = r+rnd(30),
					life  = l,
					rndom = rnd(2),
					typee = u
				}
			end
			if u==1 then
				spark =
				{
					x     = e,
					y     = r,
					life  = l,
					rndom = rnd(2),
					typee = u
				}
			end
			add(sparks_obj,spark)
		end
	end
end

function sparks(x,y)
		for spark 
		in all(sparks_obj) do
			if spark.typee==0 then
				spark.y+=spark.rndom*1.5+car_s*0.5+0.5
				spark.x+=spark.rndom*sin(time()*spark.rndom)
				spark.life-=0.5
			end	
			if spark.typee==1 then
				spark.y+=spark.rndom*1.5+car_s+2			
				spark.life-=0.5
			end
			if spark.life < 1 then
				del(sparks_obj,spark)
			end
		end
end

function draw_sparks()
	for spark
	in all(sparks_obj) do
		if spark.typee==0 then
			line(spark.x,spark.y,
								spark.x,spark.y
								+spark.rndom*2-1,8)
		end
	end
end

function add_explosion(e,r,l,s,t)
--e=x, r=y, l=life, s=size, t=time 
	for i=1,6+(car_s-5) do
		if  level_p > t
		and level_p < t+0.6+i*0.1
		and count(explosion_obj) < 250
		then
			explosion =
			{
				x     = e+rnd(4)-2,
				y     = r+rnd(30),
				life  = l,
				rndom = rnd(2),
				size  = s
			}
			add(explosion_obj,explosion)
		end
	end
end

function explosions(x,y)
		for explosion 
		in all(explosion_obj) do
			explosion.y+=explosion.rndom*1.2+car_s*0.5+0.3*(v_speed)
			explosion.x+=explosion.rndom*sin(time()*explosion.rndom)
			explosion.life-=0.5
			if explosion.life < 1 then
				del(explosion_obj,explosion)
			end
		end
end

function draw_explosion()
	for explosion
	in all(explosion_obj) do
	if heli_h == 0 then
		pal(6,8)
		if heli_y<128 then
			music(-1)
		end
	end
		fillp(0b1010101001010101.1)
		if explosion.y > 80 then
			fillp(0b11110000111100.1)
		end
		if explosion.y > 100 then
			fillp(0b1010010110100101.1)
		end
		if explosion.y < 80 then
			fillp(0b100000000010000.1)
		end
		circfill
						(explosion.x+5+explosion.rndom,
							explosion.y-explosion.rndom-15,
							explosion.rndom*4*explosion.size,13)
		circfill
						(explosion.x,explosion.y+5,
						7*explosion.size,1)	
		circfill
						(explosion.x+5,explosion.y,
							8*explosion.size,6)
		fillp()
		pal()
	end
end

function draw_heli(x,y,r,s)
	if y>-30 and y<130 then sfx(25)	 end
	if   y > -30
	and  y < 145 
	then
		local e = x + 4
		--pre shoot
		if heli_ts == 1 then
			line(e,y,e,y+128,2)
			if s==0 and stat(17) !=26 then 
				sfx(26,1) 
			end
		end
		if heli_ts == 2 then
		if s==0 and stat(17) !=26 then sfx(26) end
			line(x+200*sin(rt*-0.15)+4,
 		 				y+200*cos(rt* 0.15)*-1+15*r,
 		 				x+200*sin(rt* 0.15)+4,
 		 				y+200*cos(rt* 0.15)+15*r,
 		 				2)
		end
		--shoot
		if s == 1 then
			sfx(27)
			fillp(0b1110111110111111.1)
				rectfill(e-10*sin(time()),y+20,
													e+10*sin(time()),128,2)
			fillp(0b1000001000000.1)	
				rectfill(e-4*sin(time()),y+20,
													e+4*sin(time()),128,2)
			fillp(0b1010010110100101.1)
				rectfill(e-2,y+20,e+2,128,8)
				rectfill(e,y+20,e,128,8)
			fillp()
		end
	 if s == 2 then
	 	sfx(28)
	 	line(x+200*sin(rt*-0.15)+4,
 		 				y+200*cos(rt* 0.15)*-1+15*r,
 		 				x+200*sin(rt* 0.15)+4,
 		 				y+200*cos(rt* 0.15)+15*r,
 		 				8)
 		line(x+200*sin(rt*-0.15)+5,
 		 				y+200*cos(rt* 0.15)*-1+16*r,
 		 				x+200*sin(rt* 0.15)+5,
 		 				y+200*cos(rt* 0.15)+16*r,
 		 				8)
 		fillp(0b1010010110100101.1)
 		line(x+200*sin(rt*-0.15)+3,
 		 				y+200*cos(rt* 0.15)*-1+18*r,
 		 				x+200*sin(rt* 0.15)+3,
 		 				y+200*cos(rt* 0.15)+18*r,
 		 				8)
 		line(x+200*sin(rt*-0.15)+3,
 		 				y+200*cos(rt* 0.15)*-1+13*r,
 		 				x+200*sin(rt* 0.15)+3,
 		 				y+200*cos(rt* 0.15)+13*r,
 		 				8)
	 	fillp()
	 	if rt>0.2 then
	 	local g=1-(cos((rt+0.6)*0.30))
				add_spark(
				4,
				128*g,
				8,
				level_p-0.1,
				0)
				
				if g >1.9 then
		 		add_spark(
		 		122,
					10,
					8,
					level_p-0.1,
					0)
				end
				if g > 1 and g < 1.3 then
		 		add_spark(
		 		122,
					60,
					8,
					level_p-0.1,
					0)
				end
				if g > 0.7 and g < 0.1 then
		 		add_spark(
		 		122,
					90,
					8,
					level_p-0.1,
					0)
				end
			end
	 end
	 
		r*=2
		--hit effect
		if  heli_hit > 0 
		and time()%1 > 0.5
		then
			pal(3,6)
			pal(11,6)
			pal(2,6)
		else
			pal(3,2)
			pal(11,8)
			pal(2,1)
		end
		palt(0b0000000000000001)
		--body
		if heli_h > 0 then
			if heli_f==1 then	
				sspr(112,0,16,32,heli_x-4,heli_y-4)
			else
				sspr(112,32,16,32,heli_x-4,heli_y-4)
			end
		end
		pal()
		--blades
		fillp(0b101101001011010.1)
		fillp(0b1010010110100101.1)
		if rt2%0.03 > 0.01 then
			circfill(x+4,y+r*7,19,1)
			line(x+18*sin(time()*-1)+4,
 		 				y+18*cos(time()* 1)*-1+7*r,
 		 				x+18*sin(time()* 1)+4,
 		 				y+18*cos(time()* 1)+7*r,
 		 				13)
		end
		fillp()
		--smoke
		if 	heli_h < 30
		and	heli_h > 15
		and rt2%1 > 0.8
		then
			add_explosion
			--e=x, r=y, l=life, 
			--s=size, t=time 
			(
				heli_x,
				heli_y+8,
				8,
				rnd(0.3),
				level_p-1
			)
		end
		
		if 	heli_h < 16
		and	heli_h > 0
		and rt2%0.5 > 0.25
		then
			add_explosion
			--e=x, r=y, l=life, 
			--s=size, t=time 
			(
				heli_x,
				heli_y+8,
				8,
				rnd(0.4),
				level_p-1
			)
		end
		--final explosion
		if 	heli_h == 0
		and level  == 8
		then
			if time()%8000 then
				rndsnd=flr(rnd(3))+29
			end
			if stat(17)!=29 and stat(17)!=30 and stat(17)!=31 then
				sfx(rndsnd)
			end
			add_explosion
			--e=x, r=y, l=life, 
			--s=size, t=time 
			(
				heli_x+rnd(32)-16,
				heli_y-8,
				15,
				rnd(2),
				level_p-1
			)
			add_spark(
		 		heli_x+rnd(40)-12,
					heli_y+rnd(40)-28,
					10,
					level_p-0.1,
					0)
		end
	end
end

function move_heli()
	heli_x += (heli_t_x-heli_x)/40
	heli_y += (heli_t_y-heli_y)/40
end

function set_heli(t,x,y,z,s)
--time,x,y,dir,shoot
	if 	level_p > t-2
	and level_p < t-1.5
	then
	end
	if  level_p > t-2
	and level_p < t
	then
		heli_ts = s
	end
	if  level_p > t
	and level_p < t+1
	then
		heli_t_x,heli_t_y,heli_f = 
		x,y,z
	end
	if  level_p > t+2
	and level_p < t+3
	then
		heli_s = s
	end
end

function boss_fight()
	if	 heli_h == 0
	and level_p < 200 
	then
		level_p = 200
	end
	if  car_x*0.6+27 > heli_x-4
	and car_x*0.6+27 < heli_x+18
	then
			if heli_s==1	then
				col_d=1
			else if shoot  > 14 
			and					heli_h >  0
			and 				level==8
			then
				heli_h  -= 1
				heli_hit = 10
				add_spark(
		 		heli_x+6,
					heli_y,
					8,
					level_p-0.1,
					0)
			end
		end
	end
end

function cir_col()
	local cx,cy = 
	car_x*0.6+27,car_y*0.6+32 
	for circle in all(circles) do
		local n = circle.n
		circle.x=heli_x+(14*n)*sin(rt* 0.15)+4
		circle.y=heli_y+(14*n)*cos(rt* 0.15)*1+15
		if dist(circle.x,
										circle.y,
										cx,
										cy) < 8
		then
			heli_s_c = 1
		end
	end
end

function draw_cir_col()
	for circle in all(circles) do
		circ(circle.x,circle.y,5,7)
	end
end

function dist(x1,y1,x2,y2)
	a,b=
	(x1-x2)^2,(y1-y2)^2
	c=sqrt(a+b)
	return c
end

function text(t,tx,x,y,c)
	if level_p>t then
		?tx,x,y,c
	end
end

function end_screen()
	if level_p <295 then
		?"thank you for playing!",22,40,8
	end
end

function end_car(x,y)
palt(0b0000000000000001)
	rectfill(x-48,y+32,x+15,y+47,0)
	sspr(80,32,32,32,x,y)
	sspr(64,32,16,8,x+8,y-8)
	sspr(56,56,24,8,x,y+32)
	sspr(24,32,8,8,x+8,y-8,-32,8)
	sspr(16,32,8,8,x,y,-32,8)
	sspr(48,32,16,8,x-40,y-8)
	sspr(32,56,24,8,x-48,y)
	sspr(32,32,16,24,x-64,y+8)
	sspr( 8,48,8,8,x,y+8,-48,8)
	sspr( 8,56,8,8,x,y+16,-48,8)
	spr(114,x-8,y+16)
	sspr(16,48,8,8,x,y+24,-48,8)
	sspr(48,40,8,16,x-56,y+32)
	spr(82,x+16,115)
	sspr(56,40,24,8,x-40,y+8)
	sspr(56,48,24,8,x-40,y+23)
	spr(99,x-32,y+16)
	spr(65,x+2,115)
	spr(128,x+24,100)
	spr(144,x-57,109)
palt()
end

function draw_end(x,y)
local a,b = 110,55
fillp(…)
	circfill(a,b,40*sin(rt*0.1),2)
fillp(░)
	circfill(a,b,30,2)
fillp(▤)
	circfill(a,b,20,8)
fillp(❎)
	circfill(a,b,10,9)

rectfill(a-200,b+5,a+200,128,0)

t+=6
if t>128 then t=84 end
for i=1,400 do
	line(-200,100+i,128,70+i/16,1)
	line(-200,90+i,148,90+i/16,1)
end
for i=1,10 do
	line(70+i,140,128+i/5,92,6)
end
rectfill(64,t,128,t+10,1)
	end_car(65+sin(rt*0.1)*8,76+sin(rt*3)*0.1)
	if level_p>359 then
		print("made with ♥ \n\nby vlad comarlau \naugust 2020", 17,7,8)
	end
	if level_p>386 then
		print("\nthanks:cristina \nsnital  robert \nteodor  rased ", 17,33,8)
	end
end

-->8
--levels

function init()
--progession--------------
	level,level_p,tut,finished,t_y
	= 0,0,0,false,135
end

function levels()
	--level 1
	--e q k l r t
	if level==1 then
		add_car( 5, q)
		add_car(10, q)
		add_car(18, t)
		add_car(20, r)
		add_car(22, q)
		add_car(30, r)
		add_car(32, r)
		add_car(32, e)
		add_car(37, l)
		add_car(52, q)
		add_car(52, r)
		add_car(57, k)
		add_car(57, l)
		add_car(57, t)
		add_car(60, q)
		add_car(62, e)
		add_car(65, q)
		add_car(65, e)
		add_car(65, k)
		add_car(70, e)
		add_car(72, e)
		add_car(70, l)
		add_car(70, r)
		add_car(70, t)
		add_car(80, r)
		add_car(81, q)
		add_car(81, t)
		add_car(85, e)
		add_car(86, e)
		add_car(85, l)
		add_car(86, t)
	end
	--e q k l r t
	--level 2
	if level==2 then
		spawn_sw_l(8,40) --3 40
		add_truck(12, r)
		add_car(17, l)
		add_truck(20, l)
		add_car(23, l)
		add_car(27, t)
		add_car(29, t)
		spawn_sw_r(42,83)
		add_truck(45, q)
		add_car(53, e)
		add_truck(55, e)
		add_car(55, q)
		add_car(58, e)
		add_car(58, k)
		add_car(61, e)
		add_car(61, q)
		add_car(65, e)
		add_car(65, k)
		add_truck(72, q)
		add_truck(84, q)
		add_car(86, e)
		add_truck(89, t)
	end
	--e q k l r t
	if level==3 then	
		add_biker( 8,1,80)
		add_car(25, k)
		add_car(28, l)
		spawn_sw_r(35,55)
		add_biker(36,1,30)
		add_biker(36,2,75)
		add_truck(58, e)
		add_car(60, r)
		add_car(65, t)
		add_car(67, q)
		add_car(67, e)
		add_car(69, e)
		add_car(71, q)
		add_car(71, k)
		add_car(73, q)
		add_biker(74,1,30)
		add_biker(74,2,75)
		add_car(75, k)
		add_car(75, q)
		add_car(76, k)
		add_car(78, k)
		add_car(80, q)
		add_car(80, k)
		add_car(83, k)
		add_car(85, q)
		add_truck(88, t)
	end
	--e q k l r t
	if level==4 then
		add_barrel_car(10,3)
		add_barrel_car(10,4)
		add_barrel_car(20,1)
		add_barrel_car(20,6)
		add_barrel_car(21,2)
		add_barrel_car(21,5)
		add_truck(32,l)
		add_truck(34,l)
		add_barrel_car(37,1)
		add_barrel_car(37,3)
		add_car(38,t)
		add_car(39,r)
		add_car(44,r)
		add_truck(48,q)
		add_barrel_car(52,1)
		add_barrel_car(53,2)
		add_barrel_car(54,3)
		add_barrel_car(55,4)
		add_barrel_car(56,5)
		add_barrel_car(59,6)
		add_barrel_car(68,3)
		add_barrel_car(68,4)
		add_car(73,t)
		add_barrel_car(72,2)
		add_barrel_car(72,5)
		add_barrel_car(78,1)
		add_barrel_car(78,6)
		add_truck(88,q)
		add_barrel_car(80,3)
		add_barrel_car(80,4)
		add_car(86,e)
	end
	--e q k l r t
	if level==5 then
		spawn_sw_l(10,40)
		add_barrel_car(20,6)
		add_barrel_car(20,5)
		add_barrel_car(20,4)
		tutorial()
		add_barrel_car(42  ,1)
		add_barrel_car(41.5,2)
		add_barrel_car(41  ,3)
		add_barrel_car(41  ,4)
		add_barrel_car(41.5,5)
		add_barrel_car(42  ,6)
		add_barrel_car(55,1)
		add_barrel_car(55,2)
		add_barrel_car(55,3)
		add_barrel_car(60,4)
		add_barrel_car(60,5)
		add_barrel_car(60,6)
		add_barrel_car(75  ,6)
		add_barrel_car(74.5,5)
		add_barrel_car(73.5,4)
		add_barrel_car(73.5,3)
		add_barrel_car(74.5,2)
		add_barrel_car(75  ,1)
		add_truck(88,q)
	end
	--e q k l r t
	if level==6 then
		add_barrel_car(7.5,4)
		add_car(11,e)
		add_car(11,q)
		add_car(11,k)
		add_car(11,r)
		add_car(11,t)
		add_barrel_car(16.5,3)
		add_car(20,e)
		add_car(20,q)
		add_car(20,l)
		add_car(20,r)
		add_car(20,t)
		add_barrel_car(26.5,4)
		add_car(30,e)
		add_car(30,q)
		add_car(30,k)
		add_car(30,r)
		add_car(30,t)
		spawn_sw_r(40,90)
		add_barrel_car(46.5,2)
		add_car(50,e)
		add_car(50,k)
		add_biker(58,1,30)
		add_biker(58,2,75)
		add_barrel_car(75,1)
		add_barrel_car(75,2)
		add_barrel_car(75,3)
	end
	--e q k l r t
	if level==7 then
		add_truck(9,q)
		add_car(9/5,t)
		add_truck(13,r)
		add_car(15,l)
		add_car(15.5,q)
		add_car(15,t)
		add_car(16,l)
		add_car(18,r)
		add_car(19,l)			
		add_car(19.5,t)
		add_car(20,r)
		add_car(21.5,t)
		add_truck(22,r)
		add_car(24,l)
		add_car(25,l)
		add_truck(28,t)
		add_car(28.5,r)
		set_heli(29,30,-35,0)
		add_truck(31.5,q)
		add_car(34,q)
		add_car(37,e)
		add_car(37.5,k)
		add_car(37,q)
		add_car(41.5,k)
		add_car(41,q)
		add_car(42,e)
		add_truck(46,k)
		add_biker(50,1,51)
		add_biker(50,2,75)
		add_car(54.5,r)
		add_car(57,t)
		add_car(61,r)
		add_car(63,t)
		add_truck(66,r)
		add_car(70.5,l)
		add_car(70,t)
		add_car(75,r)
		add_car(75,l)
		add_car(78,r)
		add_car(79.5,r)
		add_car(81.5,q)
		add_truck(83,e)
		add_truck(86,l)
		add_car(86,k)
		add_car(87,k)
		add_car(87.5,e)
	end
	--e q k l r t
	if level==8 then
		if level_p<8 then
			heli_x =  30
			heli_y =	-35
		end
		set_heli( 8,80,13,1,0)
		set_heli(26,80,13,1,1)
		set_heli(28,10,13,1,1)
		set_heli(36,10,13,1,0)
		add_biker(40,2,80)
		set_heli(55,  0,13,1,1)
		set_heli(58,110,13,1,1)
		set_heli(66,110,13,1,0)
		add_biker(70,2,70)
		set_heli(80,110,13,1,1)
		set_heli(83, 10,13,1,1)
		set_heli(92, 10,13,1,0)
		add_barrel_car(103,1)
		add_barrel_car(103,2)
		add_barrel_car(103,3)
		add_barrel_car(103,4)
		add_barrel_car(103,5)
		add_barrel_car(103,6)
		set_heli(115, 10,13,1,1)
		set_heli(119,110,13,1,1)
		set_heli(125,110,13,1,0)
		add_truck(130,e)
		add_truck(130,q)
		add_truck(130,k)
		set_heli(135, 61,64,1,0)
		set_heli(150, 61,64,1,2)
		set_heli(183, 61,64,1,0)
		set_heli(186, 80,13,1,0)
		--loop
		if  level_p>200
		and	heli_h>0
		then
			level_p = 20
		end
		--ending
		
		--lock player
		if level_p>200 
		then
			if level_p<250 then
				if car_x>63 then
					car_x-=(car_x-130)/25
				else
					car_x-=(car_x+24)/25
				end
			else
				car_x-=(car_x-85)/25
				if level_p>260 then
					car_y-=5
				end
			end
			car_r_target,s_disable,c_disable=0,true,1
		end
		
		set_heli(201,58, 30,1,0)
		set_heli(225,58, 50,1,0)
		set_heli(240,58,170,1,0)

		--switch to end screen
		if level_p>273 then
			level=9
		end
	end
end
-->8
--data
sprite="aaabbbbbbbbbbaaaabbbbbbbbbbbbaabcddcfcfcddcbabbcdccfcfcccdbabbccccfcfccccbbbcccccfcfcccccbbcccccfcfcccccbbcccccfcfcccccbbcccccfcfcccccbbcccccbbbcccccbbcccbbbbbbbcccbbccbbbbbbbbbccbbcbbbbbbbbbbbcbccbbbbbbbbbbbcccccbbbbbbbbbcccbcbbbbbbbbbbbcbbcbbbbbbbbbbbcbbcbbbbbbbbbbbcbbcbbbbbbbbbbbcbbcbbbbbbbbbbbcbbcbbbbbbbbbbbcbbcbbbbbbbbbbbcbbcbbbbbbbbbbbcbbcbbbbbbbbbbbcbbcccbbbbbbbcccbbcccbbbbbbbcccbbcccbbbbbbbcccbbceeebbbbbeeecbbbeeebbbbbeeebbaabcccfcfcccbaa"
sprite1="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbaaaaaaaaaabbbbbbbaaaaaaabbbbbbbbbaaaaaaaccfcfccaaaaaaacccfcfcccaaaaaacccfcfcccaaaaaacccfcfcccaaaaaacccfcfcccaaaaaacccfcfcccaaaaaacccfcfcccaaaaaacccfcfcccaaaaaaaccfcfccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
sprite2="ffffffffffffffffffffffffffffffffffffffff"
sprite3="ffff"
__gfx__
110000000111000010d0d0d00d0d0d0dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffddddddffffffffffffffffffffff
10100000111110001d0d0d0dd0d0d0d0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffddddddffffffffffffffffffffff
110000001111111110d0d0d00d0d0d0dffffddddddfffffffff1111ffffffffffffffffffffffffffff111dddffffffffff11111111fffffffffff2222ffffff
10000000111110001d0d0d0dd0d0d0d0ffffddddddfffffffff11ddddffffffffffff11fffffffffff111dddddfffffffff11111111fffffffffff20b2ffffff
11100000080800001011111111111111fffddddddddfffffff11ddddddfffffffffff11fffffffffff011000ddffffffff1d1d1d1d1dffffffffff20bbffffff
10010000808080000111111111111111fffddddddddfffffff11ddddddfffffffffff11fffffffffff1100000dffffffff1d1d1d1d1dffffffffff20b2ffffff
11000000000000001011111111111111ff1dddddddddffffff11ddddddffffffffff1221ffffffffff1100000dffffffff1d1d1d1d1dffffffffff2b32ffffff
10000000000000000111111111111111ff1dddddddddffffff101000ddffffffff1d1221d1ffffffff101dddddffffffff1d1d1d1d1dffffffffff2032ffffff
00100000000000111010000000110000ff1dddddddddffffff1111000dfffffff1f10220df1fffffff111dddddffffffff1d1d1d1d1dffffffffff23b2ffffff
10100000000000110110000011110000ff1dddddddddffffff1010000dfffffffff10000dfffffffff101dddddffffffff1d1d1d1d1dffffffffff2332ffffff
11100000000000111010000000110000ff1dddddddddffffff010ddd0dfffffffff11ddddfffffffff01ddddddffffffff1d1d1d1d1dffffffffff23b2ffffff
11100000000000110110000011110000ff1dddddddddffffff101dddddffffffffff1dddffffffffff10ddddddffffffff1d1d1d1d1dffffffffff23b2ffffff
11100000000000111010000000110000ff1dddddddddffffff101ddd0dffffffffff01d0ffffffffff0000000dffffffff1d1d1d1d1dffffffffff23b2ffffff
11100000000001110110000011110000ff1dddddddddffffff1111dd0dffffffffff01d0ffffffffff0d11110dffffffff1d1d1d1d1dffffffffff23b2ffffff
10100000000001111010000000110000ff1dddddddddffffff101111ddffffffffff0000ffffffffff1d11110d1fffffff1d1d1d1d1dffffffffff23b2ffffff
00100000000001110110000011110000ff1dddddddddffffff110001ddffffffffff1001ffffffffff1d11110ddfffffff1d1d1d1d1dfffffffff223b22fffff
00000000107070700707070710101000ff1dddddddddffffff1000000dffffffffff1111ffffffffff1d11110ddfffffff110d1d1d1dffffffff22333b22ffff
00000000170707077070707010101000ff1100000001ffffff1000000dffffffffff1221ffffffffff1dd1110d1fffffff11011d1d1dfffff222233bb3b2222f
00000000107070700707070710101000ff1000001111ffffff0111111dffffffffff1111ffffffffff01ddddddffffffff11011d1d1dfffff2b333b3b3b33b2f
00000010170707077070707010101000ff1000111111ffffff22111122fffffffffffddfffffffffff21111112ffffffff11010d1d1dfffff2b3333bbb33bb2f
00000010107070700707070710101000ff1011111111ffffffffffffffffffffffffffffffffffffffffffffffffffffff1101011d1dfffff2b333b3bb33bb2f
000000d0170707077070707010101000ff1111111011ffffffffffffffffffffffffffffffffffffffffffffffffffffff1101010d1dfffff2bb333bb333bb2f
000000d0107070700707070710101000fff21111002fffffffffffffffffffffffffffffffffffffffffffffffffffffff110101011dfffff2bbbb333bb3bb2f
0000000d170707077070707010101000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff110101011dfffff2b00b33bb300b2f
000000000010000000000000000000000000000000000000000000000000000000000000000000000000000fffffffffff1101010111fffff203b0bbbb03b02f
00000280110010001d1d1d1d088808880888008800880000080008000000880888000008880008008880000fffffffffff1111111111fffff20330b33b03302f
2000282010100000dddddddd080808080800080008000000028082000008280808000002280082082228000fffffffffff1100000001fffff22b0330303b022f
8202820011010000dddddddd088808820888088808880000002820000008080882000000820080080008000fffffffffff1000000011ffffff223303003b22ff
28282000110000001d1d1d1d082208280800000800080000008280000008080828000008200080080008000fffffffffff1000011111fffffff2233000b22fff
828200001000000011111111080008080888088208820000082028000008820808000008880820028882000fffffffffff1000111111ffffffff23b30bb2ffff
2828200010100000dddddddd020002020222022002200000020002000002200202000002220200002220000fffffffffff1101111011ffffffff223bbb22ffff
2222220011000000000000008888888888888888888888888888888888888888888888888888888888888ffffffffffffff21111002ffffffffff222222fffff
000000000000000066666666ffffffffffffffffffdd1111ffffffffffffffffffffffffffffffff6666666666ddd111ddddddfffffffffffffff222222fffff
000000000000001066666666ddddddddffffffdd1111111dffffffffffffffffffffffffffffffff666666666dddd1111dddd1fffffffffffffff2000b22ffff
000000000000001066666666ddddddddffffd1ddddddd1ddfffffffffffffddddddd666ddfffffff666666666ddd611111ddd1dfffffffffffff233000b2ffff
00000000000000106666666666666666fffd111d1ddd1dddfffffffffddddddd66666666dddfffff666dd666ddd66d11111dd11dddffffffffff230300b2ffff
0000000000000001dddddddd66666666fff11111ddddddddffffffffddd6666666666666dd1dffff66ddd666ddd666dddd11111000dfffffffff233300b2ffff
0000000000000001dddddddd66666666ffdddddddddddd11ffffffdd666666666666d66ddd11ffff6ddd666ddd66666ddddddd0000dfffffff22233bb0b222ff
0000000000000000dddddddd66666666ff11111111111000fffffdd761d66666666d66ddddd1dfffd6dd6666d6666ddd111ddd1dddfffffff223303bbb3bb22f
0000000000000000dddddddd66666666ff10011881881880ffffddd11ddddd6666666d11ddd1dfffd6d6666666666ddddd11dd1dddddfffff23b330bbb3bbb2f
000000000000000001d6dfffddddddddfd00111881881880d1110000ddddddddddddddd66dddd666d6666dd66666666666d11dddddddddfff23b3033bb33bb2f
000000000000000001ddffffddddddddf100001881881880fd100000dddddddddddd66666dd66666dddd6dd66666666666d1dddd11dd66dff23bb303bb333b2f
0000000000000000011dffffddddddddf100010881881881ffffd000ddddddddd6666666d666666dddddddddd666666666d1dd111ddddddff23bbb333bbbbb2f
00000000000000000111ffffddddddddd100010881881881fffff000dddddd6666666ddd666666ddddddddddd66666dd66d1dddd111111ddf2300b033bb00b2f
00000000000000000010ffffddddddddd100010881881881fffff000ddddd666666dddd666666ddddddddd111d666ddddddddddd111111ddf2000b3033b0002f
0000000000000000000fffff11111111d111011111111111fffff00011111111111111111111111111dddd111d666dddddddd1d11dd11d6df230303b3333332f
000000001111111100ffffff00000000dd111111dd1dd11dffffff00000000000000000000000000d66666666dd6dddddddd11ddd1111ddff222330bb332222f
0000000011111111ffffffff00000000fd11111111111111ffffff0000000000000000000000000000000001d6ddddddddd111d111111ddffff22230b322ffff
00000000dddddddd1111111100001100fddd1111d11dd11dffffff0011111111111d111111111111188188001ddddddddd1dd11111111ddffffff223b22fffff
00000000dddddddddddddddd00011110fd111111111dddddfffffff0dddddddddddddddddddddd1d188188101ddddddddd1d6d1111111ddfffffff20b2ffffff
00000000dddddddd111111110011ddd1ffd1111111111111fffff00011111111111111111111dddd188188111dd1ddddd11ddd111111dddfffffff2332ffffff
00000000dddddddd11111111001dddd1fffd111111111111f0000000111110011111111110011111188188010dd11111111dd1111111dddfffffff23b2ffffff
00000000dddddddd1111111100111111ffff11111111111100000000111110111111111110011111188188010dd11111111dd11111d1d1dfffffff2332ffffff
00000000111111110000000000111111fffff0000000000000000000000000111111ddd111001111188188110d111111111d11111111111fffffff23b2ffffff
00000000000000000000000011111111ffffff0001110000f00000000000001dddddddddd1100000d11d111111d11111111d11111111111fffffff23b2ffffff
00000000000000000000000011111111fffffffd11111000ffff00000000001ddddddddddd100000dddddd111ddd111111d111111111111fffffff2332ffffff
000000000000000000001188ddddddffffffffffffddd1111dddd666111110001100011011dd1fff11111111dddd111111d1011d111101dfffffff20b2ffffff
00000000000000000000118811dd66dffffffffffddd111111ddd666111110011000110111dddfff1111111dddd111111dd0011d111001dfffffff23b2ffffff
0000000000000000000011881ddddddfffffffffdd11111111dddd66111100110001000111dddfffddddddddddd111111d001111100001dfffffff2032ffffff
000000000000000000001188111111ddffffffddd1dd1111111ddddd000000000000000111d6dfff111ddddddd1111111111111d000001dfffffff2333ffffff
000000000000000000001188111111ddfffffddd11d1dd1111dddddd000000000000000111d6dfff1111111111111111111d1dff1000011fffffff2032ffffff
0000000000000000000011881dd11d6dffff1dddd111ddd111d6dddd000000010000000011d6dfff111111111111111111dd1fff1000001fffffff2222ffffff
00000000111111111111111dd1111ddfffd11ddd1111dddd111ddddd000000010000000001d6dfff011100000111101111dddfff0000000fffffffffffffffff
00000000111111111111dd1d11111ddfd1ddddddddddddddd111111d000000010000000001d6dfff111100001110011011dddffff00000ffffffffffffffffff
ffff01dffffffffffffffffffffffffffffdddddddddddddddddddd1dddddd66666666ddd1dddddddd111dd111111111111dddd1dd1111dddddddddd10000000
ffff01dffffffffffffffffffffffffffddd66666666ddddddddddddddddddddddddddd1ddddddd111dddd11111111111dddd1dd111111111d11dd1000000000
ffff01dfffffffffffffffffffffffffdd6666666ddddddddd66666666ddddddddddddd1ddddd1d11dddd111111111dddd11ddd1111111111dd1100000000000
ffff01dfffffffffffffffffffffffddd6666666dddddddd6666666666666ddd1111111dddd1111ddddddd111111ddd111ddd1111111111ddd00000000000000
fff0011fffffffffffffffffffffdd66666666dddddddd66666666666666ddddd111111d11111dddddd11dd111ddd111ddd111111111dddd1000000000000000
ff00001ffffffffffffffffff1dd666666dddddddddd66666666666666dddddddddddd11111ddd1111111d11ddd111ddd111111111dddd100000000000000000
f000000ffffffffffffffff11d666666dddddddddd66666666666666d6dddddddddd1111111111111111ddddd111ddd111111111dddd10000001110000000000
f00000fffffffffffffff1dd666666dddd1ddddd66666666666666dddddddddddd1111111111111111ddddd111ddd111111111dddd100001dddddd1110000000
ffff0000fffffffffff11d666666dddd11dddd6666666666666dddddd66ddddd1111111111111111ddddd111ddd111111111dddd1000011ddddd6ddd11000011
ffff0000fffffffffffdd66666ddddd1dd1d6666666666666ddddddd6ddddd11111111111111111ddd1111ddd11111111ddddd1000001dd666ddd11111000011
fffff000fffffffffffd66666ddddd1d1d6666666666666dddddddddd1dd11111111111111111ddd111111d11111111dd11110000011ddd6ddd1000011100011
fffff000ffffffffffd6666dddddd11dd6666666666666ddddddddd1ddddd111111111111111ddd111111d1111111dd11110000001dd11d111011000001101d1
fffff000ffffffffffd666ddddddddd6666666666666d1ddddddd11ddddddd1111111ddddd1ddd11111d111111dd1111100000001d111d1101111110001d0d01
fffff000fffffffffffd66dddddddd66666666666661dddddddd1ddddddddd1d111ddddddddd111111d11111dd111110000000011111d1111111111100010001
ffffff00fffffffffff1dddd1dddd666666666666ddd11ddddddddddddddddddddddddddddd111dd11d111d11111100000000001111110111111111110010111
ffffff00ffffffffffff1ddd111d666666666666ddddd11d1dddddddddddddddddddddddd11111dd11d11111111000000000001d1d11011100000001110001dd
fffffffffffffffffffff11dddd666666666666ddddddd11ddddd1d1111ddddddddddddd11111ddd1111111110000000000001ddd11110000000000001101ddd
ffffffffffffffffffffff111ddd6666666666ddddddd111d1111111111ddddddddddddd111111111111111000000000000001dd100100000000000000100dd1
ffffffffffffffffffffff1111111dd666666dddddd1111ddd11111dddddddddddddddd111111111111110000000000000001dd1001000011111100011110110
fffffffffffffffffffffff111111111dd66d1dddd1d1111111111111111111111111111111d1d11111000000000000000001d100100011111111100d1010000
fffffffffffffffffffffff1d1111111111dddd1111d111111111111111111111111111111dddd1110000000000000000001d100100011111111111001110001
ffffffffffffffffffffff11d1111111111d11ddd1d1111111111111111111111111111111dd1110000000000000000000011001001111111111111101100011
fffffffffffffffffffffddddd111d1111111101dd11000001111111111111111111111111111100100000000000000000010000001111111111111101d00001
ffffffffffffffffffffd66dddd11d111111111100011000000000000000000001111d11111101111000000000000000000000000011d1010111111110110001
fffffffffffffffffffd66d6dd1dd111111111110000110000000000000111111111dddd111111110000000000000000000000001111d1110011111110110001
fffffffffffffffffff1dd666d11dd1111111111111001100000000000000111111d111d11111100000000000000000000000000110d1d1101d1111110110001
fffffffffffffffffffd1d666610ddd111111111111111100000000000001111111111111111100000000000000000000000001011dddd110dd11111111d0001
ffffffffffffffffffff1dd666d10ddd1111111ddd11111100000000000011111111ddddd1d100000000000000000000000000d1ddd11d1d1d11111111110000
fffffffffffffffffffff1d6666d101dd111111111dd11111000000000001111110ddd6dddd100000000000000000000000001111ddd11111d111111111d0000
ffffffffffffffffffffff1d666dd001ddd1111111111ddd11000000000011111111d6666dd1100000000000000000000000011111d1d1ddd111111d11110000
fffffffffffffffffffffffddd6ddd1011dddd1111111111d10000000000011111d166666dddd0000000000000000000000001111111d1ddd111111d11110000
ffffffffffffffffffffffff1d666ddd1111dd7d11111111111000000000011111111d6dd1dd1000000000000000000000001d111111dd1d110d111d11110000
ffffffffffffffffffffffff1d666666dd11111d6dd11111111100000000001111d111111ddd100000000000000000000000001ddd1111d11d1dddddd1111000
fffffffffffffffffffffffff16dd6666d1111111d6dd1111116100000000011d1111111111d1000000011000000000000000111dd1111111d1ddd1dd0d11000
ffffffffffffffffffffffffffddddd6666d1100111dddd111116000000011ddd110001111dd0000001110000000000000001111dd1ddd11d1dddd1dd0d10000
fffffffffffffffffffffffffff1ddddd666d110000111d6dd1111100011dd111000000111100011111110001100000000001111d1dd11dd11dddddd11110000
ffffffffffffffffffffff00001ffddddd6666d100000111d6dd100011dd110000000000011001dd1111011dd6d0000000001111d6d111dddddd6ddd11110000
ffffffffffffffffffffff02201ffffddddd6666d110000111dd100111110000000000000000111001011d66666100000000d1ddd11111dddddd6ddd0d000000
fffffffffffffffffffff002201ff00011dddd6666dd110000111000000000011111111111100011111d666666d100000000d01d11d10dddddddddd11d100000
fffffffff00001ffffff0022201f00200111dd0000666d00000000222222220000011111111111111d6666666d110000000011111d100dddddddddd111100000
ffffffff0022011fffff0222001f0222201f0002200066f22000022222222222220000011d11111dd6666666d10000000000d111dd111ddd6ddddd11d1000000
ffffffff0222001fffff022201ff00222010022222200602220d0000000222222222000011dd1d66666666d1100000000000d11d111dddd666dddd1111000000
ffffffff0222201fffff022201ff10022000222222220102220d111111000022222222000001d6666666d1100000000000001d111d11d6dd66ddd11100000000
ffffffff0222201ffff0022201ff00000002222002220002220d660000111002222222220006666666d110000000000000000d11111d11d666dd11011000000f
ffffffff02222001fff0222201f002001022220002220022200ddd02200dd002220022222200d66dd11000010000000000000d111dd11d666dd11101000000ff
ffffffff02222201fff022200100222000222001022200222011100220066022200000222220dd111000010000000000000001d111dddddddd11100000000fff
fffffff002222201ff0022201f022200022220110022002220110022001110222011100022001100000100f000001000000001d111d111ddd11101100000ffff
fffffff022222201ff0222001f0222000222001ff020002220110222011100222010011000100000010ffff000001000000000101101dd1111111100000fffff
fffffff022222001ff022201f0022200222201fff0001222001002200111022200100101110000010fffffff0000000000000000011111111111100000ffffff
fffffff02222201fff022201f0222000222001ff001102220000222011100222010000000001100ffff100000000000000000000000111110000000000000fff
fffffff02222201110022201f022200022001fff000002222222220000002220010222222000ffffff1002220000001002222222000001101100222222220fff
fffffff022222000102220010022200222000000000022222222220000002220102222222220ffffff1022200000011022222222200111001102222222200fff
ffffff00222022201022201f0222000220002222200022222222200000002220102221112220ffffff1022201f0001102220002222011110110222000000ffff
ffffff02220022200022001f0222000220022222220022200022200000022200102220002220ffffff102220fff0011022211002220010001102220fffffffff
ffffff0222002220022201ff0222002220022222220022000222000000022201002220022210ffffff102220ffff0110222011022220000111022200000fffff
ffffff0222000222022201ff022200222000222222022200022200000022200100222222210ffffff1002220fffff100222001022220000110022222220fffff
fffff00222010222022201ff022200222010002220022200022200000022201002222222200ffffff1022200ffff1102220001022210000110222222220fffff
fffff022200f0222022201ff022200222011002220222001022200000022201002221122220ffffff1022201ffff1102220001022200000110222000000fffff
fffff022201f1022222001ff022200222000022200222001022200000222001002220012220ffffff102220fffff110222000102220ffff1102220ffffffffff
fffff02200fff02222201fff022000222200222000222010222200000222010002220002220ffffff102220fffff110222001022210fff1110222000000fffff
fffff00001fff00222201fff0000100222022220022200102220000002220100022200022200ffff1002220ffff110022201022210ffff1100222222220fffff
fffff1111ffff10222201fff11111f0222222200022201f022201ff022200100222100012220ffff1022210ffff11022222222110fffff1102222222220fffff
ffffffffffffff0022001fffffffff002222000100000ff00000fff0000110001111000111100000111110000000001111111100000000000111111111100fff
ffffffffffffff100001fffffffffff00000011f11111ff11111fff11111fff02222222222222222222222222222222222222222222222222222222222220fff
__label__
00000000000000000000000000000000000dddddddddddddddddddd1dddddd66666666ddd1dddddddd111dd111111111111dddd1dd1111dddddddddd10000000
000000000000000000000000000000000ddd66666666ddddddddddddddddddddddddddd1ddddddd111dddd11111111111dddd1dd111111111d11dd1000000000
00000000000000000000000000000000dd6666666ddddddddd66666666ddddddddddddd1ddddd1d11dddd111111111dddd11ddd1111111111dd1100000000000
000000000000000000000000000000ddd6666666dddddddd6666666666666ddd1111111dddd1111ddddddd111111ddd111ddd1111111111ddd00000000000000
0000000000000000000000000000dd66666666dddddddd66666666666666ddddd111111d11111dddddd11dd111ddd111ddd111111111dddd1000000000000000
00000000000000000000000001dd666666dddddddddd66666666666666dddddddddddd11111ddd1111111d11ddd111ddd111111111dddd100000000000000000
0000000000000000000000011d666666dddddddddd66666666666666d6dddddddddd1111111111111111ddddd111ddd111111111dddd10000001110000000000
0000000000000000000001dd666666dddd1ddddd66666666666666dddddddddddd1111111111111111ddddd111ddd111111111dddd100001dddddd1110000000
000000000000000000011d666666dddd11dddd6666666666666dddddd66ddddd1111111111111111ddddd111ddd111111111dddd1000011ddddd6ddd11000011
0000000000000000000dd66666ddddd1dd1d6666666666666ddddddd6ddddd11111111111111111ddd1111ddd11111111ddddd1000001dd666ddd11111000011
0000000000000000000d66666ddddd1d1d6666666666666dddddddddd1dd11111111111111111ddd111111d11111111dd11110000011ddd6ddd1000011100011
000000000000000000d6666dddddd11dd6666666666666ddddddddd1ddddd111111111111111ddd111111d1111111dd11110000001dd11d111011000001101d1
000000000000000000d666ddddddddd6666666666666d1ddddddd11ddddddd1111111ddddd1ddd11111d111111dd1111100000001d111d1101111110001d0d01
0000000000000000000d66dddddddd66666666666661dddddddd1ddddddddd1d111ddddddddd111111d11111dd111110000000011111d1111111111100010001
00000000000000000001dddd1dddd666666666666ddd11ddddddddddddddddddddddddddddd111dd11d111d11111100000000001111110111111111110010111
000000000000000000001ddd111d666666666666ddddd11d1dddddddddddddddddddddddd11111dd11d11111111000000000001d1d11011100000001110001dd
00000000000000000000011dddd666666666666ddddddd11ddddd1d1111ddddddddddddd11111ddd1111111110000000000001ddd11110000000000001101ddd
0000000000000000000000111ddd6666666666ddddddd111d1111111111ddddddddddddd111111111111111000000000000001dd100100000000000000100dd1
00000000000000000000001111111dd666666dddddd1111ddd11111dddddddddddddddd111111111111110000000000000001dd1001000011111100011110110
00000000000000000000000111111111dd66d1dddd1d1111111111111111111111111111111d1d11111000000000000000001d100100011111111100d1010000
000000000000000000000001d1111111111dddd1111d111111111111111111111111111111dddd1110000000000000000001d100100011111111111001110001
000000000000000000000011d1111111111d11ddd1d1111111111111111111111111111111dd1110000000000000000000011001001111111111111101100011
000000000000000000000ddddd111d1111111101dd11000001111111111111111111111111111100100000000000000000010000001111111111111101d00001
00000000000000000000d66dddd11d111111111100011000000000000000000001111d11111101111000000000000000000000000011d1010111111110110001
0000000000000000000d66d6dd1dd111111111110000110000000000000111111111dddd111111110000000000000000000000001111d1110011111110110001
00000000000000000001dd666d11dd1111111111111001100000000000000111111d111d11111100000000000000000000000000110d1d1101d1111110110001
0000000000000000000d1d666610ddd111111111111111100000000000001111111111111111100000000000000000000000001011dddd110dd11111111d0001
000000000000000000001dd666d10ddd1111111ddd11111100000000000011111111ddddd1d100000000000000000000000000d1ddd11d1d1d11111111110000
0000000000000000000001d6666d101dd111111111dd11111000000000001111110ddd6dddd100000000000000000000000001111ddd11111d111111111d0000
00000000000000000000001d666dd001ddd1111111111ddd11000000000011111111d6666dd1100000000000000000000000011111d1d1ddd111111d11110000
00000000000000000000000ddd6ddd1011dddd1111111111d10000000000011111d166666dddd0000000000000000000000001111111d1ddd111111d11110000
0000000000000000000000001d666ddd1111dd7d11111111111000000000011111111d6dd1dd1000000000000000000000001d111111dd1d110d111d11110000
0000000000000000000000001d666666dd11111d6dd11111111100000000001111d111111ddd100000000000000000000000001ddd1111d11d1dddddd1111000
000000000000000000000000016dd6666d1111111d6dd1111116100000000011d1111111111d1000000011000000000000000111dd1111111d1ddd1dd0d11000
00000000000000000000000000ddddd6666d1100111dddd111116000000011ddd110001111dd0000001110000000000000001111dd1ddd11d1dddd1dd0d10000
0000000000000000000000000001ddddd666d110000111d6dd1111100011dd111000000111100011111110001100000000001111d1dd11dd11dddddd11110000
00000000000000000000000000100ddddd6666d100000111d6dd100011dd110000000000011001dd1111011dd6d0000000001111d6d111dddddd6ddd11110000
0000000000000000000000082010000ddddd6666d110000111dd100111110000000000000000111001011d66666100000000d1ddd11111dddddd6ddd0d000000
0000000000000000000000022010000011dddd6666dd110000111000000000011111111111100011111d666666d100000000d01d11d10dddddddddd11d100000
000000000000010000000022201000200111dd0000666d00000000222222220000011111111111111d6666666d110000000011111d100dddddddddd111100000
0000000000220110000002220010022220100002200066022000022222222222220000011d11111dd6666666d10000000000d111dd111ddd6ddddd11d1000000
000000000222001000000222010000222010022222200602220d0000000222222222000011dd1d66666666d1100000000000d11d111dddd666dddd1111000000
000000008282201000008282010010822000828282820182820d111111000082828282000001d6666666d1100000000000001d111d11d6dd66ddd11100000000
000000000828201000000822010000000008282008220008220d660000111008282828220006666666d110000000000000000d11111d11d666dd110110000000
000000008282200100008282010082001082820082820082200ddd82200dd082820082828200d66dd11000010000000000000d111dd11d666dd1110100000000
0000000008282201000828200108282008282001082208282011100820066828200008282820dd111000010000000000000001d111dddddddd11100000000000
000000008282820100008220108282008282201100820082201100820011108220111000820011000001000000001000000001d111d111ddd111011000000000
000000082828220100082200100822000822001008200828201108220111082820100110001000000100000000001000000000101101dd111111110000000000
00000000828220010082820100828200828201000000828200108220011182820010010111000001000000000000000000000000011111111111100000000000
00000008888820100088820108882008882001000011888200088820111088820100000000011000000100000000000000000000000111110000000000000000
00000008888820111088820108882008820010000000888888888200000888200188888820000000001088820000001088888882000001101108888888820000
00000008888820001888200108882088820000000008888888888200000888201888888888200000001888200000011888888888200111001188888888200000
00000008882888201888201088820088200888882008888888882000000888201888211888200000001888201000011888200888820111101188820000000000
00000088820888200882001088820088208888888208882008882000008882001888200888200000001888200000011888211088820010001188820000000000
00000088820888208882010088820888208888888208820088820000008882010888208882100000001888200000011888201188882000011188820000000000
00000008220008220822010008220828200828282208220008220000082820010828282821000000010828200000010888200188882000011088888882000000
00000082820182828282010082820082201000822082820082820000008220108282828220000000018282000000118282000182821000011082828282000000
00000028200008220822010008220828201108282828200108220000082820100822182822000000010822010000110822000108220000011828200000000000
00000082201010828220010082820082200082820082200182820000828200108282008282000000018282000000118282000182820000011082200000000000
00000022000008282820100008200828220828200828201828220000082201000822000822010100010822000000110822001828210000111828200000000000
00000000010000828220100000001082828282208282001082200000828201008282008282000010108282000001108282018282100000110082828282000000
00000111100001082820100011111008282822000822010828201008282001082821000828200000182821000001182828282211000000110828282822000000
00000000000000002200100000000000222200010000000000000000000110001111000111100000111110000000001111111100000000000111111111100000
00000000000000100001000000000000000001111111100111110001111100002222222222222222222222222222222222222222222222222222222222220000
00000000000000000000000000000000000010100000000000000000000000001000000000000000000000000010100000000000000000000000000000000000
00000000000000000000000000000000010101000000000000000000000000010100000000000000000000000001010100000000000000000000000000000000
00000000000000000000000000000000101000000000000000000000000000001000000000000000000000000000001010000000000000000000000000000000
00000000000000000000000000000101000000000000000000000000000000010100000000000000000000000000000001010000000000000000000000000000
00000000000000000000000000101000000000000000000000000000000000101010000000000000000000000000000000001010000000000000000000000000
00000000000000000000000101000000000000000000000000000000000000010100000000000000000000000000000000000001010000000000000000000000
00000000000000000000101000000000000000000000000000000000000000101010000000000000000000000000000000000000001010000000000000000000
00000000000000000101000000000000000000000000000000000000000000010100000000000000000000000000000000000000000001010000000000000000
00000000000000101000000000000000000000000000000000000000000000101010000000000000000000000000000000000000000000001010000000000000
00000000000101000000000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000001010000000000
00000000101000000000000000000000000000000000000000000000000000101010000000000000000000000000000000000000000000000000001010000000
00000101000000000000000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000000000001010000
00101010000000000000000000000000000000000000000000000000000000101010000000000000000000000000000000000000000000000000000000101010
01010000000000000000000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000000000000000101
10000000000000000000000000000000000000000000000000000000000010101010100000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000010101010100000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000010101010100000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000101010101010000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000010101010100000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000101010101010000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000010101010100000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000101010101010000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001010101010101000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000101010101010000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001010101010101000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000101010101010000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001010101010101000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000010101010101010100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001010101010101000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000010101010101010100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000001010101010101000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000010101010101010100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000101010101010101010000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000010101010101010100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000101010101010101010000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0000000000000000000000ac0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010300000842409424094240a4240a4240a4240b4240b42401424014240242403424034240442404424034240342402424004240a424074240542403424024240242402424024240241402414024140241402424
000100003264732647326271d657196571665714657116570f6570e6570c6570c6570b6570a657096570965708657076570665705657046470464703637036370362703627036270362703617036170361703617
000100000c4410a44108441064410544103441024510245132601326013260132601306013060130601306012f6012f6012f6012e6012d6012d6012c6012c6012b60100001000010000100001000010000100001
010800000c2210c2210c221002210022100211022110a211070410303102031010411e631176411d6321a6320d63212642126420864210632106420e642056420a63208632066220061203612026120061200012
010a002018722187211872118731187311d7411d7511d7611d7611d7611c7611c7621c7621c7621c7621c7621876118761187611876118761187511f7611f7611f7611f7621c7621c7621c7621c7621c7621c762
011e00000c0520c0520c0520c0520c0520c0520c0520c0520d0510d0520d0520d0520d0520d0520d0520d05219052190521905219052190521905219052190521903119031190311903119031190311903119035
011400080c77300170001700007000000046750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011e00001505215052150521505215052150521505215052160511605216052160521605216052160521605216052160521605216052160521605216052160522203122031220312203122031220312203122035
011e00001f0521f0521f0521f0521f0521f0521f0521f0521e0511e0521e0521e0521e0521e0521e0521e0521e0521e0521e0521e0521e0521e0521e0521e0521e0311e0311e0311e0311e0311e0311e0311e035
010f00201811318113306133061318313306133061330613181131811330613306131831330613306133061318113181133061330613183133061330613306131811318113306133061318313306133061330613
011e00001e1111e1211e1211e1211e1211e1211e1221e122231001d1111d1221d1221d1201d1201d1201d1201a1001c1111c1221c1201c1201c1201c1201c1221a1001b1111b1221b1211b1201b1201b1221b122
011e00202a5112a5112a5112a5112a5112a5112a5122a5122f5102951129512295122951029510295102951027510285112851228512285102851028510285102a51027510275122751123510235101f5101f512
010f00081814330600000003060018323306233060030600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011e0000110521105211052110521105211052110521105212051120521205212052120521205212052120521e0521e0521e0521e0521e0521e0521e0521e0321e0311e0311e0311e0311e0311e0311e0311e035
011400000c5100c53017540175501757015571155701557010570105701057010570105700e5700e5701057011570115701157011570115700e5700e5700f5701057010571105701057110572105721057210572
01050000025340453406534095340b5340e534115341353416524185241c5241d52420524225242452426524285142b5142d5142e51430514325143451435514365133751337515185142451418514185140c514
010f0000021730217302173071000e1730e1730e1730e17307100071000217302173021730217307100071000e1730e1730e1730e1730810009100021730217302173021730f100111000e1730e1730000000000
010f00001d0111d0211d0311d0511d0711d0721d0721d0721c0311c0411c0511c0701c0701c0701c0721c0721b0721b0721b0721b0721b0721b0721b0701b0701a0711a071180711807118071180721807218072
010f00002451124521245312454124541245421d5421d5421c5411c5411c5411c5401c5401c5401c5421c542235412354123541235412354123541235401a5401d5411d5411d5411f5411f5411f5421f5421f542
010f00002451124521245312454124541245421d5421d5421c5411c5411c5411c5401c5401c5401c5421c5421854118541185411854118541135411354013540105410c5410c5410c5410c5410c5420c5420c542
000f0008041730e60034623000001c625000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00000010507175071750717507175071750717507175071750010507175071750717507175071750717505175001050517505175051750517505175051750517505175051750517505175051750517505175
010f00001a7751a7751a7751a7751a7721a7721a7721d7701d7701d7701d7701d7701d7701f7701f7701f7701f7701f7701f7701f7721f7721f7721f7721f7721f7701f7701f7701f7701f7721f7721f7721f772
010f00001f7751f7751f7751f7701f7721f7722277022770227702277022772227722277222770227752277524775247752477524775247722477224772247722477224772247722477224772247722477224772
010f00000010504175041750417504175041750417504175041750010504175041750417504175041750417500000021750217502175021750217502175021750217502175021750217502175021750217500000
010700000c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c6440c644
010500000c0530d0530d0530e0530e0530e0530e0530f05310053110531205313053150531605317053190531a0531c0531d0531f05321053230532405325053280532a0532d0533005332053340533705337053
0107000007331033310b32108321043210b3110631102310006000060000600006000060000600006000060000002000000000000000000000000000000000000000000000000000000000000000000000000000
01070000133310f33117331143311033117331123310e33011234102340f2350e2350e2250b22504215002150c203002020020200202002020020200202002020000200000000000000000000000000000000000
010600000000030620000002d620000002b620000002962025620236201f6201c6201f62025620296202b620226201e6201e6201d6201d620206202162021620216201e6201c6201962017620146200d6200d620
0107000014620236202f6202f6202262018620176200d6200c6200f6200d620116201562016620106201162011620136200f620166200d62010620106200c620126200e620166201262014620156200f6200d620
010500000002002620026200862000620006200262002620036200462005620086200c6200f620106203362035620306202d62027620256202362021620206201e6201c6201a620186201762016620136200d620
010d00001015518155101551815510155181551015518155101551815510155181551015518155101551815510155231251015523125101552312510155231251015523125101552312510155231251015523125
010d00000f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b1550f1551b155
010f0000111552115511155211551115521155111552115511155211551115521155111552115511155211550e1551d1550e1551d1550e1551d1550e1551d1550e1551d1550e1551d1550e1551d1550e1551d155
010f00001515523155131552315513155231551315523155131552315513155231551315523155131552315515155241551515524155151552415515155241551515524155151552415515155241551515524155
010f00000016200162001620016200162001620016200162001620016200162001620016200162001620016207162071620716207162071620716207162071620716207162071620716207162071620716207162
010f00000416204162041620416204162041620416204162041620416204162041620416204162041620416205162051620516205162051620516205162051620516205162051620516205162051620516205162
__music__
04 050d0708
01 47460844
01 45060e46
02 45060444
01 094b4344
01 094b4344
01 090a4344
01 090a0b44
01 090a4344
01 090a0b44
01 094a4344
01 0c104b44
01 0c104344
01 0c101144
01 0c101144
01 0c101112
01 0c101113
01 0c101152
01 0c101144
00 4c101244
00 41101344
01 1415564f
01 14185644
01 14151644
01 14185617
01 1415160c
01 140c1817
01 1415560c
01 140c1857
01 1415560c
01 140c1857
01 1415160c
01 140c1817
01 5415164c
02 41181744
01 0c101144
01 0c101144
01 0c101112
01 0c101113
01 0c101152
01 0c101144
01 4c101244
01 41101344
01 094b4344
01 094b4344
01 090a4344
01 090a0b44
01 090a4344
01 090a0b44
01 090a4344
01 090a0b44
01 20646444
02 21656544

