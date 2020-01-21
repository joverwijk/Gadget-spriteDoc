local p = {}
function p.base( f )
	local args = f
	if f == mw.getCurrentFrame() then 
		args = require( 'Module:ProcessArgs' ).merge( true )
	else
		f = mw.getCurrentFrame()
	end
	
	local data = args.data and mw.loadData( 'Module:' .. args.data ) or {}
	local settings = data.settings
	
	-- Default settings
	local default = {
		scale = 1,
		sheetsize = 256,
		size = 16,
		pos = 1,
		align = 'text-top'
	}
	
	local defaultStyle = default
	if settings then
		if not settings.stylesheet then
			-- Make a separate clone of the current default settings
			defaultStyle = mw.clone( default )
		end
		for k, v in pairs( settings ) do
			default[k] = v
		end
	end
	
	local setting = function( arg )
		return args[arg] or default[arg]
	end
	
	local sprite = mw.html.create( 'span' ):addClass( 'sprite' )
	sprite:tag( 'br' )
	
	-- mw.html's css method performs very slow escaping, which doubles the time it takes
	-- to run, so we'll construct the styles manually, and put them in the cssText
	-- method, which only does html escaping (which isn't slow)
	local styles = {}
	
	if setting( 'url' ) then
		styles[#styles + 1] = 'background-image:' .. setting( 'url' )
	end
	if setting( 'stylesheet' ) then
		sprite:addClass(
			setting( 'classname' ) or
			mw.ustring.lower( setting( 'name' ):gsub( ' ', '-' ) ) .. '-sprite'
		)
	elseif not setting( 'url' ) then
		styles[#styles + 1] = 'background-image:' .. p.getUrl(
			setting( 'image' ) or setting( 'name' ) .. 'Sprite.png'
		)
	end
	local class = setting( 'class' )
	if class then
		sprite:addClass( class )
	end
	
	local size = setting( 'size' )
	local sheetWidth = setting( 'sheetsize' )
	local tiles = sheetWidth / size
	local pos = setting( 'pos' ) - 1
	local scale = setting( 'scale' )
	local autoScale = setting( 'autoscale' )
	
	if pos then
		local left = pos % tiles * size * scale
		local top = math.floor( pos / tiles ) * size * scale
		styles[#styles + 1] = 'background-position:-' .. left .. 'px -' .. top .. 'px'
	end
	
	if not autoScale and scale ~= defaultStyle.scale then
		styles[#styles + 1] = 'background-size:' .. sheetWidth * scale .. 'px auto'
	end
	if size ~= defaultStyle.size or ( not autoScale and scale ~= defaultStyle.scale ) then
		styles[#styles + 1] = 'height:' .. size * scale .. 'px'
		styles[#styles + 1] = 'width:' .. size * scale .. 'px'
	end
	
	local align = setting( 'align' )
	if align ~= defaultStyle.align then
		styles[#styles + 1] = 'vertical-align:' .. align
	end
	styles[#styles + 1] = setting( 'css' )
	
	sprite:cssText( table.concat( styles, ';' ) )
	
	local text = setting( 'text' )
	local root
	local spriteText
	if text then
		root = mw.html.create( 'span' ):addClass( 'nowrap' )
		spriteText = mw.html.create( 'span' ):addClass( 'sprite-text' ):wikitext( text )
	end
	
	local title = setting( 'title' )
	if title then
		( root or sprite ):attr( 'title', title )
	end
	
	if not root then
		root = mw.html.create( '' )
	end
	root:node( sprite )
	if spriteText then
		root:node( spriteText )
	end
	
	local link = setting( 'link' ) or ''
	if link ~= '' and mw.ustring.lower( link ) ~= 'none' then
		-- External link
		if link:find( '//' ) then
			return '[' .. link .. ' ' .. tostring( root ) .. ']'
		end
		
		-- Internal link
		local linkPrefix = setting( 'linkprefix' ) or ''
		return '[[' .. linkPrefix .. link .. '|' .. tostring( root ) .. ']]'
	end
	
	return tostring( root )
end

function p.sprite( f )
	local args = f
	if f == mw.getCurrentFrame() then
		args = require( 'Module:ProcessArgs' ).merge( true )
	else
		f = mw.getCurrentFrame()
	end
	
	local data = args.data and mw.loadData( 'Module:' .. args.data ) or {}
	local categories = {}
	local idData = args.iddata
	if not idData then
		local name = args.name or data.settings.name
		local id = mw.text.trim( tostring( args[1] or '' ) )
		idData = data.ids[id] or data.ids[mw.ustring.lower( id ):gsub( '[%s%+]', '-' )]
	end
	
	local title = mw.title.getCurrentTitle()
	-- Remove categories on language pages, talk pages, and in User/UserWiki/UserProfile namespaces
	local disallowCats = args.nocat or title.isTalkPage or title.nsText:find( '^User' )
	if idData then
		if idData.deprecated and not disallowCats then
			categories[#categories + 1] = f:expandTemplate{ title = 'Translation category', args = { 'Pages using deprecated sprite names', project = 0 } }
		end
		
		args.pos = idData.pos
	elseif not disallowCats then
		categories[#categories + 1] = f:expandTemplate{ title = 'Translation category', args = { 'Pages with missing sprites', project = 0 } }
	end
	
	return p.base( args ), table.concat( categories )
end

function p.link( f )
	local args = f
	if f == mw.getCurrentFrame() then
		args = require( 'Module:ProcessArgs' ).merge( true )
	end
	
	local link = args[1]
	if args[1] and not args.id then
		link = args[1]:match( '^(.-)%+' ) or args[1]
	end
	local text
	if not args.notext then
		text = args.text or args[2] or link
	end
	
	args[1] = args.id or args[1]
	args.link = args.link or link
	args.text = text
	
	return p.sprite( args )
end

function p.getUrl( image, query, classname )
	local f = mw.getCurrentFrame()
	local t = {
		url = f:expandTemplate{
			title = 'FileUrl',
			args = { image, query = query }
		},
	}
	if classname and classname ~= '' then
		t.style = f:expandTemplate{
			title = 'FileUrlStyle',
			args = { classname, image, query = query }
		}
	end
	return t
end

function p.doc( f )
	local args = f
	if f == mw.getCurrentFrame() then
		args = f.args
	else
		f = mw.getCurrentFrame()
	end
	local dataPage = mw.text.trim( args[1] )
	local data = mw.loadData( 'Module:' .. dataPage )
	
	local getProtection = function( title, action, extra )
		local protections = { 'edit' }
		if extra then
			protections[#protections + 1] = extra
		end
		
		local addProtection = function( protection )
			if protection == 'autoconfirmed' then
				protection = 'editsemiprotected'
			elseif protection == 'sysop' then
				protection = 'editprotected'
			end
			
			protections[#protections + 1] = protection
		end
		
		local direct = title.protectionLevels[action] or {}
		for _, protection in ipairs( direct ) do
			addProtection( protection )
		end
		local cascading = title.cascadingProtection.restrictions[action] or {}
		if #cascading > 0 then
			protections[#protections + 1] = 'protect'
		end
		for _, protection in ipairs( cascading ) do
			addProtection( protection )
		end
		
		return table.concat( protections, ',' )
	end
	
	local dataTitle = mw.title.new( 'Module:' .. dataPage )
	local spritesheet = data.settings.image or data.settings.name .. 'Sprite.png'
	local spriteTitle = mw.title.new( 'File:' .. spritesheet )
	local dataProtection = getProtection( dataTitle, 'edit' )
	local spriteProtection = getProtection( spriteTitle, 'upload', 'upload,reupload' )
	local body = mw.html.create( 'div' ):attr( {
		id = 'spritedoc',
		['data-dataprotection'] = dataProtection,
		['data-datatimestamp'] = f:callParserFunction( 'REVISIONTIMESTAMP', 'Module:' .. dataPage ),
		['data-datapage'] = 'Module:' .. dataPage,
		['data-spritesheet'] = spritesheet,
		['data-spriteprotection'] = spriteProtection,
		['data-urlfunc'] = "require( [[Module:Sprite]] ).getUrl( '" .. spritesheet .. "', '$1' )",
		['data-refreshtext'] = mw.text.nowiki( '{{#invoke:sprite|doc|' .. dataPage .. '|refresh=1}}' ),
		['data-settings'] = mw.text.jsonEncode( data.settings ),
	} ):wikitext( f:callParserFunction{ name = '#widget:LoadSprite', args = { sprite = dataPage } } )
	
	if args.refresh then
		return '', tostring( body )
	end
	return tostring( body )
end

--[[
	Code by AttemptToCallNil.
	This functions encodes all sprite data to JSON.
	@args 1 - The module to get raw sprite data from.
]]--
function p.getRawSpriteData(f)
    local args = f.args or f
    local data = mw.loadData('Module:' .. mw.text.trim(args[1]))
    return mw.text.jsonEncode(data):gsub('<', '\\u003c')
end

return p