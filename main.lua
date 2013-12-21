t = {} --yes I'm using vague names FTW
a = {"Na","Cl","H","O","Cu","C"} --atoms
p = {1,1} --position
h = 2 --height, has to be remembered as can't be represented by #t
w = 3 --width
s = 150 --size (grid spacing etc.)
f = love.graphics.newFont("OpenSans-Regular.ttf",100)
e = 1 --where to place new things
m = false --move, I think
c = {{"Na","Cl"},{"O","O","C"},{"N","N"},{"Cl","Cl"},{"H","Cl"},{"Cu","S","O","O"},{"Cu","Cu","O"},{"Na","H","C","O","O"},{"C","H","H"}} --combinations!
--[[ NOW, BEFORE ANYONE RANTS ABOUT IT SHOULD BE O-C-O:#
	The combination recognising engine is glitchy, ok?
	If the combination is presented as OCO, it accepts OC as well for some reason :/
	So I changed the combination. I probably should fix it, but meh.
	ALSO:
	Some combinations, such as CuSO4 have been shortened to make them easier to get. Some have also been shortened due to the fact that any element with >2 of a repeated element counts 2 of the repeated element as ok.
]]
--[[ SO, WHAT DOES EACH COMBINATION DO?
NaCl   Sodium Chloride -> Preserves effects (is a salt)
CO2    Carbon Dioxide -> Removes oxygen, reduces health of all in cloud
N2     Nitrogen -> is explosive. Deals high damaged when triggered by a bullet (or other projectile)
Cl2    Chlorine -> poisonous, gives poison
HCl    Hydrochloric Acid -> Can destroy floors or walls
CuS04  Copper Sulphate -> Crystal attack!
NaHCO3 Sodium Hydroxide -> An alkali, can dissolve organic material (gets into opponent's inventory and removes some atoms)
CH4    Methane -> Stuns opponent.
]]
q = {{0,255,0},{255,0,0},{0,0,255},{255,255,0},{0,255,255},{255,0,255},{180,180,180},{0,180,50},{50,0,180},{180,50,0},{50,50,0},{0,50,50}} --q for colours, like e for bonjour. taken from pixiapp
i = {} --combination highlighting, contains i[1-6][1-6]
g = false --remove things!


function love.load()
	love.graphics.setFont(f)
	love.window.setTitle("YOU MUST GET THE ATOMS (ONCE AGAIN)")
	for x=1,6,1 do
		table.insert(t,{})
		table.insert(i,{})
		for y=1,6,1 do
			table.insert(t[x],0)
			table.insert(i[x],0)
		end
	end
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.setNewFont(12)
	love.graphics.print("q to expand",2,0)
	love.graphics.print("w to unexpand",2,15)
	love.graphics.print("r to add a random atom",2,30)
	love.graphics.print("t to remove highlighted",2,45)
	love.graphics.print("space to switch atoms",2, 60)
	love.graphics.setFont(f)
	local b = {}
	for x=1,w,1 do
		for y=1,h,1 do
			love.graphics.setColor(255,255,255)
			if x==p[1] and y==p[2] then love.graphics.rectangle("line",x*s,y*s,s,s) end
			if t[x][y]~=0 then
				if a[t[x][y]]~=nil then
					love.graphics.setColor(255,255,255)
					love.graphics.print(a[t[x][y]],(x*s)+((10/150)*s),(y*s)+((10/150)*s),0,s/150,s/150)
					if i[x][y]~=0 then
						love.graphics.setColor(q[i[x][y]])
						love.graphics.rectangle("line",(x*s)+10,(y*s)+10,s-20,s-20)
						if not combWritten(b,i[x][y]) then table.insert(b,i[x][y]) end
					end
				end
			end
		end
	end
	love.graphics.setNewFont(20)
	for x=1,#b,1 do
		love.graphics.setColor(q[b[x]])
		for z=1,1,1 do --put a useless for loop in to keep q in its own scope
			local q = ""
			for y=1,#c[b[x]],1 do
				q=q..c[b[x]][y]
				if y<#c[b[x]] then q=q.."," end
			end
			love.graphics.print(q,630,x*50)
		end
	end
	for x=1,6,1 do
		for y=1,6,1 do
			i[x][y]=0
		end
	end
end

function combWritten(b,v)
	for d in pairs(b) do
		if b[d]==v then return true end
	end
	return false
end

function love.keypressed(key)
	if key=="left" then
		local g,b,d = 0,0,0
		if m then
			g=tonumber(t[p[1]][p[2]]) --just making sure that it's not a reference, i.e. c=(reference to)t[p[1]][p[2]]
			b=tonumber(p[1])
			d=tonumber(p[2])
		end
		if p[1]<2 then p[1]=w else p[1]=p[1]-1 end
		if m then
			t[b][d]=t[p[1]][p[2]]
			t[p[1]][p[2]]=g
		end
	end
	if key=="right" then
		local g,b,d = 0,0,0
		if m then
			g=tonumber(t[p[1]][p[2]])
			b=tonumber(p[1])
			d=tonumber(p[2])
		end
		if p[1]>w-1 then p[1]=1 else p[1]=p[1]+1 end
		if m then
			t[b][d]=t[p[1]][p[2]]
			t[p[1]][p[2]]=g
		end
	end
	if key=="up" then
		local g,b,d = 0,0,0
		if m then
			g=tonumber(t[p[1]][p[2]])
			b=tonumber(p[1])
			d=tonumber(p[2])
		end
		if p[2]<2 then p[2]=h else p[2]=p[2]-1 end
		if m then
			t[b][d]=t[p[1]][p[2]]
			t[p[1]][p[2]]=g
		end
	end
	if key=="down" then
		local g,b,d = 0,0,0
		if m then
			g=tonumber(t[p[1]][p[2]])
			b=tonumber(p[1])
			d=tonumber(p[2])
		end
		if p[2]>h-1 then p[2]=1 else p[2]=p[2]+1 end
		if m then
			t[b][d]=t[p[1]][p[2]]
			t[p[1]][p[2]]=g
		end
	end
	if key=="q" then
		local m = false
		if w<#t then
			w=w+1
			m=true
		end
		if h<#t then
			h=h+1
			m=true
		end
		if m then s=s-20 end
	end
	if key=="w" then
		local m = false
		if w>2 then
			w=w-1
			m=true
		end
		if h>2 then
			h=h-1
			m=true
		end
		if p[1]>w then p[1]=w end
		if p[2]>h then p[2]=h end
		if m then s=s+20 end
	end
	if key=="r" then
		for u=1,w,1 do
			if t[e][h]==0 or t[e][h]==nil then
				t[e][h]=love.math.random(1,#a)
				break
			else
				if e<w then e=e+1 else e=1 end
			end
		end
		if e<w then e=e+1 else e=1 end
	end
	if key=="t" then
		t[p[1]][p[2]]=0
	end
	if key==" " then
		m=not m
	end
	if key=="y" then
		g=true
	end
end

function love.keyreleased(key)
	if key=="y" then g=false end
end

function love.update(dt)
	for x=1,w,1 do
		for y=1,h,1 do
			if t[x][y]==0 or t[x][y]==nil then
				if t[x][y+1]~=0 then
					t[x][y]=t[x][y+1]
					t[x][y+1]=0
				end
			end
		end
	end
	combiFinder()
end

function combiFinder()
	local e = false
	for x=1,w,1 do
		for y=1,h,1 do
			if t[x][y]~=0 and t[x][y]~=nil then
				if i[x][y]==0 then
					for u in pairs(c) do
						local p = {}
						local x = x --make an adjustable version that doesn't affect the for loop
						local y = y
						if c[u][1]==a[t[x][y]] then
							table.insert(p,{x,y,u})
							for d=2,#c[u],1 do
								local o = false
								for b=-1,1,1 do
									for n=-1,1,1 do
										if (b==1 and n==0) or (b==0 and n~=0) or (b==-1 and n==0) then
											if (x+b)>0 and (x+b)<=w and (y+n)>0 and (x+b)<=h then
												if t[x+b][y+n]~=nil and t[x+b][y+n]~=0 then
													if c[u][d]==a[t[x+b][y+n]] then
														o=true
														x=x+b
														y=y+n
														table.insert(p,{x,y,u})
														break
													end
												end
											end
										end
									end
									if o then break end
								end
								if not o then break end
								if d==#c[u] then
									e=true
									local a = {}
									for d=1,#c[u],1 do
										if p[d]~=nil then
											local q = true
											for v in pairs(a) do
												if p[d][3]==a[v][3] and p[d][2]==a[v][2] then
													q=false
												end
											end
											if not q then
												e=false
												break
											end
										end
									end
									if e then
										for d=1,#c[u],1 do
											if p[d]~= nil then
												if not g then
													i[p[d][1]][p[d][2]]=p[d][3]
													print(p[d][1],p[d][2],p[d][3])
												else
													t[p[d][1]][p[d][2]]=0
												end
											end
											print(c[u][d])
											if g then print("removed") end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if e then print("\n") end
end

--anyone trying to make sense of this code is going to hate me by now. including me.