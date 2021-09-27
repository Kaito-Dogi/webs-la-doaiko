const courseCheckboxs = document.getElementsByClassName("course-checkbox");
const courseLabels = document.getElementsByClassName("course-chips");
const courseColorCodes = [
  "#FFD166",
  "#3DDC84",
  "#7B4B94",
  "#5AA9E6",
  "#CC342D",
  "#FFB2E6"
];

const switchChipsStyle = (checkbox, label, colorCode) => {
  if(checkbox.checked) {
    label.style.backgroundColor = "white";
    label.style.color = "#666";
  } else {
    label.style.backgroundColor = colorCode;
    label.style.color = "white";
  }
};

for (let i = 0; i < courseCheckboxs.length; i++) {
  courseLabels[i].addEventListener('click', () => switchChipsStyle(courseCheckboxs[i], courseLabels[i], courseColorCodes[i]));
}