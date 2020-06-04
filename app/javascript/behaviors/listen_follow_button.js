import { followButton } from '../components/follow_button'

const listenFollowButton = (whattodo) => {
  const follow = document.querySelector('.follow-button');
  follow.addEventListener('click', (event) => {
    console.log("listen follow");
    followButton();
  });
}

export { listenFollowButton };
