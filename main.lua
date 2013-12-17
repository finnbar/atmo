t = {} --yes I'm using vague names FTW
a = {"Na","Cl","H","O","Cu","C"} --atoms
p = {1,1} --position
h = 2 --height, has to be remembered as can't be represented by #t
w = 3 --width
s = 150 --size (grid spacing etc.)
f = love.graphics.newFont("OpenSans-Regular.ttf",100)
e = 1 --where to place new things
m = false
c = {{"Na","Cl"},{"O","C","O"}} --combinations!

function love.load()
	love.graphics.setFont(f)
	love.window.setTitle("YOU MUST GET THE ATOMS (ONCE AGAIN)")
	for x=1,6,1 do
		table.insert(t,{})
		for y=1,6,1 do
			table.insert(t[x],0)
		end
	end
end

function love.draw()
	love.graphics.setNewFont(12)
	love.graphics.print("q to expand",2,0)
	love.graphics.print("w to unexpand",2,15)
	love.graphics.print("r to add a random atom",2,30)
	love.graphics.print("t to remove highlighted",2,45)
	love.graphics.print("space to switch atoms",2, 60)
	love.graphics.setFont(f)
	for x=1,w,1 do
		for y=1,h,1 do
			if x==p[1] and y==p[2] then love.graphics.rectangle("line",x*s,y*s,s,s) end
			if t[x][y]~=0 then
				if a[t[x][y]]~=nil then
					love.graphics.print(a[t[x][y]],x*s,y*s,0,s/150,s/150)
				end
			end
		end
	end
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
	for x=1,w,1 do
		for y=1,h,1 do
			if t[x][y]~=0 and t[x][y]~=nil then
				for u in pairs(c) do
					local x = x
					local y = y
					if c[u][1]==a[t[x][y]] then
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
								for d=1,#c[u],1 do
									print(c[u][d])
								end
							end
						end
					end
				end
			end
		end
	end
	print("\n")
end