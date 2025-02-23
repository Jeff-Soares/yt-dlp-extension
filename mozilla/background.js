browser.action.onClicked.addListener(async (tab) => {
    const url = tab.url;
    console.log(`URL: ${url}`);

    browser.runtime.sendNativeMessage("com.jx.yt_dlp", { "url": url })
        .then(response => { console.log("Result: ", response); })
        .catch(error => { console.error("Error: ", error); });

});
