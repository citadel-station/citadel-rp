/*
Plastic packaging for individual snackages
 */

/obj/item/storage/single_use/bag
	name = "snack"
	desc = "Report me to a coder."
	icon = 'icons/obj/food.dmi'
	icon_state = null
	// These need actual open sprites

/obj/item/storage/single_use/bag/belochka
	name = "Space Belochka"
	desc = "A bag of discontinued Waffle Co. chocolate-covered hazelnut pralines. It has a drawing of a spacefaring squirrel in a bubble helmet on it."
	icon_state = "belochka_bag"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 10
	max_single_weight_class = WEIGHT_CLASS_SMALL
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/belochka = 10
	)

/obj/item/storage/single_use/bag/candycorn
	name = "Centauri Candy Corn"
	desc = "A bag of stock standard Candy Corn, produced by food giant Centauri Provisions. One of the most ubiquitous staples of Halloween, whether in the coreworlds or the frontier."
	icon_state = "candycorn_bag"
	max_combined_volume = WEIGHT_VOLUME_TINY * 16
	max_single_weight_class = WEIGHT_CLASS_SMALL
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/candycorn = 16
	)

/obj/item/storage/single_use/bag/halloweengummy
	name = "Queenstown Halloween Gummies"
	desc = "A bag of assorted halloween-themed fruit flavour gummies, produced by Eridanian CenPro subsidiary Queenstown Sweets Inc."
	icon_state = "halloweengummy_bag"
	max_combined_volume = WEIGHT_VOLUME_TINY * 15
	max_single_weight_class = WEIGHT_CLASS_SMALL
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/halloweengummy/ghost,
		/obj/item/reagent_containers/food/snacks/halloweengummy/bat,
		/obj/item/reagent_containers/food/snacks/halloweengummy/jackolantern,
		/obj/item/reagent_containers/food/snacks/halloweengummy/ghost,
		/obj/item/reagent_containers/food/snacks/halloweengummy/bat,
		/obj/item/reagent_containers/food/snacks/halloweengummy/jackolantern,
		/obj/item/reagent_containers/food/snacks/halloweengummy/ghost,
		/obj/item/reagent_containers/food/snacks/halloweengummy/bat,
		/obj/item/reagent_containers/food/snacks/halloweengummy/jackolantern,
		/obj/item/reagent_containers/food/snacks/halloweengummy/ghost,
		/obj/item/reagent_containers/food/snacks/halloweengummy/bat,
		/obj/item/reagent_containers/food/snacks/halloweengummy/jackolantern,
		/obj/item/reagent_containers/food/snacks/halloweengummy/ghost,
		/obj/item/reagent_containers/food/snacks/halloweengummy/bat,
		/obj/item/reagent_containers/food/snacks/halloweengummy/jackolantern
	)

/obj/item/storage/single_use/bag/greenchew
	name = "GRN-CHU"
	desc = "A sleeve of green apple flavored chewy candy, produced by Neo-Osaka food manufacturer CHU. From the advertising, you know their mascot is a monochrome anime girl blowing a kiss."
	icon_state = "green_packet"
	max_combined_volume = WEIGHT_VOLUME_TINY * 12
	max_single_weight_class = WEIGHT_CLASS_TINY
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/greenchew = 12
	)

/obj/item/storage/single_use/bag/matchamilkcandy
	name = "Centauri Matcha Milk Candy"
	desc = "A bag of matcha and milk flavored hard candy. Despite the oriental packaging, this is actually produced by food giant Centauri Provisions."
	icon_state = "matchamilkcandy_bag"
	max_combined_volume = WEIGHT_VOLUME_TINY * 16
	max_single_weight_class = WEIGHT_CLASS_SMALL
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/centauri/matchamilkcandy = 16
	)

