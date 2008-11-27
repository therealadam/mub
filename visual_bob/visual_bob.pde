import org.json.*;

ArrayList commits = new ArrayList();
int minChange = MAX_INT, maxChange = MIN_INT;

void setup() {
  size(800, 600);
  background(237);
  
  noStroke();
  
  readCommitData();
  println("Min: " + minChange + " Max: " + maxChange);
  drawChart();
}

void readCommitData() {
  String json = join(loadStrings("commits.json"), "");
  JSONObject object = (JSONObject) JSONValue.parse(json);
    
  Iterator i = object.entrySet().iterator();
  
  while (i.hasNext()) {
    Map.Entry entry = (Map.Entry) i.next();
    String sha = (String) entry.getKey();
    HashMap value = (HashMap) entry.getValue();
    int test = ((Long) value.get("tests")).intValue();
    int app = ((Long) value.get("app")).intValue();
    
    updateRanges(app, test);
    commits.add(new CommitStat(sha, test, app));
  }
}

void updateRanges(int app, int test) {
  maxChange = max(max(app, test), maxChange);
  minChange = min(min(app, test), minChange);
}

void drawChart() {
  drawAxis();
  drawCommit(10, 5);
}

void drawAxis() {
  int padding = 5;
  
  fill(75);
  rect(padding, height / 2, width - (padding * 2), 3);
}

void drawCommit(int app, int test) {
  int padding = 5;
  int maxHeight = (height / 2) - padding;
  int rectWidth = 10;
  int offset = 5;
  
  // TODO: Calculate these
  int x = (padding * 2) + 0;
  float rectHeight = map(app, minChange, maxChange, 0, maxHeight);
  
  // Draw the app bar
  fill(#212BF1, 200);
  rect(x, height / 2, rectWidth, -1 * rectHeight);
  
  // Draw the test bar
  x = (padding * 2) + 5;
  rectHeight = map(test, minChange, maxChange, 0, -1 * maxHeight);
  fill(#FA761F, 200);
  
  rect(x, height / 2, rectWidth, rectHeight);
}

class CommitStat {
  String sha;
  int tests;
  int app;
  
  CommitStat(String sha, int tests, int app) {
    this.sha = sha;
    this.tests = tests;
    this.app = app;
  }
}
