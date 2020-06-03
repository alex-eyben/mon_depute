import { annotate } from 'rough-notation';

const initRoughnotation = () => {
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
};

export { initRoughnotation };
