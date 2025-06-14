var namelist = document.querySelectorAll('.pageNames li');

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

