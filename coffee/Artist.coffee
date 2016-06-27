class window.Artist
	constructor: (@grid, @CTX) ->

	drawGrid: ->
		minmax = @grid.getMinMax()
		min = minmax.min
		max = minmax.max
		if min > max
			console.log "drawGrid(): no objects to draw"
			return
		
		for at in [min..max]
			cubes = @grid.grid[at]
			if(cubes?)
				_.each cubes, ((cube) ->
					if cube.type == conf.TYPES.LINEX
						@drawLineX cube.x, cube.y, cube.z
					else if cube.type == conf.TYPES.LINEY
						@drawLineY cube.x, cube.y, cube.z
					else if cube.type == conf.TYPES.LINEZ
						@drawLineZ cube.x, cube.y, cube.z
					else if cube.type == conf.TYPES.CUBE
						@drawCube cube
					else
						#console.warn "Cube without type"
						@drawCube cube
					)
				, @
	
	drawBlock: (block) ->
		# block.structure -> [viewValue, index]
		v_i = _.map block.structure, (c, i) -> [c.x+c.y+c.z, i]
		
		# Bubblesort
		for i in [0..v_i.length-1]
			for j in [0..v_i.length-2]
				if v_i[j][0] > v_i[j+1][0]
					[v_i[j], v_i[j+1]] = [v_i[j+1], v_i[j]]
			
		# Draw
		_.each v_i, ((_v_i) -> (@drawCube block.structure[_v_i[1]], block.position, block.color)), @
			

	drawCube: (cube, block={x:0,y:0,z:0}) ->
		
		x = cube.x + cube.block.position.x; y = cube.y + cube.block.position.y; z=cube.z + cube.block.position.z;
		
		color = if cube.color? then cube.color else if block.color then block.color else conf.DEFAULT_COLOR
		
		offX = 2 * (x - z)
		offY = x - 2 * (y) + z
		
		FACTOR = (offY+offX)
		
		colorTop   = "rgba(" + (color.r+FACTOR) + "," + (color.g+FACTOR) + "," + color.b + ", 1" + ")"
		colorRight = "rgba(" + (color.r-20+FACTOR) + "," + (color.g-20+FACTOR) + "," + (color.b-20) + ", 1" + ")"
		colorLeft  = "rgba(" + (color.r-40+FACTOR) + "," + (color.g-40+FACTOR) + "," + (color.b-40) + ", 1" + ")"
		
		strokeColor = if cube.block.selected then "#0FF" else "#333"
		
		@drawPolygon [[ 0+offX, 0+offY], [ 2+offX, 1+offY], [0+offX, 2+offY], [-2+offX, 1+offY]], colorTop  , strokeColor # top
		@drawPolygon [[ 2+offX, 1+offY], [ 2+offX, 3+offY], [0+offX, 4+offY], [ 0+offX, 2+offY]], colorRight, strokeColor # right
		@drawPolygon [[-2+offX, 1+offY], [-2+offX, 3+offY], [0+offX, 4+offY], [ 0+offX, 2+offY]], colorLeft , strokeColor # left
		
	drawPolygon: (points, color, strokeColor) ->
		cz = conf.CUBE_SIZE; ox = conf.OFFSET_X; oy = conf.OFFSET_Y;
		
		@CTX.beginPath()
		@CTX.moveTo ox + points[0][0] * cz, oy + points[0][1] * cz
		_.each points, ((point) -> @CTX.lineTo ox + point[0] * cz, oy + point[1] * cz), @
		@CTX.lineTo ox + points[0][0] * cz, oy + points[0][1] * cz
		@CTX.closePath();
		
		@CTX.strokeStyle=strokeColor
		@CTX.stroke()
		
		@CTX.fillStyle=color;
		@CTX.fill();
		
	drawCartesian: () ->
		ox = conf.OFFSET_X; oy = conf.OFFSET_Y;
		
		@CTX.beginPath()
		@CTX.moveTo 2*ox, oy
		@CTX.lineTo 0   , oy
		@CTX.moveTo ox  , 2*oy
		@CTX.lineTo ox  , 0
		@CTX.closePath();
		
		@CTX.strokeStyle="#f66"
		@CTX.stroke()
		
	drawLineX: (x, y, z) ->
		cz = conf.CUBE_SIZE; ox = conf.OFFSET_X; oy = conf.OFFSET_Y;
		offX = 2 * (x) - 2 * (z)
		offY = x - 2 * (y) + z
	
		@CTX.beginPath()
		@CTX.moveTo ox + offX*cz - cz + 8, oy + offY*cz + 1.5*cz + 4
		@CTX.lineTo ox + offX*cz + cz + 8, oy + offY*cz + 2.5*cz + 4
		@CTX.closePath();
		
		@CTX.strokeStyle="#f66"
		@CTX.stroke()
	
	drawLineY: (x, y, z) ->
		cz = conf.CUBE_SIZE; ox = conf.OFFSET_X; oy = conf.OFFSET_Y;
		offX = 2 * (x) - 2 * (z)
		offY = x - 2 * (y) + z
	
		@CTX.beginPath()
		@CTX.moveTo ox + offX*cz, oy + offY*cz + cz - 8
		@CTX.lineTo ox + offX*cz, oy + offY*cz + 3*cz - 8
		@CTX.closePath();
		
		@CTX.strokeStyle="#6f6"
		@CTX.stroke()
	
	drawLineZ: (x, y, z) ->
		cz = conf.CUBE_SIZE; ox = conf.OFFSET_X; oy = conf.OFFSET_Y;
		offX = 2 * (x) - 2 * (z)
		offY = x - 2 * (y) + z

		@CTX.beginPath()
		@CTX.moveTo ox + offX*cz + cz - 8, oy + offY*cz + 1.5*cz + 4
		@CTX.lineTo ox + offX*cz - cz - 8, oy + offY*cz + 2.5*cz + 4
		@CTX.closePath();
		
		@CTX.strokeStyle="#66f"
		@CTX.stroke()
		
	clearCanvas: -> @CTX.clearRect 0, 0, conf.CANVAS_WIDTH, conf.CANVAS_HEIGHT
