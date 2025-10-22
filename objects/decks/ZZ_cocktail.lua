SMODS.Back({
	key = "cocktail",
	config = {},
	atlas = "mp_decks",
	pos = { x = 4, y = 0 },
	mod_whitelist = {
		Multiplayer = true,
	},
	apply = function(self)
		-- we need to fucking generate the seed early this is infuriating
		local seed = G._MP_SET_SEED
		local seeded = false
		if seed then seeded = true end
		G.GAME.pseudorandom.seed = seed or generate_starting_seed()
		G.GAME.modifiers.mp_cocktail = {}
		local decks, forced = MP.get_cocktail_decks(true)
		pseudoshuffle(decks, pseudoseed("mp_cocktail"))
		local back = G.GAME.selected_back
		
		local function add_deck(num, deck)
			G.GAME.modifiers.mp_cocktail[num] = deck
			if deck == "b_checkered" then -- hardcoded because cringe
				G.E_MANAGER:add_event(Event({
					func = function()
						for k, v in pairs(G.playing_cards) do
							if v.base.suit == "Clubs" then v:change_suit("Spades") end
							if v.base.suit == "Diamonds" then v:change_suit("Hearts") end
						end
						return true
					end,
				}))
			end
		end
			
		for i = 1, #forced do
			add_deck(i, forced[i])
		end
		for i = 1 + #forced, math.min(3, #decks) do
			add_deck(i, decks[i])
		end
		local function merge(t1, t2, safe)
			local t3 = {}
			for k, v in pairs(t1) do
				if type(v) == "table" then
					t3[k] = merge(v, {})
				else
					t3[k] = v
				end
			end
			for k, v in pairs(t2) do
				local existing = t3[k]

				if type(existing) == "number" and type(v) == "number" then
					t3[k] = existing + v
				elseif type(existing) == "table" and type(v) == "table" then
					t3[k] = merge(existing, v, true) -- risky but it works...
				else
					if type(v) == "table" then
						t3[k] = merge(v, {})
					else
						local index = safe and #t3 + 1 or k
						t3[index] = v
					end
				end
			end
			return t3
		end
		for i = 1, #G.GAME.modifiers.mp_cocktail do
			back.effect.config = merge(back.effect.config, G.P_CENTERS[G.GAME.modifiers.mp_cocktail[i]].config)
			if back.effect.config.voucher then
				back.effect.config.vouchers = back.effect.config.vouchers or {}
				back.effect.config.vouchers[#back.effect.config.vouchers + 1] = back.effect.config.voucher
				back.effect.config.voucher = nil
			end
			local obj = G.P_CENTERS[G.GAME.modifiers.mp_cocktail[i]]
			if obj.apply and type(obj.apply) == "function" then obj:apply(back) end
		end
		if MP.LOBBY.code and MP.LOBBY.config.ruleset == "ruleset_mp_smallworld" then
			MP.apply_fake_back_vouchers(back)
		end
		back.effect.mp_cocktailed = true
		if MP.cocktail_check_edited() then
			G.GAME.seeded = true
		end
	end,
	calculate = function(self, back, context)
		for i = 1, 3 do
			back:change_to(G.P_CENTERS[G.GAME.modifiers.mp_cocktail[i]])
			local ret1, ret2 = back:trigger_effect(context)
			back:change_to(G.P_CENTERS["b_mp_cocktail"])
			if ret1 or ret2 then return ret1, ret2 end
		end
	end,
	mp_credits = { art = { "aura!", "shai1n" }, code = { "Toneblock" } },
})

function MP.get_cocktail_decks(cull)
	local ret = {}
	local forced = {}
	for k, v in pairs(G.P_CENTERS) do
		if v.set == "Back" and k ~= "b_challenge" and k ~= "b_mp_cocktail" then
			if not (v.mod and not G.P_CENTERS["b_mp_cocktail"].mod_whitelist[v.mod.id]) then ret[#ret + 1] = k end
		end
	end
	table.sort(ret, function (a, b) return G.P_CENTERS[a].order < G.P_CENTERS[b].order end)
	if cull then
		local _ret = {}
		for i, v in ipairs(ret) do
			if MP.cocktail_cfg_readpos(i, true) == "1" then
				_ret[#_ret+1] = ret[i]
			elseif MP.cocktail_cfg_readpos(i, true) == "2" then
				forced[#forced+1] = ret[i]
			end
		end
		ret = _ret
	end
	return ret, forced
end

local change_to_ref = Back.change_to
function Back:change_to(new_back)
	if self.effect.mp_cocktailed then
		local t = copy_table(self.effect.config)
		local ret = change_to_ref(self, new_back)
		self.effect.config = copy_table(t)
		self.effect.mp_cocktailed = true
		return ret
	end
	return change_to_ref(self, new_back)
end

local click_ref = Card.click
function Card:click() -- i'd rather deal with the cardarea but this is fine i suppose
	click_ref(self)
	if G.STAGE == G.STAGES.MAIN_MENU then
		if G.GAME.viewed_back and G.GAME.viewed_back.effect and G.GAME.viewed_back.effect.center.key == 'b_mp_cocktail' then
			-- boilerplate robbed from cryptid's decaying corpse
			if G.cocktail_select then
				for i = 1, #G.cocktail_select do
					G.cocktail_select[i]:remove()
					G.cocktail_select[i] = nil
				end
			end
			G.cocktail_select = {}
			for i = 1, 2 do
				G.cocktail_select[i] = CardArea(
					G.ROOM.T.x + 0.2 * G.ROOM.T.w / 1.5,
					G.ROOM.T.h,
					5.3 * G.CARD_W,
					1.03 * G.CARD_H,
					{ card_limit = 5, type = "title", highlight_limit = 999, collection = true }
				)
			end
			local decks = MP.get_cocktail_decks()
			local cfg = SMODS.Mods["Multiplayer"].config
			for i, v in ipairs(decks) do
				local row = math.floor( ( ( ( i - 1 ) / #decks ) * 2 ) + 1 )
				G.GAME.viewed_back = G.P_CENTERS[v]
				local card = Card(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, G.CARD_W, G.CARD_H, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base, {playing_card = i, viewed_back = true})
				G.cocktail_select[row]:emplace(card)
				card.sprite_facing = 'back'
				card.facing = 'back'
				card.mp_cocktail_select = v
				local num = MP.cocktail_cfg_readpos(i)
				card.highlighted = tonumber(num) >= 1 and true or false
				card.mp_cocktail_forced = num == "2" and true or false
			end
			G.GAME.viewed_back = G.P_CENTERS["b_mp_cocktail"]
			deck_tables = {}
			for i = 1, #G.cocktail_select do
				deck_tables[i] = {
					n = G.UIT.R,
					config = { align = "cm", padding = 0, no_fill = true },
					nodes = {
						{ n = G.UIT.O, config = { object = G.cocktail_select[i] } },
					},
				}
			end
			local t = create_UIBox_generic_options({
				back_func = "setup_run",
				snap_back = true,
				contents = {
					{
						n = G.UIT.R,
						config = { align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
						nodes = deck_tables,
					},
					{n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("k_cocktail_select"), scale = 0.48, colour = G.C.WHITE}},
					}},
					{n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("k_cocktail_shiftclick"), scale = 0.32, colour = G.C.WHITE}},
					}},
					{n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("k_cocktail_rightclick"), scale = 0.32, colour = G.C.WHITE}},
					}},
				},
			})
			G.FUNCS.overlay_menu({
				definition = t,
			})
		end
	end
