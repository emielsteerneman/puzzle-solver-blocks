# X Y Z
#
#		[0, 0, 0] at bottom right corner in the back
#		X to right
#		Y to top
#		Z to	 me
#

artist = grid = null;
b0 = b1 = b2 = b3 = b4 = b5 = b6 = null; 
tStart = tickCounter = totalPerformance = 0
blocks = [];
				
init = ->
	console.log "%cinit()", "color: #3bf"
		
	# Init canvas	
	conf.CANVAS = $("#myCanvas")
	conf.CTX = conf.CANVAS[0].getContext('2d');
	conf.CTX.canvas.height = conf.CANVAS_HEIGHT
	conf.CTX.canvas.width = conf.CANVAS_WIDTH;
	
	grid = new Grid
	artist = new Artist grid, conf.CTX
	
	conf.CANVAS.mousedown	(evt) -> mouseDown evt
	conf.CANVAS.mouseup 	(evt) -> mouseUp evt
	document.addEventListener 'keyup', (evt) -> keyUp evt
	
	#conf.CANVAS.mousemove((evt) -> mouseMove evt)
	#conf.CANVAS[0].addEventListener 'mousewheel', 	((evt) -> canvasScrolled evt; false), false
	
	b0 = new Block [{x:0, y:0, z:0}, {x:0, y:0, z:1},{x:1, y:0, z:1},{x:2, y:0, z:1},{x:2, y:0, z:2}, {x:2, y:0, z:0}], {x: 0, y: 0, z:0}
	b1 = new Block s1, {x:  0, y:0, z: -9}
	b2 = new Block s2, {x:  0, y:0, z:  0}, {r:  51, g:187, b:255}
	b3 = new Block s3, {x:  0, y:0, z:  9}, {r: 240, g:240, b:240}
	b4 = new Block s4, {x: -9, y:0, z: -9}, {r: 255, g:180, b: 90}
	b5 = new Block s5, {x: -9, y:0, z:  0}, {r: 181, g:200, b:155}
	b6 = new Block s6, {x: -9, y:0, z:  9}, {r: 151, g:120, b:255}
	
	#blocks = [b1, b2, b3, b4, b5, b6]	
	blocks = [b0]
	
	tStart = performance.now()
	tick()

tick = ->
	setTimeout(tick, 1000/conf.FPS)
	t0 = performance.now()
	
	
	grid.clearGrid()
	grid.addGridLines()
	
	###
	if(tickCounter%conf.FPS == 0)
		if tickCounter%(conf.FPS*12) < conf.FPS*4
			_.each blocks, (block) -> block.rotXcw()
		else if tickCounter%(conf.FPS*12) < conf.FPS*8
			_.each blocks, (block) -> block.rotYcw()
		else
			_.each blocks, (block) -> block.rotZcw()
	###
	
	_.each blocks, (block) -> grid.addBlock block
	
	
	## Draw 
	artist.clearCanvas()
	artist.drawGrid()
	
	## Prepare for next tick
	tickCounter++
	
	## Performance
	t1 = performance.now()
	totalPerformance += (t1 - t0)
	$("#text").text(tickCounter + " - " + ((tickCounter/(performance.now() - tStart))*1000).toFixed(1) + " fps - " + (totalPerformance/tickCounter).toFixed(2) + " ms")
	
canvasClicked = (evt) ->
	coords = getCursorPosition conf.CANVAS[0], evt
	
	_x = coords.x - conf.OFFSET_X
	_y = coords.y - conf.OFFSET_Y
	
	t1 = _x / (2 * conf.CUBE_SIZE)
	t2 = _y / conf.CUBE_SIZE
	
	x = (t1+t2)/2
	z = t2-x
	
	x = Math.floor x
	z = Math.floor z
	
	console.log "Canvas clicked:",x,",", z
	
	return
	
	val = x + z
	minmax = grid.getMinMax(); min = minmax.min; max = minmax.max; c = null; counter = 0
	
	counter = 0
	while val+3 <= max
		val += 3
		counter++
	
	while val >= min and !c?
		c = _.findWhere grid.grid[val], {x: x+counter, y: counter, z: z+counter, type: conf.TYPES.CUBE}
		
		if c?
			c.block.selected = if c.block.selected? then !c.block.selected else true
			
			#_.each c.block.structure, (cube) -> cube.selected = c.selected
			
			#artist.clearCanvas()
			#artist.drawGrid()
			break
		val -= 3
		counter--

