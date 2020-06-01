import swal from 'sweetalert';

const initSweetalert = (options = {}) => {
  const swalBox = document.querySelector(".alert-info");
  console.log(swalBox);
  if (swalBox) { // protect other pages
    swal("Merci d'avoir voté !", "Partager sur Facebook ?", "success", {
       button: "Partager",
    });
  }
};

export { initSweetalert };