end

local draw_ref = Card.draw
function Card:draw(layer)
	draw_ref(self, layer)
	if G.STAGE == G.STAGES.MAIN_MENU then
		if not self.children.view_deck then 
			self.children.view_deck = UIBox{
				definition = 
					{n=G.UIT.ROOT, config = {align = 'cm', padding = 0.1, r =0.1, colour = G.C.CLEAR}, nodes={
						{n=G.UIT.R, config={align = "cm", padding = 0.05, r =0.1, colour = adjust_alpha(G.C.BLACK, 0.5),func = 'set_button_pip', focus_args = {button = 'triggerright', orientation = 'bm', scale = 0.6}, button = 'deck_info'}, nodes={
							{n=G.UIT.R, config={align = "cm", maxw = 2}, nodes={
								{n=G.UIT.T, config={text = localize('k_edit'), scale = 0.48, colour = G.C.WHITE, shadow = true}}
							}},
							{n=G.UIT.R, config={align = "cm", maxw = 2}, nodes={
								{n=G.UIT.T, config={text = localize('k_deck'), scale = 0.38, colour = G.C.WHITE, shadow = true}}
							}},
						}},
					}},
					config = { align = 'cm', offset = {x=0,y=0}, major = self, parent = self}
				}
				self.children.view_deck.states.collide.can = false
		end
		local bool = self.states.hover.is and G.GAME.viewed_back and G.GAME.viewed_back.effect and G.GAME.viewed_back.effect.center.key == 'b_mp_cocktail'
		self.children.view_deck.states.visible = bool
	end
