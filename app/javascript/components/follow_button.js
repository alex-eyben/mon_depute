import { fetchWithToken } from "../utils/fetch_with_token";

const followButton = () => {
  const deputyCard = document.querySelector('.deputy-card')
  if (deputyCard) {
    const dataset = deputyCard.dataset;
    const follow = document.querySelector('.follow-button');
    const dropdown = document.querySelector('#navbarDropdown');
    const dropdownMenu = document.querySelector('.dropdown-menu');
    const dropdownElements = dropdownMenu.childNodes;

    const refresh = () => {
      fetch(`/deputies/${dataset.id}/is_followed`, { headers: { accept: 'application/json' } })
          .then(response => response.json())
          .then((data) => {
            if (data.is_followed) {
              follow.innerHTML = `<a class="button button-danger follow width-grow" href="">Ne plus suivre</a>`;
            } else {
              follow.innerHTML = `<a class="button button-primary follow width-grow" href="">Suivre</a>`;
            };
            console.log(data.is_followed);
            console.log(data);
            console.log(data.deputies.length)
            if (data.deputies.length !== 0) {
              console.log("not empty")
              dropdown.classList.remove('hidden');
              dropdownMenu.innerHTML = ""
              data.deputies.forEach((deputy) => {
                dropdownMenu.insertAdjacentHTML('beforeend', `<div class="dropdown-item"><a class="link" href="/deputies/${deputy.id}"><img class="avatar dropdown-toggle" id="navbarDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" src="${deputy.img}"><p>${deputy.first_name} ${deputy.last_name}</p></a><div class="unfollow-deputy" id="${deputy.id}"><a class="unfollow" rel="nofollow" href=""><i class="fas fa-user-slash"></i></a></div></div>`)
              });
            } else {
              console.log("empty")
              dropdown.classList.add('hidden');
            };
            dropdownElements.forEach((item) => {
              console.log(item);
              item.addEventListener('click', (event) => {
                event.preventDefault();
                console.log("navbar");
                console.log(event.currentTarget.childNodes[1]);
                fetchWithToken(`/deputies/${event.currentTarget.childNodes[1].id}/follow`, {
                  method: "POST",
                  headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json"
                  },
                  // body: JSON.stringify({ restaurant: { name: restaurantNameInput.value }})
                })
                  .then(response => response.json())
                  .then((data) => {
                    refresh();
                  });
                alert
              });
            })
          });
        };
    refresh();

    follow.addEventListener("click", (event) => {
      event.preventDefault();

      fetchWithToken(`/deputies/${dataset.id}/follow`, {
        method: "POST",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        // body: JSON.stringify({ restaurant: { name: restaurantNameInput.value }})
      })
        .then(response => response.json())
        .then((data) => {
          refresh();
        });
    });

    console.log(dropdownMenu.childNodes);
    // const followButtons = dropdownMenu.querySelector('.unfollow-deputy')
    // console.log(followButtons);
  };
};

export { followButton };




  //   const followButton = document.querySelector('.follow-button')

  // };


// const listenFollowButton = () => {
//   const follow = document.querySelector('.follow-button');
//   follow.addEventListener('click', (event) => {
//     console.log("listen follow");
//     followButton();
//   });
// }
