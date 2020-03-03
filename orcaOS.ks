FUNCTION MANEUVER_TIME {
    
    // Compute the total burn time for a maneuver of a specified dV

    PARAMETER dV.

    LIST ENGINES IN en.

    LOCAL f IS en[0]:MAXTHRUST * 1000.  // Engine Thrust (kg * m/s²)
    LOCAL m IS SHIP:MASS * 1000.        // Starting mass (kg)
    LOCAL e IS CONSTANT():E.            // Base of natural log
    LOCAL p IS en[0]:ISP.               // Engine ISP (s)
    LOCAL g IS 9.80665.                 // Gravitational acceleration constant (m/s²)

    RETURN g * m * p * (1 - e^(-dV / (g * p))) / f.
}

// TWR = 600 kN / 280 kN = 2.14
// TWR is dimensionless
// 1 ton = 9.96402 kN
// 2 to 2.5 TWR is ideal

// You can save fuel by being close to your terminal velocity during
// ascent. Lower velocity wastes delta-V on gravity, higher is
// wasted on air resistance.

// TODO: Match orbit

// The first step is to get into circular orbit.

// Click on your target body to set it as the target.
// This will add two new icons to the map, the ascending
// node and descending node of your orbit relative to the
// target. Before you can encounter the target, you need
// to adjust your orbit to the same plane as the target.
// Burn normal at DN or anti-normal at AN. When the angle
// of inclination is 0.0, you are on the same plane.

// The next step is to position the maneuver point on your orbit
// so that you encounter the target. To drag the maneuver point,
// you need to click and hold on the center circle. When your pointer
// is hovering over the circle it will light up, then click and drag.
// Drag the maneuver point around your orbit and watch the two white
// encounter arrows on the target orbit. As you move the maneuver point
// they will get closer together or move apart. Slowly drag the maneuver
// point all the way around the orbit until the arrows are on top of each
// other. If the arrows are very far apart, you probably will not be able
// to encounter the target during this orbit. If you cannot get the white
// arrows close to each other, cancel this maneuver and make one orbit and
// try again. The arrows will get closer together next time around.

// To influence the closest intercept point, burn retrograde to reduce
// relative velocity and burn target to reduce distance.