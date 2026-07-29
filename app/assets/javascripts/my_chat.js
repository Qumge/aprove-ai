var pieOptions     = {
    //Boolean - Whether we should show a stroke on each segment
    segmentShowStroke    : true,
    //String - The colour of each segment stroke
    segmentStrokeColor   : '#fff',
    //Number - The width of each segment stroke
    segmentStrokeWidth   : 2,
    //Number - The percentage of the chart that we cut out of the middle
    percentageInnerCutout: 0, // This is 0 for Pie charts
    //Number - Amount of animation steps
    animationSteps       : 100,
    //String - Animation easing effect
    animationEasing      : 'easeOutBounce',
    //Boolean - Whether we animate the rotation of the Doughnut
    animateRotate        : true,
    //Boolean - Whether we animate scaling the Doughnut from the centre
    animateScale         : false,
    //Boolean - whether to make the chart responsive to window resizing
    responsive           : true,
    // Boolean - whether to maintain the starting aspect ratio or not when responsive, if set to false, will take up entire container
    maintainAspectRatio  : true,
    //String - A legend template
    legendTemplate       : '<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<segments.length; i++){%><li><span style="background-color:<%=segments[i].fillColor; console.log(1);%>"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>'
};

var chatColor = ['#00a65a', '#dd4b39', '#00c0ef', '#f39c12', '#3c8dbc', '#ff0084', '#205081', '#f94877', '#001f3f','#d2d6de']
//var chatColor = ['#2edfa3', '#0eb83a', '#70f3ff', '#177cb0', '#f00056', '#ff7500', '#ff4e20', '#b35c44', '#758a99', '#424c50']
var barChartOptions                  = {
    //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
    scaleBeginAtZero        : true,
    //Boolean - Whether grid lines are shown across the chart
    scaleShowGridLines      : true,
    //String - Colour of the grid lines
    scaleGridLineColor      : 'rgba(0,0,0,.05)',
    //Number - Width of the grid lines
    scaleGridLineWidth      : 1,
    //Boolean - Whether to show horizontal lines (except X axis)
    scaleShowHorizontalLines: true,
    //Boolean - Whether to show vertical lines (except Y axis)
    scaleShowVerticalLines  : true,
    //Boolean - If there is a stroke on each bar
    barShowStroke           : true,
    //Number - Pixel width of the bar stroke
    barStrokeWidth          : 2,
    //Number - Spacing between each of the X value sets
    barValueSpacing         : 5,
    //Number - Spacing between data sets within X values
    barDatasetSpacing       : 1,
    //String - A legend template
    legendTemplate          : '<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>',
    //Boolean - whether to make the chart responsive
    responsive              : true,
    maintainAspectRatio     : true,
    multiTooltipTemplate: "<%if (datasetLabel){%><%=datasetLabel%>: <%}%><%= value %>"
}

function myPieChat(id, labels, data){
    var pieChartCanvas = $('#' + id).get(0).getContext('2d');
    var pieChart       = new Chart(pieChartCanvas);
    pieChart.Pie(formatPieData(labels, data), pieOptions)
}

function barChat(id, labels, bars, data){
    var barChartCanvas = $('#' + id).get(0).getContext('2d');
    var barChart = new Chart(barChartCanvas);
    barChartOptions.datasetFill = false;
    barChart.Bar(formatBarData(labels, bars, data), barChartOptions);
    return barChart;
}

function formatPieData(labels, data){
    var datasets = []
    data.forEach(function (value, index, arr) {
        var dataset = {
            value: arr[index],
            label: labels[index],
            color: chatColor[index],
            highlight: chatColor[index]
        };
        datasets.push(dataset);
    });
    return datasets;
}

function formatBarData(labels, bars, data) {
    var formatData = {};
    formatData.labels = labels;
    var datasets = [];
    data.forEach(function (value, index, arr) {
        console.log(bars[index]);
        var dataset = {
            label: bars[index],
            fillColor: chatColor[index],
            data: arr[index]
        }
        datasets.push(dataset);
    });
    console.log(datasets);
    formatData.datasets = datasets;
    return formatData;
}