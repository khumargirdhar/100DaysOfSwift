var Action: function() { }

Action.prototype = {
    
run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "Title": document.title });
},
    
finalize: function(parameters) {
    var customJavaScript = parameters["customJavaScript"];
    eval(customJavaScript);                     //Run code
}
    
};

var ExtensionPreprocessingJS = new Action
