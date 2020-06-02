import places from 'places.js';

const initAutocomplete = () => {
  const addressInput = document.getElementById('location-search');
  if (addressInput) {
    places({ container: addressInput
    }).configure({
    countries: ['fr']
  });
  }
};

export { initAutocomplete };
