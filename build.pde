
void build()
{
String applicationRoot=rootDirectory+"/scripts";
String OpenScript=applicationRoot+"/Open.scpt";
String BuildScript=applicationRoot+"/Build.scpt";
String OkScript=applicationRoot+"/Ok.scpt";

  vendingMachine.placePartInBin(things[selectedThing]);
  String[] okParams={"osascript",OkScript};
  exec(okParams);
  delay(1000);
  
  String[] openParams = {"osascript",OpenScript, things[selectedThing].gcodePath};  //open the gcode file
  exec(openParams); 
  delay(10000);
 
  String[] buildParams={"osascript",BuildScript};
  exec(buildParams); 
}
