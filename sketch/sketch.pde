import org.json.*;

ArrayList commits = new ArrayList();

void setup() {
  size(800, 600);
  
  background(237);
  
  readCommitData();
}

void readCommitData() {
  String json = join(loadStrings("commits.json"), "");
  JSONObject object = (JSONObject) JSONValue.parse(json);
    
  Iterator i = object.entrySet().iterator();
  
  while (i.hasNext()) {
    Map.Entry entry = (Map.Entry) i.next();
    String sha = (String) entry.getKey();
    HashMap value = (HashMap) entry.getValue();
    int tests = ((Long) value.get("tests")).intValue();
    int app = ((Long) value.get("app")).intValue();
    commits.add(new CommitStat(sha, tests, app));
  }
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
