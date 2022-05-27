/// @description draw text box

NineSliceBoxStretched(sTextBoxBg, x1, y1, x2, y2, background);
draw_set_font(fText);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_black);

var print = string_copy(messageText, 1, textProgress);
draw_text((x1+x2) / 2,  y1 + 8, print);
draw_set_color(c_white);
draw_text((x1+x2) / 2,  y1 + 7, print)
