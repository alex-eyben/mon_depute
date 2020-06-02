import swal from 'sweetalert';

const initSweetalert = (options = {}) => {
  const swalBox = document.querySelector(".alert-info");
  if (swalBox) { // protect other pages
    swal("Merci d'avoir voté !", "Partager sur Facebook ?", "success", {
       button: "Partager",
    }).then((value) => {
      if (value) {
        FB.ui({
          method: 'share',
          href: window.location.href,
        }, function(response){});
      }
    })
  }
};

export { initSweetalert };

