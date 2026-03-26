-- This needs to have a parameter because its a callback for inputs
local function send_lobby_options(value)
	MP.ACTIONS.lobby_options()
end

G.HUD_connection_status = nil

function G.UIDEF.get_connection_status_ui()
	return UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = {
				align = "cm",
				colour = G.C.UI.TRANSPARENT_DARK,
			},
			nodes = {
				MP.UI.UTILS.create_text_node(
					(MP.LOBBY.code and localize("k_in_lobby"))
						or (MP.LOBBY.connected and localize("k_connected"))
						or localize("k_warn_service"),
					{
						scale = 0.3,
						colour = G.C.UI.TEXT_LIGHT,
					}
				),
			},
		},
		config = {
			align = "tri",
			bond = "Weak",
			offset = {
				x = 0,
				y = 0.9,
			},
			major = G.ROOM_ATTACH,
		},
	})
end

function G.UIDEF.create_UIBox_lobby_menu()
	local text_scale = 0.45
	local back = MP.LOBBY.config.different_decks and MP.LOBBY.deck.back or MP.LOBBY.config.back
	local stake = MP.LOBBY.config.different_decks and MP.LOBBY.deck.stake or MP.LOBBY.config.stake

	local t = {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					align = "bm",
				},
				nodes = {
					MP.UI.lobby_status_display(),
					{
						n = G.UIT.R,
						config = {
							align = "cm",
							padding = 0.2,
							r = 0.1,
							emboss = 0.1,
							colour = G.C.L_BLACK,
							mid = true,
						},
						nodes = {
							MP.UI.create_lobby_main_button(text_scale),
							{
								n = G.UIT.C,
								config = {
									align = "cm",
								},
								nodes = {
									not MP.LOBBY.config.forced_config and UIBox_button({
										button = "lobby_options",
										colour = G.C.ORANGE,
										minw = 3.15,
										minh = 1.35,
										label = {
											localize("b_lobby_options"),
										},
										scale = text_scale * 1.2,
										col = true,
									}) or nil,
									MP.UI.create_spacer(),
									MP.UI.create_lobby_deck_button(text_scale, back, stake),
									MP.UI.create_spacer(),
									MP.UI.create_players_section(text_scale),
									MP.UI.create_spacer(),
									MP.UI.create_lobby_code_buttons(text_scale),
								},
							},
							MP.UI.create_lobby_leave_button(text_scale),
						},
					},
				},
			},
		},
	}
	return t
end

function G.UIDEF.create_UIBox_lobby_options()
	return create_UIBox_generic_options({
		contents = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
				},
				nodes = {
					not MP.LOBBY.is_host and MP.UI.UTILS.create_row({ align = "cm", padding = 0.3 }, {
						MP.UI.UTILS.create_text_node(localize("k_opts_only_host"), {
							scale = 0.6,
							colour = G.C.UI.TEXT_LIGHT,
						}),
					}) or nil,
					create_tabs({
						snap_to_nav = true,
						colour = G.C.BOOSTER,
						tabs = {
							{
								label = localize("k_lobby_general"),
								chosen = true,
								tab_definition_function = function()
									return MP.UI.create_lobby_options_tab()
								end,
							},
							{
								label = localize("k_lobby_gameplay"),
								tab_definition_function = function()
									return MP.UI.create_gameplay_options_tab()
								end,
							},
							{
								label = localize("k_lobby_modifiers"),
								tab_definition_function = function()
									return MP.UI.create_gamemode_modifiers_tab()
								end,
							},
							{
								label = localize("k_lobby_advanced"),
								tab_definition_function = function()
									return MP.UI.create_advanced_options_tab()
								end,
							},
						},
					}),
				},
			},
		},
	})
end

