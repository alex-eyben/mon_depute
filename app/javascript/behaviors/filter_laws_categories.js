const initFilterLaws = () => {
  const currentTagContainer = document.querySelector(".categorie-container");
  const originalTagList = currentTagContainer.querySelectorAll(":scope > .categorie-label");
  const triggers = document.querySelectorAll(".categorie-label");
  const allLaws = document.querySelectorAll(".law-card");

  triggers.forEach((trigger) => {
    trigger.addEventListener("click", (event) => {
      showElements(allLaws);
      const selectedCategory = event.currentTarget.className.replaceAll("categorie-label ", "");
      const lawsToHide = document.querySelectorAll(`.law-card:not(.${selectedCategory})`);
      hideElements(lawsToHide);
      hideElements(originalTagList);
      currentTagContainer.insertAdjacentHTML('beforeEnd', `
        <li class="categorie-label ${selectedCategory} current-label">
          #${selectedCategory} <i class="fas fa-times"></i>
        </li>`);
      const newTrigger = document.querySelector(".current-label")
      newTrigger.addEventListener("click", () => {
        showElements(allLaws);
        showElements(originalTagList);
        currentTagContainer.removeChild(currentTagContainer.lastChild);
      });
    });
  })
}

const hideElements = (elements) => {
  elements.forEach((element) => {
    element.classList.add("hidden");
  });
}

const showElements = (elements) => {

  elements.forEach((element) => {
    element.classList.remove("hidden");
  });
}

export { initFilterLaws };