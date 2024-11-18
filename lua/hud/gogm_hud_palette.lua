local accent_color = Color(95, 153, 180)

local HUDPALhsl = {}
HUDPALhsl.Dark3 = {}
HUDPALhsl.Dark3.h, HUDPALhsl.Dark3.s, HUDPALhsl.Dark3.l = ColorToHSV(accent_color) -- hsl(200, 40%, 30%)

HUDPALhsl.Dark2 = {}
HUDPALhsl.Dark2.h = HUDPALhsl.Dark3.h
HUDPALhsl.Dark2.s = math.Clamp(HUDPALhsl.Dark3.s * 1.5, 0, 1)
HUDPALhsl.Dark2.l = math.Clamp(HUDPALhsl.Dark3.l * 0.6, 0, 1)

HUDPALhsl.Dark1 = {}
HUDPALhsl.Dark1.h = HUDPALhsl.Dark3.h
HUDPALhsl.Dark1.s = math.Clamp(HUDPALhsl.Dark2.s * 1.2, 0, 1)
HUDPALhsl.Dark1.l = math.Clamp(HUDPALhsl.Dark2.l * 0.7, 0, 1)

HUDPALhsl.Light3 = {} -- hsl(200, 30%, 50%)
HUDPALhsl.Light3.h = HUDPALhsl.Dark3.h
HUDPALhsl.Light3.s = math.Clamp(HUDPALhsl.Dark3.s * 0.8, 0, 1)
HUDPALhsl.Light3.l = math.Clamp(HUDPALhsl.Dark3.l * 1.3, 0, 1)

HUDPALhsl.Light2 = {} -- hsl(200, 32.93%, 67.84%)
HUDPALhsl.Light2.h = HUDPALhsl.Dark3.h
HUDPALhsl.Light2.s = math.Clamp(HUDPALhsl.Light3.s * 0.8, 0, 1)
HUDPALhsl.Light2.l = math.Clamp(HUDPALhsl.Light3.l * 1.2, 0, 1)

HUDPALhsl.Light1 = {} -- hsl(200, 32.93%, 67.84%)
HUDPALhsl.Light1.h = HUDPALhsl.Dark3.h
HUDPALhsl.Light1.s = math.Clamp(HUDPALhsl.Light2.s * 0.7, 0, 1)
HUDPALhsl.Light1.l = math.Clamp(HUDPALhsl.Light2.l * 1.5, 0, 1)

HUDPAL = {}
HUDPAL.Black = Color(29, 29, 29)
HUDPAL.Dark1 = HSVToColor(HUDPALhsl.Dark1.h, HUDPALhsl.Dark1.s, HUDPALhsl.Dark1.l)
HUDPAL.Dark2 = HSVToColor(HUDPALhsl.Dark2.h, HUDPALhsl.Dark2.s, HUDPALhsl.Dark2.l)
HUDPAL.Dark3 = HSVToColor(HUDPALhsl.Dark3.h, HUDPALhsl.Dark3.s, HUDPALhsl.Dark3.l)
HUDPAL.Light1 = HSVToColor(HUDPALhsl.Light1.h, HUDPALhsl.Light1.s, HUDPALhsl.Light1.l)
HUDPAL.Light2 = HSVToColor(HUDPALhsl.Light2.h, HUDPALhsl.Light2.s, HUDPALhsl.Light2.l)
HUDPAL.Light3 = HSVToColor(HUDPALhsl.Light3.h, HUDPALhsl.Light3.s, HUDPALhsl.Light3.l)
HUDPAL.White = Color(249, 249, 249)