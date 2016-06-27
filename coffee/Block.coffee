class window.Block
	constructor: (@structure, @position = {x: 0, y:0, z:0}, @color = {r: 128, g:128, b:128}) ->
		pos = @position
		console.log "new Block()"
		
		_.each @structure, (cube) ->
			cube.type = conf.TYPES.CUBE 					if !cube.type?
			cube.id   = Math.floor(Math.random() * 10000) 	if !cube.id?
			cube.color= @color								if !cube.color
			cube.block= @
		, @
			
	print: -> console.log "Block:", (_.map @structure, (c) -> c.x + "," + c.y + "," + c.z).join(" ; ")
	
	rotXcw : -> _.each @structure, ((c) -> [c.y, c.z] = [c.z , -c.y]), @
	rotXccw: -> _.each @structure, ((c) -> [c.y, c.z] = [-c.z,  c.y]), @
	
	rotYcw : -> _.each @structure, ((c) -> [c.x, c.z] = [-c.z,  c.x]), @
	rotYccw: -> _.each @structure, ((c) -> [c.x, c.z] = [c.z , -c.x]), @
	
	rotZcw : -> _.each @structure, ((c) -> [c.x, c.y] = [c.y , -c.x]), @
	rotZccw: -> _.each @structure, ((c) -> [c.x, c.y] = [-c.y,  c.x]), @

	
	#rotXcw : -> _.each @structure, ((c) -> [c.y, c.z] = [c.z  - @position.z + @position.y, -c.y + @position.y + @position.z]), @
	#rotXccw: -> _.each @structure, ((c) -> [c.y, c.z] = [-c.z + @position.z - @position.y,  c.y + @position.y + @position.z]), @
	
	#rotYcw : -> _.each @structure, ((c) -> [c.x, c.z] = [-c.z + @position.z + @position.x,  c.x - @position.x + @position.z]), @
	#rotYccw: -> _.each @structure, ((c) -> [c.x, c.z] = [c.z  - @position.z + @position.x, -c.x + @position.x + @position.z]), @
	
	#rotZcw : -> _.each @structure, ((c) -> [c.x, c.y] = [c.y  - @position.y + @position.x, -c.x + @position.x + @position.y]), @
	#rotZccw: -> _.each @structure, ((c) -> [c.x, c.y] = [-c.y - @position.y + @position.x,  c.x - @position.x - @position.y]), @
