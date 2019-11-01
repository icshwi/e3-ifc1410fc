importPackage(Packages.org.csstudio.platform.data);
importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

/*
input:
0 - ROI3 min RBV scalar
1 - ROI3 size RBV scalar
2 - ROI3 binning RBV scalar
3 - ROI2 min RBV scalar
4 - ROI2 size RBV scalar
5 - ROI2 binning RBV scalar
6 - TS3 trace maximum value scalar

We need to make sure that the cursors always point to the right part
of the trace, no matter what ROI & binning is used, if user zooms in/out,
if auto zooming is used, if is graph reset,..
With out limits points auto zoom does not show the complete pulse or
cursors in the right place. 

ROI3 is applied to flat top chain.
It is also used to position the cursors on a whole pulse graph.
ROI2 is applied to whole pulse chain.
It is also used to position the cursor limits on a whole pulse graph.
*/

var traceMax = PVUtil.getDouble(pvs[6]);

var roi3Min = parseInt(PVUtil.getDouble(pvs[0]));
var roi3Size = parseInt(PVUtil.getDouble(pvs[1]));
var roi3Bin = parseInt(PVUtil.getDouble(pvs[2]));
var roi3End = roi3Min + roi3Size;
ConsoleUtil.writeInfo("ROI3 min..end: "+roi3Min+'..'+roi3End+'( bin:'+roi3Bin+')');
var cursorX = DataUtil.createIntArray(4);
cursorX[0] = roi3Min;
cursorX[1] = roi3Min;
cursorX[2] = roi3End;
cursorX[3] = roi3End;
var cursorY = DataUtil.createIntArray(4);
cursorY[0] = 0;
cursorY[1] = traceMax+(traceMax*0.01);
cursorY[2] = 0;
cursorY[3] = traceMax+(traceMax*0.01);
PVUtil.writePV("loc://cur_x(0,0,0,0)", cursorX);
PVUtil.writePV("loc://cur_y(0,0,0,0)", cursorY);

var roi2Min = parseInt(PVUtil.getDouble(pvs[3]));
var roi2Size = parseInt(PVUtil.getDouble(pvs[4]));
var roi2Bin = parseInt(PVUtil.getDouble(pvs[5]));
var roi2End = roi2Min + roi2Size; 
ConsoleUtil.writeInfo("ROI2 min..end: "+roi2Min+'..'+roi2End+'( bin:'+roi2Bin+')');
var limitX = DataUtil.createIntArray(4);
limitX[0] = roi2Min;
limitX[1] = roi2Min;
limitX[2] = roi2End;
limitX[3] = roi2End;
var limitY = DataUtil.createIntArray(4);
limitY[0] = 0;
limitY[1] = traceMax+(traceMax*0.01);
limitY[2] = 0;
limitY[3] = traceMax+(traceMax*0.01);
PVUtil.writePV("loc://lim_x(0,0,0,0)", limitX);
PVUtil.writePV("loc://lim_y(0,0,0,0)", limitY);
