/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the IC data card reader
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = WEIGHT_CLASS_TINY

	var/list/files = list()

/obj/item/card/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins to swipe [user.p_their()] neck with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/card/data
	name = "data card"
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has a stripe running down the middle."
	icon_state = "data_1"
	obj_flags = UNIQUE_RENAME
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	var/detail_color = COLOR_ASSEMBLY_ORANGE

/obj/item/card/data/Initialize()
	.=..()
	update_icon()

/obj/item/card/data/update_icon()
	cut_overlays()
	if(detail_color == COLOR_FLOORTILE_GRAY)
		return
	var/mutable_appearance/detail_overlay = mutable_appearance('icons/obj/card.dmi', "[icon_state]-color")
	detail_overlay.color = detail_color
	add_overlay(detail_overlay)

/obj/item/card/data/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/integrated_electronics/detailer))
		var/obj/item/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	return ..()

/obj/item/proc/GetCard()

/obj/item/card/data/GetCard()
	return src

/obj/item/card/data/full_color
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has the entire card colored."
	icon_state = "data_2"

/obj/item/card/data/disk
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one inexplicibly looks like a floppy disk."
	icon_state = "data_3"

/*
 * ID CARDS
 */
/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	item_flags = NO_MAT_REDEMPTION | NOBLUDGEON
	var/prox_check = TRUE //If the emag requires you to be in range
	var/uses = 10

/obj/item/card/emag/bluespace
	name = "bluespace cryptographic sequencer"
	desc = "It's a blue card with a magnetic strip attached to some circuitry. It appears to have some sort of transmitter attached to it."
	icon_state = "emag_bs"
	prox_check = FALSE

/obj/item/card/emag/attack()
	return

/obj/item/card/emag/afterattack(atom/target, mob/user, proximity)
	. = ..()
	var/atom/A = target
	if(!proximity && prox_check || !(isobj(A) || issilicon(A) || isbot(A) || isdrone(A)))
		return
	if(istype(A, /obj/item/storage) && !(istype(A, /obj/item/storage/lockbox) || istype(A, /obj/item/storage/pod)))
		return
	if(!uses)
		user.visible_message("<span class='warning'>[src] emits a weak spark. It's burnt out!</span>")
		playsound(src, 'sound/effects/light_flicker.ogg', 100, 1)
		return
	else if(uses <= 3)
		playsound(src, 'sound/effects/light_flicker.ogg', 30, 1)	//Tiiiiiiny warning sound to let ya know your emag's almost dead
	if(!A.emag_act(user))
		return
	uses = max(uses - 1, 0)
	if(!uses)
		user.visible_message("<span class='warning'>[src] fizzles and sparks. It seems like it's out of charges.</span>")
		playsound(src, 'sound/effects/light_flicker.ogg', 100, 1)

/obj/item/card/emag/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It has <b>[uses ? uses : "no"]</b> charges left.</span>"

/obj/item/card/emag/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/emagrecharge))
		var/obj/item/emagrecharge/ER = W
		if(ER.uses)
			uses += ER.uses
			to_chat(user, "<span class='notice'>You have added [ER.uses] charges to [src]. It now has [uses] charges.</span>")
			playsound(src, "sparks", 100, 1)
			ER.uses = 0
		else
			to_chat(user, "<span class='warning'>[ER] has no charges left.</span>")
		return
	. = ..()

/obj/item/emagrecharge
	name = "electromagnet charging device"
	desc = "A small cell with two prongs lazily jabbed into it. It looks like it's made for charging the small batteries found in electromagnetic devices, sadly this can't be recharged like a normal cell."
	icon = 'icons/obj/module.dmi'
	icon_state = "cell_mini"
	item_flags = NOBLUDGEON
	var/uses = 5	//Dictates how many charges the device adds to compatible items

/obj/item/emagrecharge/examine(mob/user)
	. = ..()
	if(uses)
		. += "<span class='notice'>It can add up to [uses] charges to compatible devices</span>"
	else
		. += "<span class='warning'>It has a small, red, blinking light coming from inside of it. It's spent.</span>"

/obj/item/card/emagfake
	desc = "It's a card with a magnetic strip attached to some circuitry. Closer inspection shows that this card is a poorly made replica, with a \"DonkCo\" logo stamped on the back."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'

