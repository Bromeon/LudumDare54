extends Node

var MINERAL_NAMES = [
	"Lanthanum",
	"Yttrium",
	"Cerium",
	"Praseodymium",
	"Europium",
	"Terbium",
	"Samarium",
	"Gadolinium"
]

var MINERAL_TYPE_COLORS = {
	"Lanthanum": Color(0.9, 0.5, 0.5),
	"Yttrium": Color(0.5, 0.9, 0.5),
	"Cerium": Color(0.5, 0.5, 0.9),
	"Praseodymium": Color(0.9, 0.9, 0.5),
	"Europium": Color(0.9, 0.5, 0.9),
	"Terbium": Color(0.5, 0.9, 0.9),
	"Samarium": Color(0.9, 0.7, 0.5),
	"Gadolinium": Color(0.7, 0.7, 0.7)
}

var QUEST_REQUIREMENTS = {
	"Samarium": 50,
	"Lanthanum": 10,
	"Yttrium": 10,
	"Cerium": 30,
	"Praseodymium": 10,
	"Europium": 30,
	"Terbium": 10,
	"Gadolinium": 30,
}

var MINERAL_DESCRIPTIONS = {
	"Samarium": 
"Among the rarest minerals in the galaxy, the most abundant. These samples are remarkably pure.

[right]- Ea Nasir's descendant  [/right]",
	"Lanthanum": "TODO",
	"Yttrium": "TODO",
	"Cerium": "TODO",
	"Praseodymium": 
"The cooler half of didymium, way better than neodymium by far. Magnets? Pah. Motors, that's where it's at.

[right]- A Neodymium hater  [/right]",
	"Europium": 
"At first I thought my assistant contaminated my samples, but it was a new element in its own right! 

[right]- Sm (and Eu!) discoverer [/right]",
	"Terbium": 
"One of the rarest minerals in the galaxy, it is not only rare, but extremely expensive!

[right]- A Terbium seller  [/right]",
	"Gadolinium": "TODO",
}
