const initNotification = () => {
  const unFollowButton = document.querySelector(".button-danger .follow")
  const dropdownButton = document.querySelector(".dropdown-toggle")
  if (unFollowButton){
    unFollowButton.addEventListener("click", (event) => {
      // dropdownButton.classList.add
    });
  }
};

export { initNotification };
