var shiaSays = ["Don't let your dreams be dreams.", "Do it. Just DO IT.", "If you’re tired of starting over, stop giving up.", 
  "Some people dream of success, while you’re gonna wake up and work hard at it."]
var index = Math.floor(Math.random()*shiaSays.length);

print(shiaSays[index]);

/* Configure prompt */

prompt = function() {
 if (typeof db == "undefined") {
    return "(nodb) >> ";
  }
  try {
    db.runCommand({getLastError:1});
  } catch (e) {
    print(e);
  }
  return db + " >> ";
}
