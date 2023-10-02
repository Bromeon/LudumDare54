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
	"Samarium": 30,
	"Lanthanum": 5,
	"Yttrium": 5,
	"Cerium": 15,
	"Praseodymium": 5,
	"Europium": 15,
	"Terbium": 5,
	"Gadolinium": 15,
}

var MINERAL_DESCRIPTIONS = {
	"Samarium": 
"Among the rarest minerals in the galaxy, the most abundant. These samples are remarkably pure.

[right]- Ea Nasir's descendant  [/right]",
	"Lanthanum":   
"You could cut this metal with a butter knife. But better not.

[right]- A concerned professor  [/right]",
	"Yttrium":  
"One of the rarest minerals in the galaxy, it is not only rare, but extremely expensive!

[right]- A Rare earth broker  [/right]",
	"Cerium":   
"Good old CRT monitors used lead because Cerium isn't that effective at shielding radiation.

[right]- 60's nostalgic  [/right]",
	"Praseodymium": 
"The cooler half of didymium, way better than neodymium by far. Magnets? Pah. Motors, that's where it's at.

[right]- A Neodymium hater  [/right]",
	"Europium": 
"At first I thought my assistant contaminated my Sm samples, but it was a new element in its own right! 

[right]- Sm (and Eu!) discoverer [/right]",
	"Terbium": 
"Not Ytterbium, Terbium. No, without the Y: T-E-R... What do you mean it's not on stock?

[right]- A Terbium customer  [/right]",
	"Gadolinium":  
"Electron configuration: [Xe] 4f7 5d1 6s2

[right]- Wikipedia  [/right]",
}
