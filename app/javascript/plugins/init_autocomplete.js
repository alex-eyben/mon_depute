import places from 'places.js';
require('dotenv').config()

const initAutocomplete = () => {
  const key = process.env.ALGOLIA_API_KEY;
  console.log(key);
  console.log("hey");
  const addressInput = document.getElementById('location-search');
  if (addressInput) {
    places({ container: addressInput
    }).configure({
    countries: ['fr']
  });
  }
};

export { initAutocomplete };
