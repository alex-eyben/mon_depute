const initNotification = () => {
  const unFollowButton = document.querySelector(".button-danger .follow")
  const dropdownButton = document.querySelector(".dropdown-toggle")
  if (unFollowButton){
    unFollowButton.addEventListener("click", (event) => {
      console.log("coucou");
      console.log(event);
      // dropdownButton.classList.add
    });
  }
};

export { initNotification };
