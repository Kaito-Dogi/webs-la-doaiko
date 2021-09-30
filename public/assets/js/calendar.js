// chipsのスタイルを変更する処理．
const courseCheckboxes = document.getElementsByClassName("course-checkbox");
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

for (let i = 0; i < courseCheckboxes.length; i++) {
  courseLabels[i].addEventListener('click', () => switchChipsStyle(courseCheckboxes[i], courseLabels[i], courseColorCodes[i]));
}

// アプリケーションサーバーから予定のjsonを受け取る．
const schedulesJson = document.getElementById("schedules-getter").textContent;
const schedules = JSON.parse(schedulesJson);

// 予定を表示する処理．
const calendarRows = document.getElementsByClassName("calendar-row");
schedules.forEach((events, index) => {
  const scheduleWrapper = calendarRows[index].getElementsByClassName("schedule-wrapper")[0];
  var eventBox = document.createElement("div");
  eventBox.setAttribute("class","event-box");
  eventBox.style.left = "0px"
  eventBox.style.width = "300px"
  scheduleWrapper.appendChild(eventBox);
});