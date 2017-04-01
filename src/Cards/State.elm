module Cards.State exposing (..)

import Random exposing (Generator)
-- import Random.List exposing (shuffle)

whiteCards = [
 "Flying sex snakes.",
 "Michelle Obama's arms.",
 "German dungeon porn.",
 "White people.",
 "Getting so angry that you pop a boner.",
 "Tasteful sideboob.",
 "Praying the gay away.",
 "Two midgets shitting into a bucket.",
 "MechaHitler.",
 "Being a motherfucking sorcerer.",
 "A disappointing birthday party.",
 "Puppies!",
 "A windmill full of corpses.",
 "Guys who don't call.",
 "Racially-biased SAT questions.",
 "Dying.",
 "Stephen Hawking talking dirty.",
 "Being on fire.",
 "A lifetime of sadness.",
 "An erection that last longer than four hours."]

blackCards = [
 ""]

drawWhiteCard model = ({ model | whiteCards = List.tail model.whiteCards }, List.head model.whiteCards)

drawBlackCard model = ({ model | blackCards = List.tail model.blackCards }, List.head model.blackCards)
