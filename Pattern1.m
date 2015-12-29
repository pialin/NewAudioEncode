SizeScreenX = 1600;
SizeScreenY = 900;
PenWidth = 20;
white = 1;
black = 0;

SizeCanvas = round(SizeScreenY/5*3);
OriginX = round((SizeScreenX - SizeCanvas)/2);
OriginY = SizeCanvas + round((SizeScreenY - SizeCanvas)/2);
PatternVertex =...
    [0.1,0.9;
     0.1,0.1;
     0.9,0.1;
     0.9,0.9];
PatternVertex(:,1) = OriginX + PatternVertex(:,1)*SizeCanvas;
PatternVertex(:,2) = OriginY - PatternVertex(:,2)*SizeCanvas;


NumPolygon = 2;
NumVertex  = [4,4];

PolygonVertex =  zeros(max(NumVertex),2,NumPolygon);
ColorPolygon = zeros(1,NumPolygon);

iPolygon = 1;
iVertex = 1;
%多边形1
ColorPolygon(iPolygon) = white;
PolygonVertex(iVertex,1,iPolygon) = round(PatternVertex(iVertex,1) - PenWidth/2);
PolygonVertex(iVertex,2,iPolygon) = round(PatternVertex(iVertex,2) - PenWidth/2);

iVertex = iVertex + 1;

PolygonVertex(iVertex,1,iPolygon) = round(PatternVertex(iVertex,1) - PenWidth/2);
PolygonVertex(iVertex,2,iPolygon) = round(PatternVertex(iVertex,2) + PenWidth/2);

iVertex = iVertex + 1;

PolygonVertex(iVertex,1,iPolygon) = round(PatternVertex(iVertex,1) + PenWidth/2);
PolygonVertex(iVertex,2,iPolygon) = round(PatternVertex(iVertex,2) + PenWidth/2);

iVertex = iVertex + 1;

PolygonVertex(iVertex,1,iPolygon) = round(PatternVertex(iVertex,1) + PenWidth/2);
PolygonVertex(iVertex,2,iPolygon) = round(PatternVertex(iVertex,2) - PenWidth/2);

iPolygon = iPolygon + 1;

iVertex = 1;
%多边形1
ColorPolygon(iPolygon) = black;
PolygonVertex(iVertex,1,iPolygon) = round(PatternVertex(iVertex,1) + PenWidth/2);
PolygonVertex(iVertex,2,iPolygon) = round(PatternVertex(iVertex,2) - PenWidth/2);

iVertex = iVertex + 1;

PolygonVertex(iVertex,1,iPolygon) = round(PatternVertex(iVertex,1) + PenWidth/2);
PolygonVertex(iVertex,2,iPolygon) = round(PatternVertex(iVertex,2) - PenWidth/2);

iVertex = iVertex + 1;

PolygonVertex(iVertex,1,iPolygon) = round(PatternVertex(iVertex,1) - PenWidth/2);
PolygonVertex(iVertex,2,iPolygon) = round(PatternVertex(iVertex,2) - PenWidth/2);

iVertex = iVertex + 1;

PolygonVertex(iVertex,1,iPolygon) = round(PatternVertex(iVertex,1) - PenWidth/2);
PolygonVertex(iVertex,2,iPolygon) = round(PatternVertex(iVertex,2) - PenWidth/2);



CircleCenterX = round(SizeScreenX/2);
CircleCenterY = PolygonVertex(1,2,1);

Radius = CircleCenterY;