function G.UIDEF.create_UIBox_custom_seed_overlay()
	return create_UIBox_generic_options({
		back_func = "lobby_options",
		contents = {
			MP.UI.UTILS.create_row({ align = "cm", colour = G.C.CLEAR }, {
				MP.UI.UTILS.create_column({ align = "cm", minw = 0.1 }, {
					create_text_input({
						max_length = 8,
						all_caps = true,
						ref_table = MP.LOBBY,
						ref_value = "temp_seed",
						prompt_text = localize("k_enter_seed"),
						keyboard_offset = 4,
						callback = function(val)
							MP.LOBBY.config.custom_seed = MP.LOBBY.temp_seed
							send_lobby_options()
						end,
					}),
					MP.UI.UTILS.create_blank(0.1, 0.1),
					MP.UI.UTILS.create_text_node(localize("k_enter_to_save"), {
						scale = 0.3,
						colour = G.C.UI.TEXT_LIGHT,
					}),
				}),
			}),
		},
	})
end

function G.UIDEF.create_UIBox_view_hash(type)
	return (
		create_UIBox_generic_options({
			contents = {
				MP.UI.UTILS.create_column(
					{ padding = 0.07, align = "cm" },
					MP.UI.modlist_to_view(
						type == "host" and MP.LOBBY.host.config.Mods or MP.LOBBY.guest.config.Mods,
						G.C.UI.TEXT_LIGHT
					)
				),
			},
		})
	)
end

function MP.UI.modlist_to_view(mods, text_colour)
	local t = {}

	if not mods then return t end

	for mod_name, mod_version in pairs(mods) do
		local display_text = mod_version and (mod_name .. "-" .. mod_version) or mod_name
		local color = MP.BANNED_MODS[mod_name] and G.C.RED or text_colour
		table.insert(t, {
			n = G.UIT.R,
			config = {
				padding = 0.02,
				align = "cm",
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = display_text,
						shadow = true,
						scale = 0.4,
						colour = color,
					},
				},
			},
		})
	end
	return t
end

G.FUNCS.view_host_hash = function(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_view_hash("host"),
	})
end

G.FUNCS.view_guest_hash = function(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_view_hash("guest"),
	})
end

function G.FUNCS.get_lobby_main_menu_UI(e)
	return UIBox({
		definition = G.UIDEF.create_UIBox_lobby_menu(),
		config = {
			align = "bmi",
			offset = {
				x = 0,
				y = 10,
			},
			major = G.ROOM_ATTACH,
			bond = "Weak",
		},
	})
end

---@type fun(e: table | nil, args: { deck: string, stake: number | nil, seed: string | nil })
function G.FUNCS.lobby_start_run(e, args)
	if MP.LOBBY.config.different_decks == false then G.FUNCS.copy_host_deck() end

	local challenge = nil
	if MP.LOBBY.deck.back == "Challenge Deck" then
		challenge = G.CHALLENGES[get_challenge_int_from_id(MP.LOBBY.deck.challenge)]
	else
		G.GAME.viewed_back = G.P_CENTERS[MP.UTILS.get_deck_key_from_name(MP.LOBBY.deck.back)]
	end

	G.FUNCS.start_run(e, {
		mp_start = true,
		challenge = challenge,
		stake = tonumber(MP.LOBBY.deck.stake),
		seed = args.seed,
	})
end

local back_generate_ui_ref = Back.generate_UI
function Back:generate_UI(other, ui_scale, min_dims, challenge)
	local name = other and other.name or self.name
	if not challenge and name == "Challenge Deck" and MP.LOBBY.code then
		challenge = MP.LOBBY.deck.challenge -- very generous assumption
		local ret = back_generate_ui_ref(self, other, ui_scale, min_dims, challenge)

		-- essentially the button opens the correct challenge menu
		-- exiting this challenge menu results in a crash that's difficult to figure out
		-- (some sort of jank when removing the ui elements)
		-- hacky fallback to ensure that doesn't happen, but ideally one day this gets fixed

		ret.nodes[1].nodes[1].config.button = "exit_overlay_menu"

		return ret
	end
	return back_generate_ui_ref(self, other, ui_scale, min_dims, challenge)
