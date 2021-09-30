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

//各メンター毎に予定を表示する処理．
schedules.forEach((events, index) => {
  // 予定を表示するdivを取得．
  const calendarRows = document.getElementsByClassName("calendar-row");
  const scheduleWrapper = calendarRows[index].getElementsByClassName("schedule-wrapper")[0];

  // 各予定毎にdivを生成し，描画する．
  events.forEach((event) => {
    const eventBox = document.createElement("div");
    eventBox.setAttribute("class","event-box");
    const left = (event.start_time_hour - 9 + event.start_time_min/60)*64;
    eventBox.style.left = `${left}px`;
    eventBox.style.width = `${event.duration*64/60/60}px`;
    scheduleWrapper.appendChild(eventBox);
  });
});