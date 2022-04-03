const submit = async () => {
  console.trace('tracing')
  console.log('starting fetch from js...')

  var coloredDiv = document.getElementById('coloredDiv')
  var h1 = document.getElementById('heading1')
  var h2 = document.getElementById('heading2')
  var h3 = document.getElementById('heading3')
  var h4 = document.getElementById('heading4')

  coloredDiv.setAttribute('style', 'background:blue;')

  try {
    const res = await fetch('http://localhost:8080/hello-text')
    console.log(res)

    if (!res.ok) {
      console.log('!res.ok')
      coloredDiv.setAttribute('style', 'background:red;')
      h4.textContent = error
      return
    }

    h1.textContent = JSON.stringify(res)

    const text = await res.text()
    console.log(`awaited text: ${text}`)

    coloredDiv.setAttribute('style', 'background:green;')
    h2.textContent = text
  } catch (e) {
    coloredDiv.setAttribute('style', 'background:purple;')
    h3.textContent = e
  }
}

function ok () {
  var coloredDiv = document.getElementById('coloredDiv')
  coloredDiv.setAttribute('style', 'background:orange;')
}
