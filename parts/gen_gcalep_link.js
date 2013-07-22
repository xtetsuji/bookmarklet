var DEBUG = 0;

var pad = function(digit) {
    if(digit.toString().length==1) digit="0"+digit.toString();
    return digit;
};

var to_utcdigit = function(jst) { // String jst
    var date, incl_date=false;
    if(m=jst.match(/ (2[4-9]):([0-9][0-9])/)) {
        incl_date = true;
        jst = jst.replace(/ 2[4-9]:[0-9][0-9]/, " "+pad(parseInt(m[1])-24)+":"+m[2]);
    }
    if(DEBUG){console.log("jst="+jst);}
    date = new Date(jst); // valid JST Date string
    if(incl_date){
        date.setDate(date.getDate()+1); // 末日バグ等は無いはず
    }
    //console.log("dated_jst="+date.toString());
    //console.log("incl_date is " + (incl_date?"true":"false"));
    return(date.getUTCFullYear().toString()+pad(date.getUTCMonth()+1)+pad(date.getUTCDate())+"T"+pad(date.getUTCHours())+pad(date.getUTCMinutes())+pad(date.getUTCSeconds())+"Z");
};

var gen_gcalep_link = function(arg) {
    // args: text, url, desc, location,
    //       from, to (valid string as Date object constructor 1st argument)
    if(DEBUG){console.log("gen_gcalep_link argument", arg);}
    var gparam = {};
    var gparam_array = [];
    var gparam_keys = ["action", "text", "dates", "sprop", "details", "location"];
    var gev_url_base = "http://www.google.com/calendar/event?";
    var from = arg["from"];
    var to = arg["to"];
    var dates = to_utcdigit(from)+"/"+to_utcdigit(to);
    gparam["action"]   = arg["action"] || "TEMPLATE";
    gparam["text"]     = arg["text"];
    gparam["dates"]    = dates;
    gparam["sprop"]    = arg["url"]?arg["url"].replace(/^http:/,"website:"):"";
    gparam["details"]  = (arg["url"]?arg["url"]+"\n":"")+(arg["desc"]||"");
    gparam["location"] = arg["location"] || "";
    gparam_keys.forEach(
        function(key){
            gparam_array.push(key+"="+encodeURIComponent(gparam[key]));
        }
    );
    return(gev_url_base+gparam_array.join("&"));
};
