function adjustFooterPosition() {
  var contentHeight = document.querySelector(".container").offsetHeight;
  var paginationHeight = document.querySelector(".pagination")?.offsetHeight || 0;
  var windowHeight = window.innerHeight;
  var footer = document.querySelector(".footer");

  if (contentHeight + paginationHeight < windowHeight) {
    footer.style.position = "fixed";
    footer.style.bottom = 0;
  }
}

window.addEventListener("resize", adjustFooterPosition);
window.addEventListener("load", adjustFooterPosition);
window.addEventListener("mouseover", adjustFooterPosition);
