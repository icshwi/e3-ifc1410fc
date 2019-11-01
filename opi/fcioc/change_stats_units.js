importPackage(Packages.org.csstudio.platform.data);
importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var value = PVUtil.getLong(pvs[0]);
// ConsoleUtil.writeInfo("conversion: " + value);
var egu = PVUtil.getString(pvs[1]);
// ConsoleUtil.writeInfo("EGU PV: " + egu);
// var prec = PVUtil.getString(pvs[2]);
// ConsoleUtil.writeInfo("precision: " + prec);

if (value == 0) {
	pvs[1].setValue("ADC counts");
	// widget.setPropertyValue("precision", 0);
	// pvs[2].setValue(0);
} else {
	pvs[1].setValue("mA");
	// widget.setPropertyValue("precision", 1);
	// pvs[2].setValue(1);
}