end

SMODS.DrawStep({
	key = "mp_cocktail_forced",
	order = 5,
	func = function(self)
		if self.mp_cocktail_forced then
			self.children.back:draw_shader("foil", nil, self.ARGS.send_to_shader)
		end
	end,
	conditions = { vortex = false, facing = "back" },
})

local hover_ref = Card.hover
function Card:hover()
	hover_ref(self)
	if self.mp_cocktail_select then
		self.ability_UIBox_table = self:generate_UIBox_ability_table()
		self.config.h_popup = G.UIDEF.card_h_popup(self)
		self.config.h_popup_config = self:align_h_popup()
		Node.hover(self)
	end
end

local generate_card_ui_ref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
	if card and card.mp_cocktail_select then
		_c = G.P_CENTERS[card.mp_cocktail_select]
		local ret = generate_card_ui_ref(_c, full_UI_table, specific_vars, "Back", badges, hide_desc, main_start, main_end, card)
		if not _c.generate_ui or type(_c.generate_ui) ~= 'function' then
			-- i literally can't get the vars from anywhere else so we're thunk coding
			
			local name_to_check =  G.P_CENTERS[card.mp_cocktail_select].name
			
			if name_to_check == 'Blue Deck' then specific_vars = {_c.config.hands}
			elseif name_to_check == 'Red Deck' then specific_vars = {_c.config.discards}
			elseif name_to_check == 'Yellow Deck' then specific_vars = {_c.config.dollars}
			elseif name_to_check == 'Green Deck' then specific_vars = {_c.config.extra_hand_bonus, _c.config.extra_discard_bonus}
			elseif name_to_check == 'Black Deck' then specific_vars = {_c.config.joker_slot, -_c.config.hands}
			elseif name_to_check == 'Magic Deck' then specific_vars = {localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'}, localize{type = 'name_text', key = 'c_fool', set = 'Tarot'}}
			elseif name_to_check == 'Nebula Deck' then specific_vars = {localize{type = 'name_text', key = 'v_telescope', set = 'Voucher'}, -1}
			elseif name_to_check == 'Zodiac Deck' then specific_vars = {localize{type = 'name_text', key = 'v_tarot_merchant', set = 'Voucher'}, 
          		                  localize{type = 'name_text', key = 'v_planet_merchant', set = 'Voucher'},
          		                  localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}}
			elseif name_to_check == 'Painted Deck' then specific_vars = {_c.config.hand_size, _c.config.joker_slot}
			elseif name_to_check == 'Anaglyph Deck' then specific_vars = {localize{type = 'name_text', key = 'tag_double', set = 'Tag'}}
			elseif name_to_check == 'Plasma Deck' then specific_vars = {_c.config.ante_scaling}
			end
			
			localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = ret.main, vars = specific_vars}
		end
		return ret
	end
	return generate_card_ui_ref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
end

local can_highlight_ref = CardArea.can_highlight
function CardArea:can_highlight(card)
	if card.mp_cocktail_select then return true end
	return can_highlight_ref(self, card)
end

