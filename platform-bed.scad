use <.\scad-metric-thread-library\ISOThreadUM2.scad>; //This library will let us have thread holes.

//Those parameters define the platform's bed.
length = 110;
width = 80;
height = 10;
widthSupportBeams = 10;
thicknessOuterSupportWalls = 15;
metricThreadSize = 8;

//This create the platform bed, with all the elements.
union() {
    addPlatformOuterSupportWalls(length, width, height, thicknessOuterSupportWalls);
    addXShapedSupportBeamsToPlatform(length, width, height, thicknessOuterSupportWalls, widthSupportBeams);
    addThreadHolesBeneathPlatform(length, width, height, thicknessOuterSupportWalls, metricThreadSize);
}

//To make the platform outer support walls, we basically make a cube that fits the dimension required and subtract another cube from it minus the thickness of the outer support walls.
module addPlatformOuterSupportWalls(length, width, height, thicknessOuterSupportWalls) {
    difference() {
        cube(size = [length, width, height]);
        translate([thicknessOuterSupportWalls, thicknessOuterSupportWalls, 0]) cube(size = [length - thicknessOuterSupportWalls * 2, width - thicknessOuterSupportWalls * 2, height]);
    }
}

//This will add X-shaped support beams to the platform, while taking into account the thickness of the outer support walls.
module addXShapedSupportBeamsToPlatform(length, width, height, thicknessOuterSupportWalls, widthSupportBeams) {
   //We calculate the length of a beam from the center to a corner, when meeting the outer walls.
   beamLengthCenterToInteriorCorner = sqrt(pow((length - thicknessOuterSupportWalls * 2) / 2, 2) + pow((width - thicknessOuterSupportWalls * 2) / 2, 2));
   echo("Beam half-length is : ", beamLengthCenterToInteriorCorner);

   //Now, we calculate the angle between two beams.
   centerAngle = acos(((width - thicknessOuterSupportWalls * 2) / 2) / beamLengthCenterToInteriorCorner);
   echo("The angle bisector of the width and used by the support beams is : ", centerAngle);

   //Since rotation is not done from the center of the cube, we need to calculate the x/y offset for the second beam (where the rotation is negative).
   offsetX = sin(centerAngle / 2) * widthSupportBeams;
   offsetY = cos(centerAngle / 2) * widthSupportBeams;

   //Building the X-shaped beams.
   translate([thicknessOuterSupportWalls / 2, thicknessOuterSupportWalls / 2, 0]) {
      rotate([0,0, centerAngle / 2]) cube(size = [length, widthSupportBeams, height]); //The beam is starting closest to origin.
   }
   translate([thicknessOuterSupportWalls / 2 - offsetX, width - thicknessOuterSupportWalls / 2 - offsetY, 0]) {
      rotate([0,0, -centerAngle / 2]) cube(size = [length, widthSupportBeams, height]); //The opposite beam.
   }
}

//Add 8 block with threaded holes underneath the platform. This allow the platform to be attached to other platforms and have other various addons.
module addThreadHolesBeneathPlatform(length, width, height, thicknessOuterSupportWalls, metricThreadSize) {
   //block_with_thread_in(8,10,16,16);   // Make an M8 X 10 thread in a block of 16 x 16
   translate([metricThreadSize, thicknessOuterSupportWalls, -metricThreadSize]) { //Lower the block so its top is against the bottom of the platform and align it with origin.
      rotate([90, 0, 0]) { //We rotate four of the
         //translate([length / 4, 0, 0]) {
            //translate([0, -width / 2, 0])
            block_with_thread_in(metricThreadSize, thicknessOuterSupportWalls, metricThreadSize * 2, metricThreadSize * 2);
         //}
      }
   }



}
