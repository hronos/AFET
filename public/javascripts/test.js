$(document).ready(function() {
    $("a").click(function() {
        alert("Link clicked!");               
    });
    $("#login_form").submit(function() {
        alert("form submitted!!");
        $("#login_form")[0].reset();
    });
                return false;
});