mouseDown = (evt) ->
	conf.MOUSE_DOWN = true
	#console.log "mouseDown"
	coords = getCursorPosition conf.CANVAS[0], evt
	conf.MOUSE_DOWN_X = coords.x - conf.OFFSET_X
	conf.MOUSE_DOWN_Y = coords.y - conf.OFFSET_Y
	
mouseUp = (evt) ->
	conf.MOUSE_DOWN = false
	#console.log "mouseUp"
	coords = getCursorPosition conf.CANVAS[0], evt
	
	if coords.x - conf.OFFSET_X == conf.MOUSE_DOWN_X and coords.y - conf.OFFSET_Y == conf.MOUSE_DOWN_Y
		canvasClicked evt
		
	
	conf.MOUSE_DOWN_X = coords.x - conf.OFFSET_X
	conf.MOUSE_DOWN_Y = coords.y - conf.OFFSET_Y

mouseMove = (evt) ->
	if !conf.MOUSE_DOWN
		return
	
	console.log "mouseMove"
	coords = getCursorPosition conf.CANVAS[0], evt
	dx = -coords.x + conf.MOUSE_MOVE_X
	dy = -coords.x + conf.MOUSE_MOVE_Y
	
	console.log(dx, dy)
	
	conf.OFFSET_X += dx/10
	conf.OFFSET_Y += dy/10
	
	conf.MOUSE_MOVE_X = coords.x - conf.OFFSET_X
	conf.MOUSE_MOVE_Y = coords.y - conf.OFFSET_Y

keyUp = (evt) ->
	console.log "keyUp", evt.keyCode
	
	## Rotate
	if evt.keyCode == 103
		_.each blocks, (block) -> block.rotXcw()	if block.selected
	else if evt.keyCode == 104
		console.log "todo"
	else if evt.keyCode == 105
		_.each blocks, (block) -> block.rotXccw()	if block.selected
	
	else if evt.keyCode == 100
		_.each blocks, (block) -> block.rotYcw()	if block.selected
	else if evt.keyCode == 101
		console.log "todo"
	else if evt.keyCode == 102
		_.each blocks, (block) -> block.rotYccw()	if block.selected
	
	else if evt.keyCode == 97
		_.each blocks, (block) -> block.rotZcw()	if block.selected
	else if evt.keyCode == 98
		console.log "todo"
	else if evt.keyCode == 99
		_.each blocks, (block) -> block.rotZccw()	if block.selected
	
	## Select
	else if evt.keyCode == 49
		_.each blocks, (block) -> block.selected = false
		blocks[0].selected = true	if blocks[0]?
	else if evt.keyCode == 50
		_.each blocks, (block) -> block.selected = false
		blocks[1].selected = true	if blocks[1]?
	else if evt.keyCode == 51
		_.each blocks, (block) -> block.selected = false
		blocks[2].selected = true	if blocks[2]?
	else if evt.keyCode == 52
		_.each blocks, (block) -> block.selected = false
		blocks[3].selected = true	if blocks[3]?
	else if evt.keyCode == 53
		_.each blocks, (block) -> block.selected = false
		blocks[4].selected = true	if blocks[4]?
	else if evt.keyCode == 54
		_.each blocks, (block) -> block.selected = false
		blocks[5].selected = true	if blocks[5]?
	
	## Move
	else if evt.keyCode == 81
		_.each blocks, (block) -> block.position.x--	if block.selected
	else if evt.keyCode == 69
		_.each blocks, (block) -> block.position.x++	if block.selected
	else if evt.keyCode == 65
		_.each blocks, (block) -> block.position.y++	if block.selected
	else if evt.keyCode == 68
		_.each blocks, (block) -> block.position.y--	if block.selected
	else if evt.keyCode == 90
		_.each blocks, (block) -> block.position.z++	if block.selected
	else if evt.keyCode == 67
		_.each blocks, (block) -> block.position.z--	if block.selected
	
canvasScrolled = (evt) ->
	if evt.deltaY > 0
		conf.CUBE_SIZE += 5
	else
		conf.CUBE_SIZE -= 5
		
	artist.clearCanvas()
	artist.drawGrid()
	false
	
	
