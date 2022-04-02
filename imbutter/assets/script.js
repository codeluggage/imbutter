function submit() {
    var coloredDiv = document.getElementById("coloredDiv");
    var h1 = document.getElementById("heading1");
    var h2 = document.getElementById("heading2");
    var h3 = document.getElementById("heading3");
    var h4 = document.getElementById("heading4");

    coloredDiv.setAttribute('style', 'background:blue;')

    // JavascriptChannel.postMessage({ test: 'hello world' })
    // const hold = fetch({
    //     // method: 'GET',
    //     url: 'localhost:8080/api/v1/hello',
    //     headers: {
    //         'Content-Type': 'application/json',
    //     },
    // // url: 'localhost:8080/hello'
    // }).then(response => {
    fetch('http://localhost:8080/hello').then(response => {
        h1.textContent = JSON.stringify(response)
        // JavascriptChannel.postMessage(`${response}`)

        response.text().then((text) => {
            coloredDiv.setAttribute('style', 'background:green;')
            h2.textContent = text
            // JavascriptChannel.postMessage(text)
        }).catch(error => {
            coloredDiv.setAttribute('style', 'background:purple;')
            h3.textContent = error
            // JavascriptChannel.postMessage(`${error}`);
        });

        // response.json().then((json) => {
        //     coloredDiv.setAttribute('style', 'background:green;')
        //     h2.textContent = JSON.stringify(json)
        //     JavascriptChannel.postMessage(JSON.stringify(json))
        // }).catch(error => {
        //     coloredDiv.setAttribute('style', 'background:purple;')
        //     h3.textContent = error
        //     JavascriptChannel.postMessage(`${error}`)
        // })

        // JavascriptChannel.postMessage(`${response.body}`);
    }).catch(error => {
        coloredDiv.setAttribute('style', 'background:red;')
        h4.textContent = error
        // JavascriptChannel.postMessage(`${error}`);
    })

    h4.textContent = `${hold}`

    // fetch({
    //     method: 'GET',
    //     url: 'localhost:3000/hello',
    //     // url: 'localhost:8080/hello'
    // }).then(response => { 
    //     response.json().then((text) => {
    //         coloredDiv.setAttribute('style', 'background:green;')
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