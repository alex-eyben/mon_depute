import { annotate } from 'rough-notation';

const initRoughnotation = () => {
  document.fonts.ready.then(function () {
    const highlights = document.querySelectorAll('.highlight');
    highlights.forEach((highlight) => {
      const annotation = annotate(highlight, { type: 'highlight', color: '#FFF176' });
      annotation.show();
    });
    const underlinesBlue = document.querySelectorAll('.underline-blue');
    underlinesBlue.forEach((underline) => {
      const annotation = annotate(underline, { type: 'underline', color: '#2196F3', padding: 3, strokeWidth: 3 });
      annotation.show();
    });
    const underlinesRed = document.querySelectorAll('.underline-red');
    underlinesRed.forEach((underline) => {
      const annotation = annotate(underline, { type: 'underline', color: '#DB3F41', padding: 3, strokeWidth: 3 });
      annotation.show();
    });
    const roughboxes = document.querySelectorAll('.roughbox');
    roughboxes.forEach((box) => {
      const annotation = annotate(box, { type: 'box', color: '#FFF176' });
      annotation.show();
    });
    const followButton = document.querySelector(".follow-button")
    const dropdownButton = document.querySelector(".dropdown-toggle")

    if (followButton) {
      const annotation = annotate(dropdownButton, { type: 'box', color: '#FFF176' });
      followButton.addEventListener("click", (event) => {
        annotation.show();
      });
      dropdownButton.addEventListener("click", (event) => {
        annotation.hide();
      });
    };
  });
};

export { initRoughnotation };