/obj/item/card/emagfake/afterattack()
	. = ..()
	playsound(src, 'sound/items/bikehorn.ogg', 50, 1)

/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	slot_flags = ITEM_SLOT_ID
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/id_type_name = "identification card"
	var/mining_points = 0 //For redeeming at mining equipment vendors
	var/list/access = list()
	var/registered_name = null // The name registered_name on the card
	var/assignment = null
	var/access_txt // mapping aid
	var/datum/bank_account/registered_account
	var/uses_overlays = TRUE
	var/uses_assignment = TRUE
	var/icon/cached_flat_icon

/obj/item/card/id/Initialize(mapload)
	. = ..()
	if(mapload && access_txt)
		access = text2access(access_txt)

/obj/item/card/id/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if("assignment","registered_name")
				update_label()

/obj/item/card/id/attack_self(mob/user)
	if(Adjacent(user))
		user.visible_message("<span class='notice'>[user] shows you: [icon2html(src, viewers(user))] [src.name].</span>", \
					"<span class='notice'>You show \the [src.name].</span>")
		add_fingerprint(user)
		return

/obj/item/card/id/examine(mob/user)
	. = ..()
	if(mining_points)
		. += "There's [mining_points] mining equipment redemption point\s loaded onto this card."

/obj/item/card/id/GetAccess()
	return access

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/RemoveID()
	return src

/obj/item/card/id/update_icon()
	. = ..()
	if(!uses_overlays)
		return
	cached_flat_icon = null
	var/job = assignment ? ckey(GetJobName()) : null
	if(registered_name == "Captain")
		job = "captain"
	if(registered_name && registered_name != "Captain" && uses_assignment == TRUE)
		overlays += mutable_appearance(icon, "assigned")
	if(job)
		overlays += mutable_appearance(icon, "id[job]")

/obj/item/card/id/proc/get_cached_flat_icon()
	if(!cached_flat_icon)
		cached_flat_icon = getFlatIcon(src)
	return cached_flat_icon

/obj/item/card/id/get_examine_string(mob/user, thats = FALSE)
	if(uses_overlays)
		return "[icon2html(get_cached_flat_icon(), user)] [thats? "That's ":""][get_examine_name(user)]" //displays all overlays in chat
	return ..()

/obj/item/card/id/proc/update_label(newname, newjob)
	if(newname || newjob)
		name = "[(!newname)	? "identification card"	: "[newname]'s ID Card"][(!newjob) ? "" : " ([newjob])"]"
		update_icon()
		return

	name = "[(!registered_name)	? "identification card"	: "[registered_name]'s ID Card"][(!assignment) ? "" : " ([assignment])"]"
	update_icon()

/obj/item/card/id/silver
	name = "silver identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'

/obj/item/card/id/gold
	name = "gold identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'

/obj/item/card/id/syndicate
	name = "agent card"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE)
	var/anyone = FALSE //Can anyone forge the ID or just syndicate?
	var/forged = FALSE //have we set a custom name and job assignment, or will we use what we're given when we chameleon change?

/obj/item/card/id/syndicate/Initialize()
	. = ..()
	var/datum/action/item_action/chameleon/change/chameleon_action = new(src)
	chameleon_action.chameleon_type = /obj/item/card/id
	chameleon_action.chameleon_name = "ID Card"
	chameleon_action.initialize_disguises()

/obj/item/card/id/syndicate/afterattack(obj/item/O, mob/user, proximity)
	if(!proximity)
		return
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/I = O
		src.access |= I.access
		if(isliving(user) && user.mind)
			if(user.mind.special_role || anyone)
				to_chat(usr, "<span class='notice'>The card's microscanners activate as you pass it over the ID, copying its access.</span>")

