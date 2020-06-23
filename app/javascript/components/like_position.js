import { fetchWithToken } from "../utils/fetch_with_token";

const likePosition = () => {
  const likeIcon = document.querySelectorAll(".fa-thumbs-up")
  const dislikeIcon = document.querySelectorAll(".fa-thumbs-down")


  // si l'icone est un down on change le like en true. 
  // on refresh toutes les icones de la carte après un click
  // a l'intérieur de l'action update on a deux fetch : 
  // un qui like et un qui va chercher le counter et le statut (true or false)
  // et on update le html avec ça
  likeIcon.forEach((icon) => {
    const counter = icon.parentNode.nextSibling.nextSibling;
    icon.addEventListener('click', (event) => {
      event.preventDefault();
      fetch(`/deputies/${icon.dataset.deputyid}/like?like=true&position_id=${icon.dataset.positionid}`)
      .then(response => {
        console.log(response);
        icon.classList.add("true");
        counter.innerHTML = parseInt(counter.innerHTML) + 1;
      });
    });
  });

  dislikeIcon.forEach((icon) => {
    const counter = icon.parentNode.nextSibling.nextSibling;
    icon.addEventListener('click', (event) => {
      event.preventDefault();
      fetch(`/deputies/${icon.dataset.deputyid}/like?like=false&position_id=${icon.dataset.positionid}`)
      .then(response => {
        console.log(response);
        icon.classList.add("true");
        counter.innerHTML = parseInt(counter.innerHTML) + 1;
      });
    });
  });
  
};

export { likePosition };