getCursorPosition = (canvas, event) ->
	rect = canvas.getBoundingClientRect();
	x = event.clientX - rect.left;
	y = event.clientY - rect.top;
	{x:x, y:y}

	
















s1 = [{x: 0, y: 0, z:0},{x: 0, y: 0, z:1},{x: 1, y: 0, z:0},{x: 1, y: 0, z:1},{x: 2, y: 0, z:0},{x: 2, y: 0, z:1},{x: 3, y: 0, z:0},{x: 3, y: 0, z:1},{x: 4, y: 0, z:0},{x: 4, y: 0, z:1},{x: 5, y: 0, z:0},{x: 5, y: 0, z:1},
{x: 0, y: 1, z:0},{x: 0, y: 1, z:1},{x: 5, y: 1, z:0},{x: 5, y: 1, z:1}]

s2 = [{x: 0, y: 0, z:0},{x: 0, y: 0, z:1},{x: 1, y: 0, z:0},{x: 1, y: 0, z:1},{x: 2, y: 0, z:0},{x: 3, y: 0, z:0},{x: 4, y: 0, z:0},{x: 4, y: 0, z:1},{x: 5, y: 0, z:0},{x: 5, y: 0, z:1},
{x: 0, y: 1, z:0},{x: 0, y: 1, z:1},{x: 2, y: 1, z:0}, {x: 3, y: 1, z:0},{x: 5, y: 1, z:0},{x: 5, y: 1, z:1}]

s3 = [{x: 0, y: 0, z:0},{x: 0, y: 0, z:1},{x: 1, y: 0, z:0},{x: 1, y: 0, z:1},{x: 2, y: 0, z:0},{x: 2, y: 0, z:1},{x: 3, y: 0, z:0},{x: 4, y: 0, z:0},{x: 5, y: 0, z:0},{x: 5, y: 0, z:1},
{x: 0, y: 1, z:0},{x: 0, y: 1, z:1},{x: 1, y: 1, z:0}, {x: 4, y: 1, z:0},{x: 5, y: 1, z:0},{x: 5, y: 1, z:1}]

s4 = [{x: 0, y: 0, z:0},{x: 0, y: 0, z:1},{x: 1, y: 0, z:0},{x: 3, y: 0, z:1},{x: 2, y: 0, z:0},{x: 4, y: 0, z:1},{x: 3, y: 0, z:0},{x: 4, y: 0, z:0},{x: 5, y: 0, z:0},{x: 5, y: 0, z:1},
{x: 0, y: 1, z:0},{x: 0, y: 1, z:1},{x: 1, y: 1, z:0}, {x: 4, y: 1, z:0},{x: 5, y: 1, z:0},{x: 5, y: 1, z:1}]

s5 = [{x: 0, y: 0, z:0},{x: 0, y: 0, z:1},{x: 1, y: 0, z:0},{x: 2, y: 0, z:0},{x: 3, y: 0, z:0},{x: 4, y: 0, z:0},{x: 5, y: 0, z:0},{x: 5, y: 0, z:1},
{x: 0, y: 1, z:0},{x: 0, y: 1, z:1},{x: 1, y: 1, z:0}, {x: 4, y: 1, z:0},{x: 5, y: 1, z:0},{x: 5, y: 1, z:1}]

s6 = [{x: 0, y: 0, z:0},{x: 0, y: 1, z:0},{x: 0, y: 0, z:1},{x: 0, y: 1, z:1},{x: 1, y: 0, z:0},{x: 1, y: 1, z:0},{x: 1, y: 0, z:1},{x: 1, y: 1, z:1},{x: 2, y: 0, z:0},{x: 2, y: 1, z:0},{x: 2, y: 0, z:1},{x: 2, y: 1, z:1},{x: 3, y: 0, z:0},{x: 3, y: 1, z:0},{x: 3, y: 0, z:1},{x: 3, y: 1, z:1},{x: 4, y: 0, z:0},{x: 4, y: 1, z:0},{x: 4, y: 0, z:1},{x: 4, y: 1, z:1},{x: 5, y: 0, z:0},{x: 5, y: 1, z:0},{x: 5, y: 0, z:1},{x: 5, y: 1, z:1}]

$(document).ready ->
	init()
	
	
	
		
		

		
		
		
		
		
		
		
		
		