end

function G.FUNCS.copy_host_deck()
	MP.LOBBY.deck.back = MP.LOBBY.config.back
	MP.LOBBY.deck.cocktail = MP.LOBBY.config.cocktail
	MP.LOBBY.deck.sleeve = MP.LOBBY.config.sleeve
	MP.LOBBY.deck.stake = MP.LOBBY.config.stake
	MP.LOBBY.deck.challenge = MP.LOBBY.config.challenge
end

function G.FUNCS.lobby_start_game(e)
	MP.ACTIONS.start_game()
end

function G.FUNCS.lobby_ready_up(e)
	MP.LOBBY.ready_to_start = not MP.LOBBY.ready_to_start

	e.config.colour = MP.LOBBY.ready_to_start and G.C.GREEN or G.C.RED
	e.children[1].children[1].config.text = MP.LOBBY.ready_to_start and localize("b_unready") or localize("b_ready")
	e.UIBox:recalculate()

	if MP.LOBBY.ready_to_start then
		MP.ACTIONS.ready_lobby()
	else
		MP.ACTIONS.unready_lobby()
	end
end

function G.FUNCS.lobby_options(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_lobby_options(),
	})
end

function G.FUNCS.view_code(e)
	local text_config = e.children[1].children[1].config
	if text_config.text ~= MP.LOBBY.code then
		e.config.colour = G.C.ETERNAL
		text_config.text = MP.LOBBY.code
	else
		e.config.colour = G.C.GREEN
		text_config.text = localize("b_view_code")
	end
	e.UIBox:recalculate()
end

function G.FUNCS.lobby_leave(e)
	if G.STAGE ~= G.STAGES.MAIN_MENU then
		G.FUNCS.confirm_selection(function()
			MP.LOBBY.code = nil
			MP.ACTIONS.leave_lobby()
			MP.UI.update_connection_status()
			G.STATE = G.STATES.MENU
		end)
	else
		MP.LOBBY.code = nil
		MP.ACTIONS.leave_lobby()
		MP.UI.update_connection_status()
		G.STATE = G.STATES.MENU
	end
end

function G.FUNCS.lobby_choose_deck(e)
	G.FUNCS.setup_run(e)
	if G.OVERLAY_MENU then G.OVERLAY_MENU:get_UIE_by_ID("run_setup_seed"):remove() end
end

local start_run_ref = G.FUNCS.start_run
G.FUNCS.start_run = function(e, args)
	if MP.LOBBY.code then
		if not args.mp_start then
			G.FUNCS.exit_overlay_menu()
			local chosen_stake = args.stake
			if MP.DECK.MAX_STAKE > 0 and chosen_stake > MP.DECK.MAX_STAKE then
				MP.UI.UTILS.overlay_message(
					"Selected stake is incompatible with Multiplayer, stake set to "
						.. SMODS.stake_from_index(MP.DECK.MAX_STAKE)
				)
				chosen_stake = MP.DECK.MAX_STAKE
			end
			if MP.LOBBY.is_host then
				MP.LOBBY.config.back = args.challenge and "Challenge Deck"
					or (args.deck and args.deck.name)
					or G.GAME.viewed_back.name
				MP.LOBBY.config.stake = chosen_stake
				MP.LOBBY.config.sleeve = G.viewed_sleeve
				MP.LOBBY.config.challenge = args.challenge and args.challenge.id or ""
				send_lobby_options()
			end
			MP.LOBBY.deck.back = args.challenge and "Challenge Deck"
				or (args.deck and args.deck.name)
				or G.GAME.viewed_back.name
			MP.LOBBY.deck.stake = chosen_stake
			MP.LOBBY.deck.sleeve = G.viewed_sleeve
			MP.LOBBY.deck.challenge = args.challenge and args.challenge.id or ""
			MP.ACTIONS.update_player_usernames()
		else
			start_run_ref(e, {
				challenge = args.challenge,
				stake = tonumber(MP.LOBBY.deck.stake),
				seed = args.seed,
			})
		end
	else
		start_run_ref(e, args)
	end
