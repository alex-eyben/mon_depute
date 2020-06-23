// Toute la logie du like est dans le controller député. Devrait être dans le controller position ?
// Ou alors cette route renvoie un JSON avec toutes les infos dont a besoin le JS.

// créer un dataset qui contient le deputy.id et le position.id
// créer un selecteur sur le like

// quand le like est cliqué fetch sur deputies/positionId/like
// si true rien ne change
// si false passe en true et changement du inner HTML du boutton et du next sibling


// quand le dislike est cliqué fetch sur deputies/positionId/like
// si false rien ne change
// si true passe en false et changement du inner HTML du boutton et du next sibling

import { fetchWithToken } from "../utils/fetch_with_token";

const likePosition = () => {
  const likeIcon = document.querySelectorAll(".fa-thumbs-up")
  const dislikeIcon = document.querySelectorAll(".fa-thumbs-down")

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