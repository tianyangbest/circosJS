# A layout instance
circosJS.Layout = (conf, data) ->
    unless data?
        circosJS.log 2, 'no layout data', ''

    # deep copy of default conf
    this._conf = JSON.parse JSON.stringify this._defaultConf

    # this refers the layout instance
    this._data = data
    this._blocks = {} #data dictonary key=blockId
    this._size = 0

    # compute block offset
    offset = 0
    for k,v of this._data
        this._blocks[v.id] =
            label: v.label
            len: v.len
            color: v.color
            offset: offset
        v.offset = offset
        offset += v.len
    this._size = offset

    # conf override the default configuration. Conf not in default conf
    # object are removed
    for k,v of this._conf
        this._conf[k] = if conf[k]? then conf[k] else v

    # thanks to sum of blocks' length, compute start and end angles in radian
    gap = this._conf.gap
    size = this._size
    block_nb = this._data.length
    for k,v of this._data
        this._blocks[v.id].start = v.offset/size *(2*Math.PI-block_nb*gap)  + k*gap
        this._blocks[v.id].end = (v.offset + v.len)/size *(2*Math.PI-block_nb*gap)  + k*gap
        v.start = v.offset/size *(2*Math.PI-block_nb*gap)  + k*gap
        v.end = (v.offset + v.len)/size *(2*Math.PI-block_nb*gap)  + k*gap

    # getters/setters
    this.getData = ->
        this._data
    this.getGap = (unit) ->
        if unit == 'rad'
            this._conf.gap
        else
            null #todo
    this.getBlock = (blockId) ->
        this._blocks[blockId]
    this.getAngle = (blockId, unit) ->
        block = this.getBlock(blockId).start/this._size
        if unit == 'deg' then block*360
        else if unit == 'rad' then block*2*Math.PI
        else null
    this.getSize = ->
        this._size
    this.getConf = ->
        this._conf

    return this
