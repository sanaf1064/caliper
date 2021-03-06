
$(function () {
    var test = document.getElementById("application_tst").value;

    var compile_dic = getJson(test, 'compile')
    var columns = getHoriColumn(compile_dic);
    var data = getHoriData(compile_dic, columns);

    // initialize grid
    var options = {emptyRow: true, sortable: false};
    var grid = $(document.getElementById("application_compile")).grid(data, columns, options);

    draw_grid(grid);

    // api examples
    var $row = grid.getRowByIndex(1);
    console.group("data api examples");
    console.log("grid.getGridData():", grid.getGridData());
    console.groupEnd();

    window.grid = grid;
});
