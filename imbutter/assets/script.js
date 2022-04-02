function submit() {
    var coloredDiv = document.getElementById("coloredDiv");
    var h1 = document.getElementById("heading1");

    coloredDiv.setAttribute('style', 'background:blue;')
    JavascriptChannel.postMessage('clicked')

    // ... send message to flutter app
    // fetch({
    //     method: 'GET',
    //     url: 'localhost/hello',
    //     // url: 'localhost:8080/hello'
    // }).then(response => { 
    //     heading1.setText(`${response.toString()}`)
    //     response.json().then((text) => {
    //         coloredDiv.setAttribute('style', 'background:green;')
    //         heading1.setText(`${text}`)
    //         // JavascriptChannel.postMessage(`${text}`)
    //     });

    //     // JavascriptChannel.postMessage(`${response.body}`);
    // }).catch(error => {
    //     coloredDiv.setAttribute('style', 'background:red;')
    //     // JavascriptChannel.postMessage(`${error}`);
    // })
}

function ok() {
    var coloredDiv = document.getElementById("coloredDiv");
    coloredDiv.setAttribute('style', 'background:orange;')
}