/obj/item/card/id/syndicate/attack_self(mob/user)
	if(isliving(user) && user.mind)
		var/first_use = registered_name ? FALSE : TRUE
		if(!(user.mind.special_role || anyone)) //Unless anyone is allowed, only syndies can use the card, to stop metagaming.
			if(first_use) //If a non-syndie is the first to forge an unassigned agent ID, then anyone can forge it.
				anyone = TRUE
			else
				return ..()

	var/popup_input
	popup_input = alert(user, "Choose Action", "Agent ID", "Show", "Forge")
	if(!user.canUseTopic(src, BE_CLOSE, FALSE))
		return
	if(popup_input == "Forge")
		var/input_name = stripped_input(user, "What name would you like to put on this card?", "Agent card name", registered_name ? registered_name : (ishuman(user) ? user.real_name : user.name), MAX_NAME_LEN)
		input_name = reject_bad_name(input_name)
		var/target_occupation = stripped_input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", assignment ? assignment : "Assistant", MAX_MESSAGE_LEN)
		if(!target_occupation)
			return
		registered_name = input_name
		assignment = target_occupation
		update_label()
		to_chat(user, "<span class='notice'>You successfully forge the ID card.</span>")
		log_game("[key_name(user)] has forged \the [initial(name)] with name \"[registered_name]\" and occupation \"[assignment]\".")
	return ..()

/obj/item/card/id/syndicate/anyone
	anyone = TRUE

/obj/item/card/id/syndicate/nuke_leader
	name = "lead agent card"
	icon_state = "syndie"
	assignment = "Nuclear Operative"
	uses_assignment = FALSE
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)

/obj/item/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	icon_state = "syndie"
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	uses_assignment = FALSE
	access = list(ACCESS_SYNDICATE)

/obj/item/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/card/id/captains_spare/Initialize()
	var/datum/job/captain/J = new/datum/job/captain
	access = J.get_access()
	. = ..()

/obj/item/card/id/centcom
	name = "\improper CentCom ID"
	desc = "An ID straight from Central Command."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/centcom/Initialize()
	access = get_all_accesses()+get_all_centcom_access()
	. = ..()

/obj/item/card/id/ert
	name = "\improper CentCom ID"
	desc = "An ERT ID card."
	icon_state = "ert_commander"
	registered_name = "Emergency Response Team Commander"
	assignment = "Emergency Response Team Commander"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/ert/Initialize()
	access = get_all_accesses()+get_ert_access("commander")-ACCESS_CHANGE_IDS
	. = ..()

/obj/item/card/id/ert/Security
	icon_state = "ert_security"
	registered_name = "Security Response Officer"
	assignment = "Security Response Officer"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/ert/Security/Initialize()
	access = get_all_accesses()+get_ert_access("sec")-ACCESS_CHANGE_IDS
	. = ..()

/obj/item/card/id/ert/Engineer
	icon_state = "ert_engineer"
	registered_name = "Engineer Response Officer"
	assignment = "Engineer Response Officer"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/ert/Engineer/Initialize()
	access = get_all_accesses()+get_ert_access("eng")-ACCESS_CHANGE_IDS
	. = ..()

/obj/item/card/id/ert/Medical
	icon_state = "ert_medical"
	registered_name = "Medical Response Officer"
	assignment = "Medical Response Officer"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/ert/Medical/Initialize()
	access = get_all_accesses()+get_ert_access("med")-ACCESS_CHANGE_IDS
	. = ..()

/obj/item/card/id/ert/chaplain
	icon_state = "ert_chaplain"
	registered_name = "Religious Response Officer"
	assignment = "Religious Response Officer"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/ert/chaplain/Initialize()
	access = get_all_accesses()+get_ert_access("sec")-ACCESS_CHANGE_IDS
	. = ..()

/obj/item/card/id/prisoner
	name = "prisoner ID card"
	desc = "You are a number, you are not a free man."
	icon_state = "orange"
	item_state = "orange-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	assignment = "Prisoner"
	access = list(ACCESS_ENTER_GENPOP)
	uses_assignment = FALSE
	uses_overlays = FALSE

	//Lavaland labor camp
	var/goal = 0 //How far from freedom?
	var/points = 0
	//Genpop
	var/sentence = 0	//When world.time is greater than this number, the card will have its ACCESS_ENTER_GENPOP access replaced with ACCESS_LEAVE_GENPOP the next time it's checked, unless this value is 0/null
	var/crime= "\[REDACTED\]"

/obj/item/card/id/prisoner/GetAccess()
	if((sentence && world.time >= sentence) || (goal && points >= goal))
		access = list(ACCESS_LEAVE_GENPOP)
	return ..()

