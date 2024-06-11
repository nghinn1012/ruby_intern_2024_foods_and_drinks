function toggleDropdown() {
  var dropdownButton = document.getElementById("userDropdownButton");
  var dropdownMenu = dropdownButton.nextElementSibling;

  if (dropdownMenu.classList.contains("show")) {
    dropdownMenu.classList.remove("show");
  } else {
    dropdownMenu.classList.add("show");
  }
}

document.addEventListener("DOMContentLoaded", function() {
  var dropdownButton = document.getElementById("userDropdownButton");

  dropdownButton.addEventListener("click", toggleDropdown);
});

window.addEventListener("load", function() {
  var dropdownButton = document.getElementById("userDropdownButton");

  dropdownButton.addEventListener("click", toggleDropdown);
});
