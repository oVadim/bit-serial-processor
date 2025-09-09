# gtkwave::loadFile "dump.vcd"

set all_signals [list]

lappend all_signals tb.clk
lappend all_signals tb.sound

lappend all_signals tb.bclk
lappend all_signals tb.lrclk
lappend all_signals tb.sdata

lappend all_signals tb.i_mixer.in
lappend all_signals tb.i_mixer.out
lappend all_signals tb.i_mixer.i_sum_2.out_p

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::highlightSignalsFromList "tb.sound\[15:0\]"
gtkwave::highlightSignalsFromList "tb.i_mixer.i_sum_2.out_p\[31:0\]"
gtkwave::/Edit/Data_Format/Analog/Step
gtkwave::/Edit/Data_Format/Signed_Decimal

gtkwave::/Edit/UnHighlight_All

gtkwave::/Time/Zoom/Zoom_Full
