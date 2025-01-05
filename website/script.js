// Event listener for "search" button click
function searchArtist() {
    // store user input for artist name
    const artistName = document.getElementById("artistInput").value;
    // store selected option of data type
    const dataType = document.getElementById("dataSelect").value;

    // structure of api URL with query strings
    // CHANGE PLACEHOLDERS AFTER DEPLOYING BACKEND RESOURCES ///////////////////////////
    const apiUrl = `https://<API_GATEWAY_URL>/dev/spotify?artist=${artistName}&type=${dataType}`

    
    // making request to api gateway (fetch) that triggers lambda function
    fetch(apiUrl)
    .then(response => response.json()) // converting to json
    .then(data => {
        const outputContainer = document.getElementById("output");
        outputContainer.innerHTML = "";  // clears output from last api call

        if (dataType === "topSongs") {
            let htmlContent = `<h2>Top Songs for ${artistName}</h2>`;
            data.forEach(song => {
                htmlContent += `<p>${song.name} by ${song.artist}</p>`;
            });
            outputContainer.innerHTML = htmlContent;
        } else if (dataType === "bestSong") {
            let htmlContent = `<h2>Most listened song by ${artistName}</h2>`;
            if (data && data.length > 0) {
                htmlContent += `<p>${data[0].name}</p>`;
            }
            outputContainer.innerHTML = htmlContent;
        } else if (dataType === "latestAlbum") {
            let htmlContent = `<h2>Latest Album by ${artistName}</h2>`;
            if (data && data.length > 0) {
                htmlContent += `<p>${data[0].name}</p>`;
            outputContainer.innerHTML = htmlContent;
        }
}})
    .catch(error => {
        console.error('Error fetching data', error);
        const outputContainer = document.getElementById("output");
        outputContainer.innerHTML = `<p>Error fetching data. Please try again later.</p>`;
    })
}
















































