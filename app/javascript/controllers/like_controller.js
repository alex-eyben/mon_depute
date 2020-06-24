import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'likeCount', 'dislikeCount', 'likeButton', 'dislikeButton' ];

  update(event) {
    event.preventDefault();
    const upOrDown = event.target.classList.contains("fa-thumbs-up") ? true : false;
    const methodLike = event.target.classList.contains("fa-thumbs-up") ? "add" : "remove";
    const methodDislike = event.target.classList.contains("fa-thumbs-up") ? "remove" : "add";
    fetch(`${event.target.dataset.deputyid}/like?like=${upOrDown}&position_id=${event.target.dataset.positionid}`, 
      { headers: { accept: "application/json" } })
      .then(response => response.json())
      .then((data) => {
        this.likeCountTarget.innerText = data.likes;
        this.dislikeCountTarget.innerText = data.dislikes;
        this.likeButtonTarget.classList[methodLike]("true");
        this.dislikeButtonTarget.classList[methodDislike]("true");
    });
  }
}