end

function G.FUNCS.display_lobby_main_menu_UI(e)
	G.MAIN_MENU_UI = G.FUNCS.get_lobby_main_menu_UI(e)
	G.MAIN_MENU_UI.alignment.offset.y = 0
	G.MAIN_MENU_UI:align_to_major()

	G.CONTROLLER:snap_to({ node = G.MAIN_MENU_UI:get_UIE_by_ID("lobby_menu_start") })
end

function G.FUNCS.mp_return_to_lobby()
	G.FUNCS.confirm_selection(function()
		MP.ACTIONS.stop_game()
	end)
end

function G.FUNCS.custom_seed_overlay(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_custom_seed_overlay(),
	})
end

function G.FUNCS.custom_seed_reset(e)
	MP.LOBBY.config.custom_seed = "random"
	send_lobby_options()
end

local go_to_menu_ref = G.FUNCS.go_to_menu
function G.FUNCS.go_to_menu()
	if MP.LOBBY.code then
		MP.UI.lobby_transition(up, true)
	end
	go_to_menu_ref()
end

local in_lobby = false
local gameUpdateRef = Game.update
---@diagnostic disable-next-line: duplicate-set-field
function Game:update(dt)
	-- Track lobby state transitions
	if (MP.LOBBY.code and not in_lobby) or (not MP.LOBBY.code and in_lobby) then
		in_lobby = not in_lobby
		G.F_NO_SAVING = in_lobby
		if G.STATE ~= G.STATES.MENU then
			self.FUNCS.go_to_menu()
		else
			MP.UI.lobby_transition(in_lobby)
		end
		MP.reset_game_states()
	end
	-- update stakes and deck with animations when possible
	if MP.LOBBY.code then
	end
	gameUpdateRef(self, dt)
end

-- move everything and create uiboxes
function MP.UI.lobby_transition(state, instant)
	local function shift_screen()
		local sign = state and 1 or -1
		ease_value(G.ROOM_ATTACH.T, "y", sign*10.2, false, nil, true, 0.6, "quad")
		ease_value(G.ROOM_ATTACH.VT, "y", sign*10.2, false, nil, true, 0.6, "quad")
		ease_value(G.title_top.T, "y", sign*13, false, nil, true, 0.6, "quad")
		ease_value(G.title_top.VT, "y", sign*13, false, nil, true, 0.6, "quad")
	end
	local function define_lobby_ui()
		-- give us the uiboxes pls
		G.MP_LOBBY_UI_player_list = UIBox{
			definition = MP.UI.lobby_player_list_def(), 
			config = {align="tli", offset = {x=0,y=-8}, major = G.ROOM_ATTACH, bond = 'Weak'}
		}
		G.MP_LOBBY_UI_player_list:align_to_major()
		G.MP_LOBBY_UI_ruleset_name = UIBox{
			definition = MP.UI.lobby_ruleset_name_def(), 
			config = {align="tmi", offset = {x=0,y=-10.3}, major = G.ROOM_ATTACH, bond = 'Weak'}
		}
		G.MP_LOBBY_UI_ruleset_name:align_to_major()
		-- gimme caaaaaards
		MP.lobby_cards = CardArea(
			20, 20,
			1, 1,
		{card_limit = 4, type = 'title'})
		for i = 1, 4 do
			local card = Card(0.6, -0.8, G.CARD_W*1.2, G.CARD_H*1.2, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base, {playing_card = i})
			card.states.drag.can = false
			card.states.hover.can = false
			MP.lobby_cards:emplace(card)
			card.sprite_facing = 'back'
			card.facing = 'back'
		end
		MP.UI.set_lobby_cards()
		MP.update_lobby_info()
	end
	local function remove_lobby_ui()
		G.MP_LOBBY_UI_player_list:remove()
		G.MP_LOBBY_UI_player_list = nil
		G.MP_LOBBY_UI_ruleset_name:remove()
		G.MP_LOBBY_UI_ruleset_name = nil
		MP.lobby_cards:remove()
		MP.lobby_cards = nil
		MP.LOBBY_CHANGING_DECK = nil
		MP.LOBBY_QUEUED_DECK = nil
	end
	local function shift_elements()
		MP.UI.shift_lobby_cards(state)
	end
	G.FUNCS.exit_overlay_menu()
	if state then
		define_lobby_ui()
		shift_screen()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.6,
			blockable = false,
			blocking = false,
			func = function()
				shift_elements()
				return true
			end
		}))
	else
		shift_elements()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			blockable = false,
			blocking = false,
			func = function()
				shift_screen()
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 1.0,
			blockable = false,
			blocking = false,
			func = function()
				remove_lobby_ui()
				return true
			end
		}))
	end
