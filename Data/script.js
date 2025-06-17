var namelist = document.querySelectorAll('.pageNames li');
var page1btn = document.querySelector('.homeBodyText button')


namelist.forEach(item => {
      // Changes the color of text to cyan on hover.
  item.onmouseover = () => {
    item.querySelector('a').style.color = "#00ffe7";
  }
      // Changes the color of text back to normal when not hovering.
  item.onmouseout = () => {
    item.querySelector('a').style.color = "#dddddd"; 
  }
});

page1btn.addEventListener('mouseover', () => {
  page1btn.style.transition = "0.3s all";
  page1btn.style.transform = 'scale(1.05)';
});
page1btn.addEventListener('mouseleave', () => {
  page1btn.style.transform = 'none';
});
