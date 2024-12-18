extends Node

const YELLOW := Color.YELLOW
const ORANGE := Color.ORANGE
const RED := Color.RED
const MAGENTA := Color.MAGENTA
const VIOLET := Color.VIOLET
const BLUE := Color.BLUE
const CYAN := Color.CYAN
const GREEN := Color.GREEN

const colors_easy := [RED,BLUE,GREEN]
const colors_medium := [YELLOW,ORANGE,MAGENTA,BLUE,GREEN]
const colors_hard := [YELLOW,ORANGE,RED,MAGENTA,VIOLET,BLUE,CYAN,GREEN]

enum {EASY, MEDIUM, HARD}
const difficulty_colors := {
	EASY: colors_easy,
	MEDIUM: colors_medium,
	HARD: colors_hard
}