/obj/item/card/id/prisoner/process()
	if(!sentence)
		STOP_PROCESSING(SSobj, src)
		return
	if(world.time >= sentence)
		playsound(loc, 'sound/machines/ping.ogg', 50, 1)
		if(isliving(loc))
			to_chat(loc, "<span class='boldnotice'>[src]</span><span class='notice'> buzzes: You have served your sentence! You may now exit prison through the turnstiles and collect your belongings.</span>")
		STOP_PROCESSING(SSobj, src)
	return

/obj/item/card/id/prisoner/examine(mob/user)
	. = ..()
	if(sentence && world.time < sentence)
		. += "<span class='notice'>You're currently serving a sentence for [crime]. <b>[DisplayTimeText(sentence - world.time)]</b> left.</span>"
	else if(goal)
		. += "<span class='notice'>You have accumulated [points] out of the [goal] points you need for freedom.</span>"
	else if(!sentence)
		. += "<span class='warning'>You are currently serving a permanent sentence for [crime].</span>"
	else
		. += "<span class='notice'>Your sentence is up! You're free!</span>"

/obj/item/card/id/prisoner/one
	icon_state = "prisoner_001"
	name = "Prisoner #13-001"
	registered_name = "Prisoner #13-001"
	uses_overlays = FALSE

/obj/item/card/id/prisoner/two
	icon_state = "prisoner_002"
	name = "Prisoner #13-002"
	registered_name = "Prisoner #13-002"
	uses_overlays = FALSE

/obj/item/card/id/prisoner/three
	icon_state = "prisoner_003"
	name = "Prisoner #13-003"
	registered_name = "Prisoner #13-003"
	uses_overlays = FALSE

/obj/item/card/id/prisoner/four
	icon_state = "prisoner_004"
	name = "Prisoner #13-004"
	registered_name = "Prisoner #13-004"
	uses_overlays = FALSE

/obj/item/card/id/prisoner/five
	icon_state = "prisoner_005"
	name = "Prisoner #13-005"
	registered_name = "Prisoner #13-005"
	uses_overlays = FALSE

/obj/item/card/id/prisoner/six
	icon_state = "prisoner_006"
	name = "Prisoner #13-006"
	registered_name = "Prisoner #13-006"
	uses_overlays = FALSE

/obj/item/card/id/prisoner/seven
	icon_state = "prisoner_007"
	name = "Prisoner #13-007"
	registered_name = "Prisoner #13-007"
	uses_overlays = FALSE

/obj/item/card/id/mining
	name = "mining ID"
	icon_state = "retro"
	access = list(ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM)
	uses_overlays = FALSE

/obj/item/card/id/away
	name = "a perfectly generic identification card"
	desc = "A perfectly generic identification card. Looks like it could use some flavor."
	icon_state = "retro"
	access = list(ACCESS_AWAY_GENERAL)
	uses_overlays = FALSE

/obj/item/card/id/away/hotel
	name = "Staff ID"
	desc = "A staff ID used to access the hotel's doors."
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINT)
	icon_state = "retrosrv"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/away/hotel/securty
	name = "Officer ID"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINT, ACCESS_AWAY_SEC)
	icon_state = "retrosec"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/away/old
	name = "a perfectly generic identification card"
	desc = "A perfectly generic identification card. Looks like it could use some flavor."
	icon_state = "centcom"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/away/old/sec
	name = "Charlie Station Security Officer's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Security Officer\"."
	assignment = "Charlie Station Security Officer"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_SEC)
	icon_state = "retrosec"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/away/old/sci
	name = "Charlie Station Scientist's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Scientist\"."
	assignment = "Charlie Station Scientist"
	access = list(ACCESS_AWAY_GENERAL)
	icon_state = "retrosci"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/away/old/eng
	name = "Charlie Station Engineer's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Station Engineer\"."
	assignment = "Charlie Station Engineer"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINE)
	icon_state = "retroeng"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/away/old/apc
	name = "APC Access ID"
	desc = "A special ID card that allows access to APC terminals."
	access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "retrosup"
	uses_overlays = FALSE
	uses_assignment = FALSE

//Polychromatic Knight Badge

