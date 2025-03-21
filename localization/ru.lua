-- Localization by @astryder75, @KilledByLava, @FaLNioNe and @sidmeierscivilizationv on discord
return {
	descriptions = {
		Joker = {
			j_broken = {
				name = "ОШИБКА",
				text = {
					"Эта карта либо сломана",
					"либо ещё не добавлена в",
					"данной версии мода.",
				},
			},
			j_mp_defensive_joker = {
				name = "Защитный джокер",
				text = {
					"{C:chips}+#1#{} шт. фишек",
					"за каждую потерянную",
					"{C:red,E:1}жизнь{} в этом забеге",
					"{C:inactive}(Сейчас: {C:chips}+#2#{C:inactive} шт. фишек)",
				},
			},
			j_mp_skip_off = {
				name = "Пропускнофф",
				text = {
					"{C:blue}+#1#{} Рука и {C:red}+#2#{} Сброс за каждую разницу",
					"пропущенных {C:attention}Блайндов{}",
					"по сравнению с вашим {X:purple,C:white}Соперником{}",
					"{C:inactive}(Сейчас: {C:blue}+#3#{C:inactive}/{C:red}+#4#{C:inactive}, #5#)",
				},
			},
			j_mp_lets_go_gambling = {
				name = "Крутите барабан",
				text = {
					"{C:green}#1# к #2#{} шанс дать",
					"{X:mult,C:white}X#3#{} множ. и {C:money}$#4#{}",
					"{C:green}#5# к #6#{} шанс дать",
					"вашему {X:purple,C:white}Сопернику{} {C:money}$#7#",
				},
			},
			j_mp_speedrun = {
				name = "СПИДРАН",
				text = {
					"Создаёт случайную {C:spectral}Спектральную{} карту,",
					"если вы достигнете {C:attention}ПвП-блайнд",
					"быстрее вашего {X:purple,C:white}Соперника{},",
					"{C:inactive}(должно быть место)",
				},
			},
			j_mp_conjoined_joker = {
				name = "Соединённый джокер",
				text = {
					"Когда в {C:attention}ПвП-блайнде{}, даёт",
					"{X:mult,C:white}X#1#{} множ. за каждую {C:blue}Руку{}",
					"которая есть у вашего {X:purple,C:white}Соперника{}",
					"{C:inactive}(Максимум: {X:mult,C:white}X#2#{C:inactive} множ., Сейчас: {X:mult,C:white}X#3#{C:inactive} множ.)",
				},
			},
			j_mp_penny_pincher = {
				name = "Крохобор",
				text = {
					"В начале магазина даёт {C:money}$#1#{}",
					"за каждые {C:money}$#2#{}",
					"потраченных вашим {X:purple,C:white}Соперником{}",
					"в прошлом магазине",
				},
			},
			j_mp_taxes = {
				name = "Налоги",
				text = {
					"Получает {C:mult}+#1#{} множ., когда",
					"ваш {X:purple,C:white}Соперник{} продаёт карту",
					"{C:inactive}(Сейчас: {C:mult}+#2#{C:inactive} множ.)",
				},
			},
			j_mp_magnet = {
				name = "Магнит",
				text = {
					"После {C:attention}#1#{} раундов, продайте эту карту чтобы",
					"{C:attention}скопировать{} {C:attention}джокера{} с наибольшей суммой",
					"продажи у вашего {X:purple,C:white}Соперника{}",
					"{C:inactive}(Сейчас: {C:attention}#2#{C:inactive}/#3# раундов)",
					"{C:inactive,s:0.8}(Не копирует состояние джокера)",
				},
			},
			j_mp_pizza = {
				name = "Пицца",
				text = {
					"{C:red}+#1#{} Сбросов каждому игроку",
					"{C:red}-#2#{} Сброс когда любой игрок выбирает Блайнд",
					"Съедается когда {X:purple,C:white}Соперник{} пропускает Блайнд",
				},
			},
			j_mp_pacifist = {
				name = "Пацифист",
				text = {
					"{X:mult,C:white}X#1#{} множ. когда",
					"не в {C:attention}ПвП-блайнде{}",
				},
			},
			j_mp_hanging_chad = {
				name = "Еще разок",
				text = {
					"Перезапуск{C:attention}первой{} и {C:attention}второй{}",
					"игральных карт в подсчёте",
					"{C:attention}#1#{} доп. р.",
				},
			},
		},
		Planet = {
			c_mp_asteroid = {
				name = "Астероид",
				text = {
					"Убирает #1# уровень с",
					"самой прокачанной {C:legendary,E:1}комбинации{}",
					"вашего {X:purple,C:white}Соперника{}",
				},
			},
		},
		Blind = {
			bl_mp_nemesis = {
				name = "Ваш Соперник",
				text = {
					"Сражение с вашим Соперником,",
					"игрок с наибольшим счётом побеждает",
				},
			},
		},
		Edition = {
			e_mp_phantom = {
				name = "Фантомный",
				text = {
					"{C:attention}Вечный{} и {C:dark_edition}Негативный{}",
					"Создаётся и уничтожается вашим {X:purple,C:white}Соперником{}",
				},
			},
		},
		Enhanced = {
			m_mp_glass = {
				name = "Стеклянная карта",
				text = {
					"{X:mult,C:white} X#1# {} множ.",
					"{C:green}#2# к #3#{} шанс",
					"разбиться при подсчёте",
				},
			},
		},
		Other = {
			current_nemesis = {
				name = "Соперник",
				text = {
					"{X:purple,C:white}#1#{}",
					"Ваш один-единственный Соперник",
				},
			},
		},
	},
	misc = {
		labels = {
			mp_phantom = "Фантомный",
		},
		challenge_names = {
			c_mp_standard = "Стандартный режим",
			c_mp_badlatro = "Плохлатро",
			c_mp_tournament = "Турнирный режим",
			c_mp_weekly = "Недельный режим",
			c_mp_vanilla = "Ванилла",
		},
		dictionary = {
			b_singleplayer = "Одиночная Игра",
			b_join_lobby = "Подключиться к лобби",
			b_return_lobby = "Вернуться в лобби",
			b_reconnect = "Переподключиться",
			b_create_lobby = "Создать лобби",
			b_start_lobby = "Начать игру",
			b_ready = "Приготовиться",
			b_unready = "Отменить",
			b_leave_lobby = "Выйти из лобби",
			b_mp_discord = "Дискорд Серверу Balatro Multiplayer",
			b_start = "НАЧАТЬ",
			b_wait_for_host_start = { "ЖДЁМ", "НАЧАЛА ИГРЫ" },
			b_wait_for_players = { "ЖДЁМ", "ИГРОКОВ" },
			b_lobby_options = "ПАРАМЕТРЫ ЛОББИ",
			b_copy_clipboard = "Скопировать",
			b_view_code = "УВИДЕТЬ КОД",
			b_leave = "ВЫЙТИ",
			b_opts_cb_money = "Давать доп. золото при потере жизни",
			b_opts_no_gold_on_loss = "Не давать золото при поражении раунда",
			b_opts_death_on_loss = "Терять жизнь при поражении не ПвП-блайнда",
			b_opts_start_antes = "Количество анте до ПвП-блайндов",
			b_opts_diff_seeds = "У игроков разные сиды",
			b_opts_lives = "Количество жизней",
			b_opts_multiplayer_jokers = "Включить джокеров из мода",
			b_opts_player_diff_deck = "У игроков разные колоды",
			b_reset = "Сбросить",
			b_set_custom_seed = "Использовать Свой",
			b_mp_kofi_button = "поддержать меня на Ko-fi",
			b_unstuck = "Выбраться",
			b_unstuck_arcana = "Выбраться из бустерного пака",
			b_unstuck_blind = "Выбраться из ПвП-блайнда",
			k_enemy_score = "Счёт Соперника",
			k_enemy_hands = "Количество рук у Соперника: ",
			k_coming_soon = "Скоро!",
			k_wait_enemy = "Ждём, пока Соперник закончит...",
			k_lives = "Жизни",
			k_lost_life = "Потеряна жизнь",
			k_total_lives_lost = " жизней потеряно (По $4 каждая)",
			k_attrition_name = "Истощение",
			k_enter_lobby_code = "Введите код лобби",
			k_paste = "Вставить с буфера обмена",
			k_username = "Имя:",
			k_enter_username = "Введите имя",
			k_join_discord = "Присоединяйтесь к ",
			k_discord_msg = "Там вы можете сообщать об ошибках и находить игроков",
			k_enter_to_save = "Нажмите enter чтобы сохранить",
			k_in_lobby = "В лобби",
			k_connected = "Подключено к сервисам",
			k_warn_service = "ПРЕДУПРЕЖДЕНИЕ: Не получилось найти сервисы",
			k_set_name = "Введите своё имя в главном меню! (Mods > Multiplayer > Config)",
			k_mod_hash_warning = "У игроков разные моды либо разные версии модов! Это может привести к ошибкам!",
			k_lobby_options = "Параметры лобби",
			k_connect_player = "Игроки в лобби:",
			k_opts_only_host = "Только ведущий может менять эти настройки",
			k_opts_gm = "Настройки игры",
			k_bl_life = "Жизнь",
			k_bl_or = "или",
			k_bl_death = "Смерть",
			k_current_seed = "Сид лобби: ",
			k_random = "Случайный",
			k_standard = "Стандартный режим",
			k_standard_description = "Стандартные правила, в которые включены уникальные карты мода и ребалансы базовой игры.",
			k_vanilla = "Ванилла",
			k_vanilla_description = "Ваниальные првила, без карт мода, без ребалансов базовой игры.",
			k_weekly = "Недельный режим",
			k_weekly_description = "Специальный режим, меняется раз в одну-две недели. Похоже придётся понять какой он вам самим! Сейчас: ",
			k_tournament = "Турнирный режим",
			k_tournament_description = "Правила турниров, те же правила, что и в стандартном режиме, но запрещает менять параметры лобби.",
			k_badlatro = "Плохлатро",
			k_badlatro_description = "Недельный режим, разработанный пользователем дискорд сервера, @dr_monty_the_snek, и добавленный на постоянной основе.",
			k_oops_ex = "Упс!",
			ml_enemy_loc = { "Статус", "Соперника" },
			ml_mp_kofi_message = {
				"Данный мод и сервер для него",
				"разработан и обслуживается",
				"одним человеком, при",
				"желании вы можете",
			},
			loc_ready = "Готов к сражению",
			loc_selecting = "Выбирает Блайнд",
			loc_shop = "В магазине",
			loc_playing = "Против ",
		},
		v_dictionary = {
			a_mp_art = { "Дизайн: #1#" },
			a_mp_code = { "Код: #1#" },
			a_mp_idea = { "Идея: #1#" },
			a_mp_skips_ahead = { "Впереди на #1# пропусков" },
			a_mp_skips_behind = { "Позади на #1# пропусков" },
			a_mp_skips_tied = { "Равны" },
		},
		v_text = {
			ch_c_hanging_chad_rework = { "{C:attention}Ещё разок{} {C:dark_edition}ребалансирован" },
			ch_c_glass_cards_rework = { "{C:attention}Стеклянные карты{} {C:dark_edition}ребалансированы" },
		},
	},
}
