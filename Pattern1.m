SizeScreenX = 1600;
SizeScreenY = 900;
PenWidth = 20;
white = 1;
black = 0;
FramePerSecond = 60;

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



NumPolygon = [1,2,3];
NumPolygonVertex = 4;
ColorPolygon = white;


SegLength = [0.8,0.8,0.8];
SumTime = 3;
SegTime = SegLength/sum(SegLength)*SumTime;

SegFrame = round(SegTime*FramePerSecond);

PolygonVertex =  {zeros(NumPolygonVertex,2,SegFrame(1)),zeros(4,4,SegFrame(2)),zeros(4,6,SegFrame(3))};


iSeg = 1;
%第一段

%初始4个顶点
PolygonVertexStart(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(1,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

PolygonVertexStart(2,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(2,2) = round(PatternVertex(iSeg,2) - PenWidth/2);


PolygonVertexStart(3,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(3,2) = round(PatternVertex(iSeg,2) + PenWidth/2);

PolygonVertexStart(4,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(4,2) = round(PatternVertex(iSeg,2) + PenWidth/2);
%结束时4个顶点
PolygonVertexEnd(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexEnd(1,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

PolygonVertexEnd(2,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexEnd(2,2) = round(PatternVertex(iSeg,2) - PenWidth/2);


PolygonVertexEnd(3,1) = round(PatternVertex(iSeg+1,1) + PenWidth/2);
PolygonVertexEnd(3,2) = round(PatternVertex(iSeg+1,2) + PenWidth/2);

PolygonVertexEnd(4,1) = round(PatternVertex(iSeg+1,1) - PenWidth/2);
PolygonVertexEnd(4,2) = round(PatternVertex(iSeg+1,2) + PenWidth/2);


if iSeg > 1
    PolyVertex{iSeg}(:,1:2*(iSeg-1),:) = repmat(PolyVertex{iSeg-1}(:,:,end),[1,1,SegFrame(iSeg)]);
end

PolyVertex{iSeg}(1,2*iSeg-1,:)=round(linspace(PolygonVertexStart(1,1),PolygonVertexEnd(1,1),SegFrame(iSeg)));
PolyVertex{iSeg}(1,2*iSeg  ,:)=round(linspace(PolygonVertexStart(1,2),PolygonVertexEnd(1,2),SegFrame(iSeg)));
PolyVertex{iSeg}(2,2*iSeg-1,:)=round(linspace(PolygonVertexStart(2,1),PolygonVertexEnd(2,1),SegFrame(iSeg)));
PolyVertex{iSeg}(2,2*iSeg  ,:)=round(linspace(PolygonVertexStart(2,2),PolygonVertexEnd(2,2),SegFrame(iSeg)));
PolyVertex{iSeg}(3,2*iSeg-1,:)=round(linspace(PolygonVertexStart(3,1),PolygonVertexEnd(3,1),SegFrame(iSeg)));
PolyVertex{iSeg}(3,2*iSeg  ,:)=round(linspace(PolygonVertexStart(3,2),PolygonVertexEnd(3,2),SegFrame(iSeg)));
PolyVertex{iSeg}(4,2*iSeg-1,:)=round(linspace(PolygonVertexStart(4,1),PolygonVertexEnd(4,1),SegFrame(iSeg)));
PolyVertex{iSeg}(4,2*iSeg  ,:)=round(linspace(PolygonVertexStart(4,2),PolygonVertexEnd(4,2),SegFrame(iSeg)));

%第二段

iSeg = iSeg + 1;


%初始4个顶点
PolygonVertexStart(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(1,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

PolygonVertexStart(2,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(2,2) = round(PatternVertex(iSeg,2) + PenWidth/2);


PolygonVertexStart(3,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(3,2) = round(PatternVertex(iSeg,2) + PenWidth/2);

PolygonVertexStart(4,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(4,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

%结束时4个顶点
PolygonVertexEnd(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexEnd(1,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

PolygonVertexEnd(2,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexEnd(2,2) = round(PatternVertex(iSeg,2) + PenWidth/2);


PolygonVertexEnd(3,1) = round(PatternVertex(iSeg+1,1) + PenWidth/2);
PolygonVertexEnd(3,2) = round(PatternVertex(iSeg+1,2) + PenWidth/2);

PolygonVertexEnd(4,1) = round(PatternVertex(iSeg+1,1) + PenWidth/2);
PolygonVertexEnd(4,2) = round(PatternVertex(iSeg+1,2) - PenWidth/2);

if iSeg > 1
    PolyVertex{iSeg}(:,1:2*(iSeg-1),:) = repmat(PolyVertex{iSeg-1}(:,:,end),[1,1,SegFrame(iSeg)]);
end

PolyVertex{iSeg}(1,2*iSeg-1,:)=round(linspace(PolygonVertexStart(1,1),PolygonVertexEnd(1,1),SegFrame(iSeg)));
PolyVertex{iSeg}(1,2*iSeg  ,:)=round(linspace(PolygonVertexStart(1,2),PolygonVertexEnd(1,2),SegFrame(iSeg)));
PolyVertex{iSeg}(2,2*iSeg-1,:)=round(linspace(PolygonVertexStart(2,1),PolygonVertexEnd(2,1),SegFrame(iSeg)));
PolyVertex{iSeg}(2,2*iSeg  ,:)=round(linspace(PolygonVertexStart(2,2),PolygonVertexEnd(2,2),SegFrame(iSeg)));
PolyVertex{iSeg}(3,2*iSeg-1,:)=round(linspace(PolygonVertexStart(3,1),PolygonVertexEnd(3,1),SegFrame(iSeg)));
PolyVertex{iSeg}(3,2*iSeg  ,:)=round(linspace(PolygonVertexStart(3,2),PolygonVertexEnd(3,2),SegFrame(iSeg)));
PolyVertex{iSeg}(4,2*iSeg-1,:)=round(linspace(PolygonVertexStart(4,1),PolygonVertexEnd(4,1),SegFrame(iSeg)));
PolyVertex{iSeg}(4,2*iSeg  ,:)=round(linspace(PolygonVertexStart(4,2),PolygonVertexEnd(4,2),SegFrame(iSeg)));


%第3段
iSeg = iSeg + 1;


%初始4个顶点
PolygonVertexStart(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(1,2) = round(PatternVertex(iSeg,2) + PenWidth/2);

PolygonVertexStart(2,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(2,2) = round(PatternVertex(iSeg,2) + PenWidth/2);


PolygonVertexStart(3,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexStart(3,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

PolygonVertexStart(4,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexStart(4,2) = round(PatternVertex(iSeg,2) - PenWidth/2);

%结束时4个顶点
PolygonVertexEnd(1,1) = round(PatternVertex(iSeg,1) - PenWidth/2);
PolygonVertexEnd(1,2) = round(PatternVertex(iSeg,2) + PenWidth/2);

PolygonVertexEnd(2,1) = round(PatternVertex(iSeg,1) + PenWidth/2);
PolygonVertexEnd(2,2) = round(PatternVertex(iSeg,2) + PenWidth/2);


PolygonVertexEnd(3,1) = round(PatternVertex(iSeg+1,1) + PenWidth/2);
PolygonVertexEnd(3,2) = round(PatternVertex(iSeg+1,2) - PenWidth/2);

PolygonVertexEnd(4,1) = round(PatternVertex(iSeg+1,1) - PenWidth/2);
PolygonVertexEnd(4,2) = round(PatternVertex(iSeg+1,2) - PenWidth/2);

if iSeg > 1
    PolyVertex{iSeg}(:,1:2*(iSeg-1),:) = repmat(PolyVertex{iSeg-1}(:,:,end),[1,1,SegFrame(iSeg)]);
end

PolyVertex{iSeg}(1,2*iSeg-1,:)=round(linspace(PolygonVertexStart(1,1),PolygonVertexEnd(1,1),SegFrame(iSeg)));
PolyVertex{iSeg}(1,2*iSeg  ,:)=round(linspace(PolygonVertexStart(1,2),PolygonVertexEnd(1,2),SegFrame(iSeg)));
PolyVertex{iSeg}(2,2*iSeg-1,:)=round(linspace(PolygonVertexStart(2,1),PolygonVertexEnd(2,1),SegFrame(iSeg)));
PolyVertex{iSeg}(2,2*iSeg  ,:)=round(linspace(PolygonVertexStart(2,2),PolygonVertexEnd(2,2),SegFrame(iSeg)));
PolyVertex{iSeg}(3,2*iSeg-1,:)=round(linspace(PolygonVertexStart(3,1),PolygonVertexEnd(3,1),SegFrame(iSeg)));
PolyVertex{iSeg}(3,2*iSeg  ,:)=round(linspace(PolygonVertexStart(3,2),PolygonVertexEnd(3,2),SegFrame(iSeg)));
PolyVertex{iSeg}(4,2*iSeg-1,:)=round(linspace(PolygonVertexStart(4,1),PolygonVertexEnd(4,1),SegFrame(iSeg)));
PolyVertex{iSeg}(4,2*iSeg  ,:)=round(linspace(PolygonVertexStart(4,2),PolygonVertexEnd(4,2),SegFrame(iSeg)));