end

-- definition of the player list uibox
function MP.UI.lobby_player_list_def()
	local slots = 2
	local players = {}
	for i = 1, slots do
		players[i] = MP.UI.lobby_player_box()
	end
	local t = {n=G.UIT.ROOT, config = {align = "cm",colour = G.C.CLEAR}, nodes={
		{n=G.UIT.R, config = {align = "cm", padding= 0.03, colour = G.C.UI.TRANSPARENT_DARK, r=0.1}, nodes={
			{n=G.UIT.R, config = {id = "player_list", align = "cm", padding= 0.03, colour = G.C.DYN_UI.BOSS_DARK, r=0.1}, nodes = players}
		}}
	}}
	return t
end

-- definition of a player box. uses default settings and is recalculated later
function MP.UI.lobby_player_box()
	local animation = AnimatedSprite(0,0, 1.1, 1.1, G.ANIMATION_ATLAS['blind_chips'],  {x = 0, y = 30})
	animation:define_draw_steps({
		{shader = 'dissolve', shadow_height = 0.05},
		{shader = 'dissolve'}
	})
	return {n=G.UIT.R, config = {align = "cm", padding = 0.05, colour = G.C.L_BLACK, r=0.1}, nodes={
		{n=G.UIT.R, config={align = "cm", colour = G.C.DYN_UI.BOSS_DARK, minh = 1.6, r=0.1, padding = 0.08}, nodes = {
			{n=G.UIT.C, config={align = "cm"}, nodes={
				{n=G.UIT.O, config = {object = animation}},
			}},
			{n=G.UIT.C, config={align = "cm", minw = 3.2, maxw = 3.2}, nodes={
				{n=G.UIT.T, config = {text = "Waiting...", scale = 0.48, colour = G.C.WHITE, shadow = true, padding = 0.2}},
			}},
			{n=G.UIT.C, config={align = "cm", padding = 0.12}, nodes={
				{n=G.UIT.C, config={r = 0.1, minw = 0.3, minh = 0.3, maxw = 0.3, maxh = 0.3, emboss = 0.07, colour = G.C.L_BLACK}},
			}},
		}}
	}}
end

-- handles everything to do with updating a player box ui-wise. called by update_lobby_info
function MP.UI.update_player_box(num, args)
	local list = G.MP_LOBBY_UI_player_list:get_UIE_by_ID("player_list")
	local args = args
	if not args then
		args = {blind = "NULL", name = "Waiting...", ready = G.C.L_BLACK}
	end
	
	local box = list.children[num]
	
	-- outline colour
	-- seemingly does not need to recalculate
	box.config.colour = args.blind == "NULL" and G.C.L_BLACK or get_blind_main_colour(args.blind)
	
	-- blind sprite
	local sprite = box.children[1].children[1].children[1]
	sprite.config.object:remove()
	sprite.config.object = AnimatedSprite(
		0,
		0,
		1.1,
		1.1,
		args.blind == "NULL" and G.ANIMATION_ATLAS["blind_chips"] or G.ANIMATION_ATLAS["mp_player_blind_col"],
		args.blind == "NULL" and {x = 0, y = 30} or G.P_BLINDS[args.blind].pos
	)
	sprite.UIBox:recalculate()

	-- name
	box.children[1].children[2].children[1].config.text = args.name
	box.children[1].children[2].children[1].UIBox:recalculate()

	-- ready status
	box.children[1].children[3].children[1].config.colour = args.ready
