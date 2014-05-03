



multiHolder(sides = 6, diameter = 60, height =15, mirrorThickness = 4, mirrorAngleSpreadDeg = 10, mirrorMarginFactor=0.3, wallThickness=2);


module multiHolder(sides = 5, diameter = 80, height = 20, mirrorAngleSpreadDeg = 15, mirrorThickness = 3, centerHoleDiam = 8, defaultSpokeHoleDiam = 4, mirrorOpeningsUp = false, mirrorMarginFactor=1, wallThickness = 3) {

    radius = diameter/2;

    sideLen = 2 * radius * sin ( 180 / sides );

    angleStep = 360 / sides;

    // The apothem, or distance from center to middle of a side
    inradius = radius * cos(180 / sides);

    spokeW = sideLen * 0.3;
    spokeH = height * 0.3;
    spokeHoleDiam = min(defaultSpokeHoleDiam, spokeW - wallThickness*2);
    spokeHoleDist = inradius * 0.5;

    mirrorSideMargin = mirrorMarginFactor * mirrorThickness * 1.5 + wallThickness;
    mirrorW = sideLen - mirrorSideMargin*2;
    mirrorH = height + wallThickness*2;
    mirrorAngleStep = mirrorAngleSpreadDeg / sides;
    mirrorZOffset = wallThickness*2 * (mirrorOpeningsUp ? 1 : -1); 
    
    echo("Mirror width: ", mirrorW-wallThickness/2, "mm");
    echo("Mirror height: ", mirrorH-wallThickness, "mm");
    
    windowW = mirrorW - wallThickness * 1.5;
    windowH = height - wallThickness*3;
    
    difference() {    
        // Add sides
        for (i = [0 : sides-1]) {
            rotate([0, 0, i * angleStep]) {
                // Holder
                box(mirrorThickness + wallThickness*2, sideLen, height,
                    inradius-wallThickness*2-mirrorThickness, 0, 0,
                    yCenter=true);

                // Spoke
                difference() {
                    box(inradius, spokeW, spokeH, yCenter=true);

                    translate([spokeHoleDist, 0, -1])
                        cylinder(r=spokeHoleDiam/2, h = spokeH+2, $fn=30);
                }            
            }
        }
        
        // Cut out mirrors
        for (i = [0 : sides-1]) {
            rotate([0, 0, i * angleStep]) {
                translate([inradius-wallThickness-mirrorThickness/2, 0, height/2-wallThickness]) {
                    rotate([0, i * mirrorAngleStep - mirrorAngleSpreadDeg/2, 0]) {
                        // Cutout for mirror
                        box(mirrorThickness, mirrorW, mirrorH, 
                            -mirrorThickness/2, 0, mirrorZOffset-height/2,
                            yCenter = true, zCenter=false);
                        
                    }
                    // Cutout for window
                    box(mirrorThickness+wallThickness*2, windowW, windowH, 
                        0, 0, wallThickness,
                        yCenter = true, zCenter=true);
                }
            }
        }

        // Cutout center hole
        if (centerHoleDiam > 0) {
            cylinder(r=centerHoleDiam/2, h = height*2, center=true, $fn=30);
        }        
    }

}


module box(xSize, ySize, zSize, x=0, y=0, z=0, xCenter=false, yCenter=false, zCenter= false) {
    translate([x - (xCenter ? xSize/2 : 0), 
               y - (yCenter ? ySize/2 : 0), 
               z - (zCenter ? zSize/2 : 0)]) {
        cube([xSize, ySize, zSize]);
    }

}


