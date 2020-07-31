require('dotenv').config()

const initAutocomplete = () => {
  var client = algoliasearch(process.env.ALGOLIA_APP_ID, process.env.ALGOLIA_API_KEY);
  var index = client.initIndex('Deputy'); 

  function newHitsSource(index, params) {
    return function doSearch(query, cb) {
      index
        .search(query, params)
        .then(function(res) {
          cb(res.hits, res);
        })
        .catch(function(err) {
          console.error(err);
          cb([]);
        });
    };
  }

  autocomplete('#location-search', { hint: false, cssClasses: {prefix: 'ad-example'} }, [
    {
      source: newHitsSource(index, { hitsPerPage: 3 }),
      displayKey: 'full_name',
      templates: {
        header: '<div class="ad-example-header">Députés</div>',
        suggestion: function(suggestion) {
          return '<div>' + suggestion._highlightResult.full_name.value + '</div>';
        }
      }
    }, placesAutocompleteDataset({
      appId: process.env.ALGOLIA_PLACES_APP_ID,
      apiKey: process.env.ALGOLIA_PLACES_API_KEY,
      algoliasearch: algoliasearch,
      templates: {
        header: '<div class="ad-example-header">Villes</div>'
      },
      hitsPerPage: 3,
      countries: ['fr']
    })
  ]).on('autocomplete:selected', function(event, suggestion, dataset, context) {
    if (dataset == 1) {
      location.href = '/deputies/' + suggestion.objectID;
    }    
  });
};










// const client = algoliasearch(process.env.ALGOLIA_APP_ID, process.env.ALGOLIA_API_KEY);
// const index = client.initIndex('Deputy');

// const deputiesDataset = {
//   source: autocomplete.sources.hits(index, {hitsPerPage: 2}),
//   displayKey: 'full_name',
//   name: 'deputies',
//   templates: {
//     header: '<div class="ad-example-header">Députés</div>',
//     suggestion: function(suggestion) {
//       return '<div>' +
//           'hello' + '<br />'+
//        '</div>';
//     }
//   }
// };

// const placesDataset = placesAutocompleteDataset({
//   appId: process.env.ALGOLIA_PLACES_APP_ID,
//   apiKey: process.env.ALGOLIA_PLACES_API_KEY,
//   algoliasearch: algoliasearch,
//   templates: {
//     header: '<div class="ad-example-header">Villes</div>'
//   },
//   hitsPerPage: 3
// });

// const autocompleteInstance = autocomplete(document.querySelector('#location-search'), {
//   hint: false,
//   debug: true,
//   cssClasses: {prefix: 'ad-example'}
// }, [
//   deputiesDataset,
//   placesDataset
// ]);

// const autocompleteChangeEvents = ['selected', 'autocompleted'];

// const initAutocomplete = () => {
//   autocompleteChangeEvents.forEach(function(eventName) {
//     autocompleteInstance.on('autocomplete:'+ eventName, function(event, suggestion, datasetName) {
//       console.log(datasetName, suggestion);
//     });
//   });
// };







// const initAutocomplete = () => {
//   console.log("hey");
//   const placesAutocomplete = places({
//     appId: process.env.ALGOLIA_PLACES_APP_ID,
//     apiKey: process.env.ALGOLIA_PLACES_API_KEY,
//     container: document.getElementById('location-search')
//   }).configure({
//       countries: ['fr']
//     });
// };

export { initAutocomplete };