end

-- definition of the ruleset name uibox
-- could probably use some work, feel free to modify
function MP.UI.lobby_ruleset_name_def()
	local t = {n=G.UIT.ROOT, config = {align = "cm",colour = G.C.CLEAR}, nodes={
		{n=G.UIT.R, config = {align = "cm", padding= 0.03, colour = G.C.UI.TRANSPARENT_DARK, r=0.1}, nodes={
			{n=G.UIT.R, config = {align = "cm", padding= 0.03, colour = G.C.DYN_UI.BOSS_DARK, r=0.1, emboss = 0.2}, nodes = {
				{n=G.UIT.C, config={align = "cm", minw = 14, maxw = 14, minh = 1, maxh = 1}, nodes={
					{n=G.UIT.O, config={id = "ruleset_name", object = DynaText({string = {". . . . . . . . . . ."}, colours = {G.C.WHITE}, shadow = true, float = true, scale = 0.85, spacing = 1})}}
				}}
			}}
		}}
	}}
	return t
end

-- water is wet
function MP.UI.update_ruleset_name(name)
	local text = G.MP_LOBBY_UI_ruleset_name:get_UIE_by_ID("ruleset_name")
	text.config.object:remove()
	text.config.object = DynaText({string = {name}, colours = {G.C.WHITE}, shadow = true, float = true, scale = 0.85, spacing = 1})
	text.UIBox:recalculate()
end

-- set position of lobby cards
function MP.UI.set_lobby_cards()
	MP.LOBBY_CHANGING_DECK = true
	MP.LOBBY_CURRENT_DECK = "b_red"
	local position = {r = 0, x = 23, y = 3}
	for i, v in ipairs(MP.lobby_cards.cards) do
		v.T.r = position.r
		v.T.x = position.x
		v.T.y = position.y
		v:hard_set_T()
	end
	MP.lobby_cards.cards[3].ID = MP.lobby_cards.cards[4].ID
end

-- shift position of lobby cards to default position
function MP.UI.shift_lobby_cards(state)
	local positions = {
		{r = -0.4, x = 12, y = 3.3},
		{r = -0.1, x = 13, y = 3},
		{r = 0.08, x = 14, y = 3},
		{r = 0.08, x = 14, y = 3},
	}
	local r_position = {r = 0, x = 23, y = 3}
	for i, v in ipairs(MP.lobby_cards.cards) do
		local pos = state and positions[i] or r_position
		MP.UI.move_lobby_card(v, pos.r, pos.x, pos.y, 0.4, "quad")
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.4,
		blockable = false,
		blocking = false,
		func = function()
			MP.LOBBY_CHANGING_DECK = false
			if MP.LOBBY_QUEUED_DECK then
				MP.UI.change_lobby_cards(MP.LOBBY_QUEUED_DECK)
				MP.LOBBY_QUEUED_DECK = nil
			end
			return true
		end
	}))
end