/obj/item/card/id/knight
	var/id_color = "#00FF00" //defaults to green
	name = "knight badge"
	icon_state = "knight"
	desc = "A badge denoting the owner as a knight! It has a strip for swiping like an ID"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/knight/update_label(newname, newjob)
	if(newname || newjob)
		name = "[(!newname)	? "knight badge"	: "[newname]'s Knight Badge"][(!newjob) ? "" : " ([newjob])"]"
		return

	name = "[(!registered_name)	? "knight badge"	: "[registered_name]'s Knight Badge"][(!assignment) ? "" : " ([assignment])"]"

/obj/item/card/id/knight/update_icon()
	var/mutable_appearance/id_overlay = mutable_appearance(icon, "knight_overlay")

	if(id_color)
		id_overlay.color = id_color
	cut_overlays()

	add_overlay(id_overlay)

/obj/item/card/id/knight/AltClick(mob/living/user)
	. = ..()
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return TRUE
	if(alert("Are you sure you want to recolor your id?", "Confirm Repaint", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",id_color) as color|null
		if(!in_range(src, user) || !energy_color_input)
			return TRUE
		if(user.incapacitated() || !istype(user))
			to_chat(user, "<span class='warning'>You can't do that right now!</span>")
			return TRUE
		id_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
		update_icon()
		return TRUE

/obj/item/card/id/knight/Initialize()
	. = ..()
	update_icon()

/obj/item/card/id/knight/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to recolor it.</span>"

/obj/item/card/id/knight/blue
	id_color = "#0000FF"

/obj/item/card/id/knight/captain
	id_color = "#FFD700"

/obj/item/card/id/away/snowdin/eng
	name = "Arctic Station Engineer's ID card"
	desc = "A faded Arctic Station ID card. You can make out the rank \"Station Engineer\"."
	assignment = "Arctic Station Engineer"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_ENGINE, ACCESS_AWAY_MAINT)
	icon_state = "retroeng"
	uses_overlays = FALSE
	uses_assignment = FALSE

/obj/item/card/id/away/snowdin/sci
	name = "Arctic Station Scientist's ID card"
	desc = "A faded Arctic Station ID card. You can make out the rank \"Scientist\"."
	assignment = "Arctic Station Scientist"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINT)
	icon_state = "retrosci"
	uses_overlays = FALSE
	uses_assignment = FALSE
	
/obj/item/card/id/away/snowdin/med
	name = "Arctic Station Doctor's ID card"
	desc = "A faded Arctic Station ID card. You can make out the rank \"Doctor\"."
	assignment = "Arctic Station Doctor"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MED, ACCESS_AWAY_MAINT)
	icon_state = "retromed"
	uses_overlays = FALSE

/obj/item/card/id/away/snowdin/sec
	name = "Arctic Station Security's ID card"
	desc = "A faded Arctic Station ID card. You can make out the rank \"Security\"."
	assignment = "Arctic Station Security"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_SEC, ACCESS_AWAY_MAINT)
	icon_state = "retrosec"
	uses_overlays = FALSE

/obj/item/card/id/away/snowdin/captain
	name = "Arctic Station Captain's ID card"
	desc = "A faded Arctic Station ID card. You can make out the rank \"Captain\"."
	assignment = "Arctic Station Captain"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_MAINT)
	icon_state = "retrosec"
	uses_overlays = FALSE

/obj/item/card/id/away/snowdin/botany
	name = "Arctic Station Botanist's ID card"
	desc = "A faded Arctic Station ID card. You can make out the rank \"Botanist\"."
	assignment = "Arctic Station Botanist"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_BOTANY, ACCESS_AWAY_MAINT)
	icon_state = "retrosrv"
	uses_overlays = FALSE

/obj/item/card/id/away/snowdin/explore
	name = "Arctic Station Explorer's ID card"
	desc = "A faded Arctic Station ID card. You can make out the rank \"Explorer\"."
	assignment = "Arctic Station Explorer"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_AWAY_SEC, ACCESS_AWAY_MAINT)
	icon_state = "retrosup"
	uses_overlays = FALSE

/obj/item/card/id/debug
	name = "\improper Debug ID"
	desc = "A debug ID card. Has ALL the all access, you really shouldn't have this."
	icon_state = "ert_janitor"
	assignment = "Jannie"
	uses_assignment = FALSE
	uses_overlays = FALSE

/obj/item/card/id/debug/Initialize()
	access = get_all_accesses()+get_all_centcom_access()+get_all_syndicate_access()
	. = ..()