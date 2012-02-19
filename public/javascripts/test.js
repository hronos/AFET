$(document).ready(function() {
    $("a").click(function() {
        alert("Link clicked!");               
    });
    $("#login_form").submit(function() {
        alert("form submitted!!");
    });
                return false;
});
