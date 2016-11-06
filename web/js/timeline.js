// $Id: timeline.js,v 1.2 2006/06/26 01:10:36 david Exp $

function choosef () {
    var c = document.controls;
    var list = c.textfiles;
    if (list.selectedIndex < 0) return;
    c.datafile.value = list.options[list.selectedIndex].value;
    c.redraw_yn.value = 0;
    c.submit();
}

function resetdata () {
    var c = document.controls;
    c.redraw_yn.value = 1;
    c.submit();
}