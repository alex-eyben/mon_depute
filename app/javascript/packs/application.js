// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
// import { initSweetalert } from '../plugins/init_sweetalert';

import { initAutocomplete } from '../plugins/init_autocomplete';
import { initRoughnotation } from '../plugins/init_roughnotation';
import { filterLaws, initFilterLaws } from '../behaviors/filter_laws_categories';

// Reactivate when dataviz reactivated
// import { initProgressbar } from '../plugins/init_progressbar';

// Reactivate when follow deputy logic reactivated
// import { initNotification } from '../plugins/init_notification';
// import { followButton } from '../components/follow_button';
// import { deputiesDropdown } from '../components/deputies_dropdown';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  // initSweetalert();

  initRoughnotation();
  initAutocomplete();
  initFilterLaws();
  
  // Reactivate when dataviz reactivated
  // initProgressbar();

  // Reactivate when follow deputy logic reactivated
  // deputiesDropdown();
  // followButton();
  // initNotification();
});


$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

import "controllers"
