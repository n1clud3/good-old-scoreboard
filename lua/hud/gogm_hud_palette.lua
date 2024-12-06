local accent_color = Color(95, 153, 180)

local HUDPALhsv = {}
HUDPALhsv.Dark3 = {}
HUDPALhsv.Dark3.h, HUDPALhsv.Dark3.s, HUDPALhsv.Dark3.v = ColorToHSV(accent_color) -- hsv(200, 40%, 30%)

HUDPALhsv.Dark2 = {}
HUDPALhsv.Dark2.h = HUDPALhsv.Dark3.h
HUDPALhsv.Dark2.s = math.Clamp(HUDPALhsv.Dark3.s * 1.2, 0, 1)
HUDPALhsv.Dark2.v = math.Clamp(HUDPALhsv.Dark3.v * 0.6, 0, 1)

HUDPALhsv.Dark1 = {}
HUDPALhsv.Dark1.h = HUDPALhsv.Dark3.h
HUDPALhsv.Dark1.s = math.Clamp(HUDPALhsv.Dark2.s * 1.2, 0, 1)
HUDPALhsv.Dark1.v = math.Clamp(HUDPALhsv.Dark2.v * 0.7, 0, 1)

HUDPALhsv.Light1 = {} -- hsl(200, 32.93%, 67.84%)
HUDPALhsv.Light1.h = HUDPALhsv.Dark3.h
HUDPALhsv.Light1.s = math.Clamp(HUDPALhsv.Dark3.s * 0.8, 0, 1)
HUDPALhsv.Light1.v = math.Clamp(HUDPALhsv.Dark3.v * 1.1, 0, 1)

HUDPALhsv.Light2 = {} -- hsl(200, 32.93%, 67.84%)
HUDPALhsv.Light2.h = HUDPALhsv.Dark3.h
HUDPALhsv.Light2.s = math.Clamp(HUDPALhsv.Dark3.s * 0.8, 0, 1)
HUDPALhsv.Light2.v = math.Clamp(HUDPALhsv.Dark3.v * 1.3, 0, 1)

HUDPALhsv.Light3 = {} -- hsl(200, 30%, 50%)
HUDPALhsv.Light3.h = HUDPALhsv.Dark3.h
HUDPALhsv.Light3.s = math.Clamp(HUDPALhsv.Dark3.s * 0.8, 0, 1)
HUDPALhsv.Light3.v = math.Clamp(HUDPALhsv.Dark3.v * 1.4, 0, 1)

HUDPAL = {}
HUDPAL.Black = Color(29, 29, 29)
HUDPAL.Dark1 = HSVToColor(HUDPALhsv.Dark1.h, HUDPALhsv.Dark1.s, HUDPALhsv.Dark1.v)
HUDPAL.Dark2 = HSVToColor(HUDPALhsv.Dark2.h, HUDPALhsv.Dark2.s, HUDPALhsv.Dark2.v)
HUDPAL.Dark3 = HSVToColor(HUDPALhsv.Dark3.h, HUDPALhsv.Dark3.s, HUDPALhsv.Dark3.v)
HUDPAL.Light1 = HSVToColor(HUDPALhsv.Light1.h, HUDPALhsv.Light1.s, HUDPALhsv.Light1.v)
HUDPAL.Light2 = HSVToColor(HUDPALhsv.Light2.h, HUDPALhsv.Light2.s, HUDPALhsv.Light2.v)
HUDPAL.Light3 = HSVToColor(HUDPALhsv.Light3.h, HUDPALhsv.Light3.s, HUDPALhsv.Light3.v)
HUDPAL.White = Color(249, 249, 249)