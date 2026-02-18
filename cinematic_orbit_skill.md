---
name: Liquid Galaxy KML Orbit Skill
description: Mathematical logic for generating smooth orbital paths (gx:Tour) around a coordinate.
---

# KML Orbit Logic

## Concept
A `gx:Tour` with `gx:FlyTo` elements creates a cinematic orbit. To orbit a point, we generate a series of `gx:FlyTo` waypoints that circle the target coordinate.

## Algorithm
1.  **Inputs**: Center Lat/Lon, Altitude, Range, Tilt, Duration.
2.  **Steps**: Divide the circle (360 degrees) into `N` steps (e.g., 5 or 36).
3.  **Heading**: Increment heading from 0 to 360.
4.  **XML Structure**:

```xml
<gx:Tour>
  <name>Orbit</name>
  <gx:Playlist>
    <!-- Repeat for Heading 0, 10, 20... 360 -->
    <gx:FlyTo>
      <gx:duration>1.0</gx:duration>
      <gx:flyToMode>smooth</gx:flyToMode>
      <LookAt>
        <longitude>TARGET_LON</longitude>
        <latitude>TARGET_LAT</latitude>
        <altitude>TARGET_ALT</altitude>
        <heading>CURRENT_HEADING</heading>
        <tilt>60</tilt>
        <range>1000</range>
        <gx:altitudeMode>relativeToGround</gx:altitudeMode>
      </LookAt>
    </gx:FlyTo>
  </gx:Playlist>
</gx:Tour>
```

## Tips
-   **Smoothness**: Smaller heading increments + shorter durations = smoother orbit.
-   **Range**: Keep range constant for a perfect circle.
-   **Tilt**: A tilt of 45-65 degrees offers the best 3D perspective.