-- do a card trick to change the deck
function MP.UI.change_lobby_cards(back)
	if not MP.LOBBY.code then return end
	MP.LOBBY_CHANGING_DECK = true
	MP.LOBBY_CURRENT_DECK = back
	local cards = MP.lobby_cards.cards
	MP.UI.change_lobby_card_back(cards[3], back)
	MP.UI.move_lobby_card(cards[3], -0.3, 11, 3.4, 0.26, "quad")
	MP.UI.move_lobby_card(cards[4], 0.12, 14.1, 3, 0.19, "quad")
	MP.UI.move_lobby_card(cards[2], -0.15, 12.8, 3.1, 0.24, "quad")
	MP.UI.move_lobby_card(cards[1], -0.44, 11.9, 3.5, 0.28, "quad")
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.35,
		blockable = false,
		blocking = false,
		func = function()
			if not MP.LOBBY.code then return true end
			-- cycle to ensure proper layering
			local card = table.remove(cards, 3)
			cards[#cards+1] = card
			MP.UI.move_lobby_card(cards[4], 0, 13.9, 3.2, 0.2, "quad")
			MP.UI.move_lobby_card(cards[3], 0, 13.9, 3, 0.06, "quad")
			MP.UI.move_lobby_card(cards[2], 0, 13.9, 3.05, 0.16, "quad")
			MP.UI.move_lobby_card(cards[1], 0, 13.9, 3.3, 0.21, "quad")
			
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({ 
		trigger = "after",
		delay = 0.63,
		blockable = false,
		blocking = false,
		func = function()
			if not MP.LOBBY.code then return true end
			MP.UI.move_lobby_card(cards[4], 0, 13.9, 3, 0.11, "lerp")
			MP.UI.move_lobby_card(cards[3], 0, 13.9, 3, 0.1, "lerp")
			MP.UI.move_lobby_card(cards[2], 0, 13.9, 3, 0.096, "lerp")
			MP.UI.move_lobby_card(cards[1], 0, 13.9, 3, 0.1, "lerp")
			
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.89,
		blockable = false,
		blocking = false,
		func = function()
			if not MP.LOBBY.code then return true end
			MP.UI.change_lobby_card_back(cards[3], back)
			MP.UI.change_lobby_card_back(cards[2], back)
			MP.UI.change_lobby_card_back(cards[1], back)
			MP.UI.move_lobby_card(cards[4], 0.08, 14, 3, 0.13, "quad")
			MP.UI.move_lobby_card(cards[3], 0.08, 14, 3, 0.13, "quad")
			MP.UI.move_lobby_card(cards[2], -0.1, 13, 3, 0.162, "quad")
			MP.UI.move_lobby_card(cards[1], -0.4, 12, 3.3, 0.215, "quad")
			
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1.2,
		blockable = false,
		blocking = false,
		func = function()
			MP.LOBBY_CHANGING_DECK = false
			if MP.LOBBY_QUEUED_DECK then
				MP.UI.change_lobby_cards(MP.LOBBY_QUEUED_DECK)
				MP.LOBBY_QUEUED_DECK = nil
			end
			return true
		end
	}))
end

-- visual change back function that's weird but whatever
-- i didn't want to do dumb shit with set_sprites
function MP.UI.change_lobby_card_back(card, back)
	card.children.back:remove()
	card.children.back = SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.P_CENTERS[back].atlas or "centers", G.P_CENTERS[back].pos)
	card.children.back.states.hover = card.states.hover
	card.children.back.states.click = card.states.click
	card.children.back.states.drag = card.states.drag
	card.children.back.states.collide.can = false
	card.children.back:set_role({major = card, role_type = 'Glued', draw_major = card})
end

-- wrapper for ease_value so i don't have to write the same thing too many times
function MP.UI.move_lobby_card(card, r, x, y, time, ease)
	ease_value(card.T, "r", r-card.T.r, false, nil, true, time, ease)
	ease_value(card.VT, "r", r-card.VT.r, false, nil, true, time, ease)
	ease_value(card.T, "x", x-card.T.x, false, nil, true, time, ease)
	ease_value(card.VT, "x", x-card.VT.x, false, nil, true, time, ease)
	ease_value(card.T, "y", y-card.T.y, false, nil, true, time, ease)
	ease_value(card.VT, "y", y-card.VT.y, false, nil, true, time, ease)
end

