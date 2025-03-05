chrome.action.onClicked.addListener((tab) => {
    const url = tab.url;
    console.log(`URL: ${url}`);

    chrome.runtime.sendNativeMessage("com.jx.yt_dlp", { "url": url }, (response) => {
        if (chrome.runtime.lastError) {
            console.error("Error: ", chrome.runtime.lastError.message);
        } else {
            console.log("Result: ", response);
        }
    });
});
