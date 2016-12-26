//Those parameters define the platform's bed.
length = 110;
width = 80;
height = 10;
widthSupportBeams = 10;
thicknessOuterSupportWalls = 15;

union() {
    addPlatformOuterSupportWalls(length, width, height, thicknessOuterSupportWalls);
    addXShapedSupportBeamsToPlatform(length, width, height, thicknessOuterSupportWalls);
}

//To make the platform outer support walls, we basically make a cube that fits the dimension required and subtract another cube from it minus the thickness of the outer support walls.
module addPlatformOuterSupportWalls(length, width, height, thicknessOuterSupportWalls) {
    difference() {
        cube(size = [length, width, height], center = true);
        cube(size = [length - thicknessOuterSupportWalls * 2, width - thicknessOuterSupportWalls * 2, height], center = true);
    }
}

//This will add X-shaped support beams to the platform, while taking into account the thickness of the outer support walls.
module addXShapedSupportBeamsToPlatform(length, width, height, thicknessOuterSupportWalls) {
   //We need to calculate the angle needed for the support beams in the middle.
   /*//We calculate the length of a beam from the center to a corner, when meeting the outer walls.*/
   beamLengthCenterToInteriorCorner = sqrt(pow((length - thicknessOuterSupportWalls * 2) / 2, 2) + pow((width - thicknessOuterSupportWalls * 2) / 2, 2));
   echo("Beam half-length is : ", beamLengthCenterToInteriorCorner);

   //Now, we calculate the angle between two beams.
   centerAngle = acos(((width - thicknessOuterSupportWalls * 2) / 2) / beamLengthCenterToInteriorCorner);
   echo("The angle bisector of the width and used by the support beams is : ", centerAngle);

   rotate([0,0, centerAngle / 2]) cube(size = [length, widthSupportBeams, height], center = true);
   rotate([0,0, -centerAngle / 2]) cube(size = [length, widthSupportBeams, height], center = true);
}