/obj/item/storage/single_use/bag/californium
	name = "Californium Worms"
	desc = "A bag of sour gummy worms which has been obviously designed to look dangerous without risking legal trouble with actual hazard identification imagery. Does not contain real Californium-252, although the ads say it disappears just as quickly." //We are aware the half-life of Cf-252 is 2.6 yrs please do not fix this.
	icon_state = "sourgummyworm_bag"
	max_combined_volume = WEIGHT_VOLUME_TINY * 15
	max_single_weight_class = WEIGHT_CLASS_SMALL
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/sourgummyworm/redblue,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/greenorange,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/purpleyellow,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/redblue,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/greenorange,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/purpleyellow,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/redblue,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/greenorange,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/purpleyellow,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/redblue,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/greenorange,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/purpleyellow,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/redblue,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/greenorange,
		/obj/item/reagent_containers/food/snacks/sourgummyworm/purpleyellow
	)

/obj/item/storage/single_use/bag/raymonds
	name = "Raymond's Peanut Butter Cups"
	desc = "A sleeve containing a pair of chocolate peanut butter cups. It has an allergy disclaimer on the back. MAY CONTAIN PEANUTS."
	icon_state = "pnbtrcup_packet"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 2
	max_single_weight_class = WEIGHT_CLASS_SMALL
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/pnbtrcup = 2
	)

/obj/item/storage/single_use/bag/cookie
	name = "Centauri Chocolate Chip Cookies"
	desc = "A sleeve containing two pairs of chocolate chip cookies, whose recipe has been optimized over centuries and now finds itself mass-produced by Centauri Provisions."
	icon_state = "cookie_packet"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 4
	max_single_weight_class = WEIGHT_CLASS_SMALL
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/centauri/cookie = 4
	)

/obj/item/storage/single_use/bag/chococookie
	name = "Centauri Double Chocolate Cookies"
	desc = "A sleeve containing two pairs of double chocolate cookies. Because who can say no to extra chocolate?"
	icon_state = "chococookie_packet"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 4
	max_single_weight_class = WEIGHT_CLASS_SMALL
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/centauri/cookie/chocolate = 4
	)

/obj/item/storage/single_use/bag/toroid
	name = "Mint Toroid"
	desc = "A roll of spearmint-flavored mints, best known for their bizarre ads where anything with one hole can be turned into the candy with mathmagics."
	icon_state = "toroid_blue"
	max_combined_volume = WEIGHT_VOLUME_TINY * 14
	max_single_weight_class = WEIGHT_CLASS_TINY
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/toroid/mint = 14
	)

/obj/item/storage/single_use/bag/toroid/musk
	name = "Musk Toroid"
	desc = "A roll of musk-flavored mints, engineered to capture what had once been a regional terran flavor. By all accounts, it seems to have worked."
	icon_state = "toroid_pink"
	starts_with = list(
	/obj/item/reagent_containers/food/snacks/toroid/musk = 14
	)

/obj/item/storage/single_use/bag/toroid/fruit
	name = "Fruit Toroid"
	desc = "A roll of assorted fruit-flavored mints, always packaged in the same, familiar sequence."
	icon_state = "toroid_fruit"
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/toroid/cherry,
		/obj/item/reagent_containers/food/snacks/toroid/pineapple,
		/obj/item/reagent_containers/food/snacks/toroid/orange,
		/obj/item/reagent_containers/food/snacks/toroid/lemon,
		/obj/item/reagent_containers/food/snacks/toroid/raspberry,
		/obj/item/reagent_containers/food/snacks/toroid/lime,
		/obj/item/reagent_containers/food/snacks/toroid/grape,
		/obj/item/reagent_containers/food/snacks/toroid/cherry,
		/obj/item/reagent_containers/food/snacks/toroid/pineapple,
		/obj/item/reagent_containers/food/snacks/toroid/orange,
		/obj/item/reagent_containers/food/snacks/toroid/lemon,
		/obj/item/reagent_containers/food/snacks/toroid/raspberry,
		/obj/item/reagent_containers/food/snacks/toroid/lime,
		/obj/item/reagent_containers/food/snacks/toroid/grape
	)