local highlight_ref = Card.highlight
function Card:highlight(is_highlighted)
	if self.mp_cocktail_select then
		local shift = G.CONTROLLER.held_keys["lshift"] or G.CONTROLLER.held_keys["rshift"]
		if shift and self.mp_cocktail_forced then
			is_highlighted = false
			self.mp_cocktail_forced = false
		elseif self.mp_cocktail_forced then
			is_highlighted = true
			self.mp_cocktail_forced = false
		elseif shift then
			is_highlighted = true
			if MP.cocktail_get_forced_num() < 3 then
				self.mp_cocktail_forced = true
				play_sound('foil1', 1.5, 0.3)
			else
				play_sound("timpani", 0.9, 0.7)
				play_sound("timpani", 1.2, 0.7)
			end
		end
		MP.cocktail_cfg_edit(self.mp_cocktail_forced and 2 or is_highlighted, self.mp_cocktail_select)
	end
	return highlight_ref(self, is_highlighted)
end

local r_cursor_press_ref = Controller.queue_R_cursor_press
function Controller:queue_R_cursor_press(x, y)
	local ret = r_cursor_press_ref(self, x, y)
	if G.cocktail_select then
		local highlight = true
		for i = 1, #G.cocktail_select do
			for j = 1, #G.cocktail_select[i].cards do
				if G.cocktail_select[i].cards[j].highlighted then
					highlight = false
					break
				end
			end
			if not highlight then break end
		end
		for i = 1, #G.cocktail_select do
			for j = 1, #G.cocktail_select[i].cards do
				G.cocktail_select[i].cards[j].highlighted = highlight
				G.cocktail_select[i].cards[j].mp_cocktail_forced = false
			end
		end
		if highlight then
			play_sound('cardSlide1')
		else
			play_sound('cardSlide2', nil, 0.3)
		end
		MP.cocktail_cfg_edit(highlight)
	end
	return ret
end

function MP.cocktail_cfg_edit(bool, deck) -- strings are easier to send, and it's just ones and zeroes
	local decks = MP.get_cocktail_decks()
	local cfg = SMODS.Mods["Multiplayer"].config
	local num = (bool == 2) and "2" or (bool and "1" or "0")
	if (not cfg.cocktail) or #decks ~= #cfg.cocktail then
		local string = ""
		for i = 1, #decks do
			string = string.."1"
		end
		cfg.cocktail = string
	end
	if not deck then
		local string = ""
		for i = 1, #decks do
			string = string..num
		end
		cfg.cocktail = string
	else
		for i, v in ipairs(decks) do
			if v == deck then
				local function replace(str, pos, d)
					return str:sub(1, pos-1)..d..str:sub(pos+1)
				end
				cfg.cocktail = replace(cfg.cocktail, i, num)
				break
			end
		end
	end
	MP.LOBBY.config.cocktail = cfg.cocktail
	SMODS.save_mod_config(SMODS.Mods["Multiplayer"])
end

function MP.cocktail_cfg_readpos(pos, construct)
	local decks = MP.get_cocktail_decks() -- copypasted code. unsure how to make this less messy without making it more messy
	local cfg = SMODS.Mods["Multiplayer"].config
	if (not cfg.cocktail) or #decks ~= #cfg.cocktail then
		local string = ""
		for i = 1, #decks do
			string = string.."1"
		end
		cfg.cocktail = string
	end
	if construct then
		return MP.cocktail_cfg_get():sub(pos, pos)
	end
	return cfg.cocktail:sub(pos, pos)
end

function MP.cocktail_cfg_get()
	if MP.LOBBY.code and MP.LOBBY.deck and MP.LOBBY.deck.cocktail then
		return MP.LOBBY.deck.cocktail
	else
		return SMODS.Mods["Multiplayer"].config.cocktail
	end
end

function MP.cocktail_check_edited()
	local str = MP.cocktail_cfg_get()
	for i = 1, #str do
		if string.sub(str, i, i) ~= "1" then
			return true
		end
	end
	return false
end

function MP.cocktail_get_forced_num()
	local str = SMODS.Mods["Multiplayer"].config.cocktail
	local c = 0
	for i = 1, #str do
		if string.sub(str, i, i) == "2" then
			c = c + 1
		end
	end
	return c
end


local localize_ref = localize
function localize(args, misc_cat)
	local ret = localize_ref(args, misc_cat)
	local key = args.key or args.node and args.node.config.center.key or "NULL"
	if args.type == "name_text" and key == "b_mp_cocktail" then
		if MP.cocktail_check_edited() then
			return ret.."*"
		end
	end
	return ret
end