-- do not align lobby cards since we're hard setting their positions
local align_cards_ref = CardArea.align_cards
function CardArea:align_cards()
	if self == MP.lobby_cards then
		return
	end
	return align_cards_ref(self)
end


-- update the lobby
-- master function that formats data and sends it into update functions
function MP.update_lobby_info()
	-- player list
	for i, v in ipairs({"host", "guest"}) do
		local args = nil
		if MP.LOBBY[v].username then
			args = {
				blind = MP.UTILS.blind_col_numtokey(MP.LOBBY[v].blind_col),
				name = MP.LOBBY[v].username,
				-- currently ready is attached to ready_to_start instead of individual players. change this later
				ready = (v == "host" and G.C.BLUE) or (MP.LOBBY.ready_to_start and G.C.GREEN or G.C.RED),
			}
		end
		MP.UI.update_player_box(i, args)
	end

	-- ruleset name
	local ruleset = string.sub(MP.LOBBY.config.ruleset, 12, -1)
	local gamemode = string.sub(MP.LOBBY.config.gamemode, 13, -1)
	local name = localize("k_"..ruleset)
	if not MP.Rulesets[MP.LOBBY.config.ruleset].forced_gamemode then
		name = name.." "..localize("k_"..gamemode)
	end

	MP.UI.update_ruleset_name(string.upper(name))

	-- deck
	local deck = (MP.UTILS.get_deck_key_from_name(MP.LOBBY.config.different_decks and MP.LOBBY.deck.back or MP.LOBBY.config.back) or "b_red")
	if MP.LOBBY_CURRENT_DECK ~= deck then
		if not MP.LOBBY_CHANGING_DECK then
			MP.UI.change_lobby_cards(deck)
		else
			MP.LOBBY_QUEUED_DECK = deck
		end
	end
end

-- move overlay menu when in lobby to make it act normally
local overlay_menu_ref = G.FUNCS.overlay_menu
G.FUNCS.overlay_menu  = function(args)
	if MP.LOBBY.code then
		args.config = args.config or {offset = {x = 0, y = 10}}
		args.config.offset = args.config.offset or {x = 0, y = 10}
		args.config.offset.y = -0.2
	end
	overlay_menu_ref(args)
	if MP.LOBBY.code then
		G.OVERLAY_MENU.alignment.offset.y = -10.2
	end
end

function G.UIDEF.create_UIBox_unstuck()
	return (
		create_UIBox_generic_options({
			back_func = "options",
			contents = {
				{
					n = G.UIT.C,
					config = {
						padding = 0.2,
						align = "cm",
					},
					nodes = {
						UIBox_button({ label = { localize("b_unstuck_blind") }, button = "mp_unstuck_blind", minw = 5 }),
					},
				},
			},
		})
	)
end

function G.FUNCS.mp_unstuck()
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_unstuck(),
	})
end

function G.FUNCS.mp_unstuck_arcana()
	G.FUNCS.skip_booster()
end

function G.FUNCS.mp_unstuck_blind()
	MP.GAME.ready_blind = false
	if MP.GAME.next_blind_context then
		G.FUNCS.select_blind(MP.GAME.next_blind_context)
	else
		sendErrorMessage("No next blind context", "MULTIPLAYER")
	end
end

function MP.UI.update_connection_status()
	if G.HUD_connection_status then G.HUD_connection_status:remove() end
	if G.STAGE == G.STAGES.MAIN_MENU then G.HUD_connection_status = G.UIDEF.get_connection_status_ui() end
end

local gameMainMenuRef = Game.main_menu
---@diagnostic disable-next-line: duplicate-set-field
function Game:main_menu(change_context)
	gameMainMenuRef(self, change_context)
	MP.UI.update_connection_status()
end

function G.FUNCS.copy_to_clipboard(e)
	MP.UTILS.copy_to_clipboard(MP.LOBBY.code)
end

function G.FUNCS.reconnect(e)
	MP.ACTIONS.connect()
	G.FUNCS.exit_overlay_menu()
end