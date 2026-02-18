---
name: Liquid Galaxy KML Mastery Skill
description: Expert-level KML structures for high-performance 3D visualization (Extrusions, Polygons).
---

# KML Mastery: 3D Visualization

## Core Concept
Liquid Galaxy is a 3D medium. Flat markers are insufficient. Use "Extruded" geometry to show scale.

## The <extrude> Tag
To create a 3D pillar from a point:
1.  Use a `Polygon` with a small radius (e.g., 0.1 degrees).
2.  Set `<extrude>1</extrude>`.
3.  Set `<altitudeMode>relativeToGround</altitudeMode>`.
4.  Set altitude to a scaled value of the data (e.g., `Magnitude * 20000`).

## Example: 3D Earthquake Pillar
```xml
<Placemark>
  <name>M8.0 Quake</name>
  <Style>
    <PolyStyle>
      <color>ff0000ff</color> <!-- Red -->
      <outline>0</outline>
    </PolyStyle>
  </Style>
  <Polygon>
    <extrude>1</extrude>
    <altitudeMode>relativeToGround</altitudeMode>
    <outerBoundaryIs>
      <LinearRing>
        <!-- Octagon Coordinates Here -->
        <coordinates>
          -122.0,37.0,160000
          -122.1,37.1,160000
          ...
        </coordinates>
      </LinearRing>
    </outerBoundaryIs>
  </Polygon>
</Placemark>
```

## Performance Tip
-   Do not use `<extrude>` on complex LineStrings (Scanning Lines) unless necessary; it fills the area to the ground, which can obscure maps.
-   For "Cracked Earth" effects, use `clampToGround` LineStrings with `<width>5</width>`.
