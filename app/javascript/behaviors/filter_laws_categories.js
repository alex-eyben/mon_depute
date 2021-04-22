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
      const checkIfListAlreadyFiltered = document.querySelector(".current-label") == null;
        if (checkIfListAlreadyFiltered) {
          insertFilteredTag(currentTagContainer, selectedCategory);
        } else {
          removeLastChild(currentTagContainer);
          insertFilteredTag(currentTagContainer, selectedCategory);
        };
      const newTrigger = document.querySelector(".current-label")
      newTrigger.addEventListener("click", () => {
        showElements(allLaws);
        showElements(originalTagList);
        removeLastChild(currentTagContainer);
      });
    });
  })
}

const insertFilteredTag = (container, category) => {
  container.insertAdjacentHTML('beforeEnd', `
    <li class="categorie-label ${category} current-label">
      #${category} <i class="fas fa-times"></i>
    </li>`)
  ;
}

const removeLastChild = (element) => {
  element.removeChild(element.lastChild);
};

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