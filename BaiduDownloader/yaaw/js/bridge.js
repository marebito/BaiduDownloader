function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'https://__bridge_loaded__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

//------------------------------------------------------------------
//                          初始化你的APP
//------------------------------------------------------------------
setupWebViewJavascriptBridge(function(bridge) {
                             
                             /*我们在这注册一个js调用OC的方法，不带参数，且不用ObjC端反馈结果给JS：打开本demo对应的博文*/
                             bridge.registerHandler('JS Echo', function() {
                                                    })

                             /*JS给ObjC提供公开的API，在ObjC端可以手动调用JS的这个API。接收ObjC传过来的参数，且可以回调ObjC*/
                             bridge.registerHandler('Aria2 Download', function(data, responseCallback) {
                                                    console.log("JS Echo called information from ObjC:", data)
                                                    $("#add-task-btn").trigger("click")
                                                    setTimeout(function () {
                                                               $("#uri-more").trigger("click");
                                                               $("#uri-textarea").val(data.files.join("\n"));
                                                               $("#ati-dir").val(data.path);
                                                               $("#add-task-submit").trigger("click");
                                                               }, 500)
                                                    responseCallback(data)
                                                    })

                             /*JS给ObjC提供公开的API，ObjC端通过注册，就可以在JS端调用此API时，得到回调。ObjC端可以在处理完成后，反馈给JS，这样写就是在载入页面完成时就先调用*/
                             bridge.callHandler('getXXXFromObjC', {'name':'1', 'age':'15'}, function responseCallback(responseData) {
                                                console.log("JS received response:", responseData)
                                                })
                             })
