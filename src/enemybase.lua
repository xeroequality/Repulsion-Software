----------------------------------------------------------
-- enemybase.lua
-- Contains table of values that represent the enemy's base.
----------------------------------------------------------
local Material = require("materials")
W = display.contentWidth
H = display.contentHeight

EnemyBase = {}

EnemyBase.level1 = {
numObjects=22,
baseX=700,
baseY=291.05834960938,
totalCost=2900,
types={
"wood_box","wood_plank","wood_plank","wood_plank","wood_plank","wood_box","wood_box","wood_box","wood_box","wood_plank","wood_box","wood_box","wood_box","wood_plank","wood_box","wood_box","wood_box","wood_box","wood_plank","wood_plank","wood_plank","wood_plank"
},
x_vals={
111.80799865723,56.010650634766,56.262878417969,56.289886474609,56.195877075195,3.7095489501953,2.5970306396484,2.4010772705078,2.1709136962891,37.456390380859,112.52397155762,111.39143371582,110.40083312988,75.03239440918,0,112.53120422363,7.4681854248047,106.67512512207,55.875244140625,56.332153320313,38.277587890625,76.486038208008
},
y_vals={
0,-37.451644897461,-0.006317138671875,-74.896591186523,-112.34216308594,-0.00555419921875,-37.450012207031,-74.894577026367,-112.33990478516,-134.78517150879,-37.432952880859,-74.864685058594,-112.29808044434,-134.74757385254,-149.78770446777,-149.74310302734,-187.23030090332,-187.17177581787,-157.23876953125,-194.68506622314,-213.81237792969,-213.51936340332
},
rotations={
-0.016262600198388,90.032989501953,-89.99454498291,450.04306030273,270.05126953125,0.0038259259890765,0.012969587929547,0.022412329912186,0.031325995922089,-0.018423473462462,-0.056806642562151,-0.093751631677151,-0.12467232346535,0.12692286074162,0.039988577365875,-0.15127845108509,0.045896988362074,-0.1664267629385,270.21362304688,90.225883483887,-193.24227905273,12.56519985199
}
}

return EnemyBase