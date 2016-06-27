class window.Grid
	
	constructor: (@dimension = {w: 10, h:10, d:10}) ->
		@grid = {}
		@test = []
	
	getMinMax: () ->
		min = Infinity; max = -Infinity
		for k in Object.keys(@grid)
			k = parseInt k
			min = if k < min then k else min
			max = if k > max then k else max
		{min: min, max : max}
	
	addBlock: (block) ->
		_.each block.structure, ((cube) -> 
			
			x = cube.x + block.position.x; y = cube.y + block.position.y; z=cube.z + block.position.z;
			
			offX = 2 * (x) - 2 * (z)
			offY = x - 2 * (y) + z
			
			console.log "x", offX, "y", offY
			
			val = block.position.x + block.position.y + block.position.z + cube.x + cube.y + cube.z
				
			if(!@grid[val]?) 
				@grid[val] = []


				###else
				collision = _.where @grid[val], {x: cube.x, y: cube.y, z: cube.z, type: cube.type}
				console.log "x", collision if collision.length > 0?
				if collision.length
					_.each collision, (col) ->
						
					console.log collision.length + " Collision!", collision[0].x, collision[0].y, collision[0].z, collision[0].type
			###

			
			@grid[val].push cube
			)
		,@
	
	addGridLines: (size = 30) ->
		to = if @maximum > 0 then @maximum else 10
	
		for i in [-size/2..size/2]
			if(!@grid[i]?) 
					@grid[i] = []
				
			@grid[i].push {x: i, y: 0, z: 0, type: conf.TYPES.LINEX}
			@grid[i].push {x: 0, y: i, z: 0, type: conf.TYPES.LINEY}
			@grid[i].push {x: 0, y: 0, z: i, type: conf.TYPES.LINEZ}
	
	addCube: (cube) ->
		i = cube.x + cube.y + cube.z
		@grid[i] = [] if !@grid[i]?
		@grid[i].push cube
		console.log "cube added"
	
	clearGrid: ->
		@grid = {}
		@minimum = Infinity
		@maximum = -Infinity
