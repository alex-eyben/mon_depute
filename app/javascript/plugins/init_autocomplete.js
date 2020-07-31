require('dotenv').config()

const initAutocomplete = () => {
  const key = process.env.ALGOLIA_API_KEY;
  console.log(key);
  console.log("hey");
  const placesAutocomplete = places({
    appId: process.env.ALGOLIA_APP_ID,
    apiKey: process.env.ALGOLIA_API_KEY,
    container: document.getElementById('location-search')
  }).configure({
      countries: ['fr']
    });
};

export { initAutocomplete };
